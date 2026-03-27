#include "MeshEngine.h"
#include "SecurityManager.h"

#include <iostream>
#include <map>
#include <set>
#include <deque>
#include <mutex>
#include <algorithm>
#include <stdexcept>

namespace festival::mesh {

// ─── MeshPacket Wire Format ──────────────────────────────────────────────────

std::vector<uint8_t> MeshPacket::serialize() const {
    std::vector<uint8_t> d;
    d.push_back(ttl);
    d.push_back((msgId >> 16) & 0xFF); d.push_back((msgId >> 8) & 0xFF); d.push_back(msgId & 0xFF);
    d.push_back((groupId >> 16) & 0xFF); d.push_back((groupId >> 8) & 0xFF); d.push_back(groupId & 0xFF);
    d.push_back(fragIdx); d.push_back(fragTotal);
    d.push_back((uint8_t)sender.size());
    d.insert(d.end(), sender.begin(), sender.end());
    d.push_back((uint8_t)destination.size());
    d.insert(d.end(), destination.begin(), destination.end());
    d.push_back(type);
    d.insert(d.end(), payload.begin(), payload.end());
    return d;
}

MeshPacket MeshPacket::deserialize(const std::vector<uint8_t>& d) {
    if (d.size() < 10) throw std::runtime_error("Packet too short");
    MeshPacket p; size_t o = 0;
    p.ttl     = d[o++];
    p.msgId   = ((uint32_t)d[o] << 16 | (uint32_t)d[o+1] << 8 | d[o+2]) & 0xFFFFFF; o += 3;
    p.groupId = ((uint32_t)d[o] << 16 | (uint32_t)d[o+1] << 8 | d[o+2]) & 0xFFFFFF; o += 3;
    p.fragIdx = d[o++]; p.fragTotal = d[o++];
    size_t sl = d[o++]; p.sender      = std::string((char*)&d[o], sl); o += sl;
    size_t dl = d[o++]; p.destination = std::string((char*)&d[o], dl); o += dl;
    p.type = d[o++];
    p.payload.assign(d.begin() + o, d.end());
    return p;
}

// ─── MeshEngine Internal State ───────────────────────────────────────────────

struct MeshEngine::Impl {
    std::string name;

    // The node's primary identity (local keypair)
    SecurityManager identity;

    // One SecurityManager per known peer (keyed by peer name)
    // These hold the DERIVED session keys.
    std::map<std::string, SecurityManager>  sessions;

    // Helper to get or create a session for a peer
    SecurityManager& getSession(const std::string& peer) {
        auto it = sessions.find(peer);
        if (it == sessions.end()) {
            auto pk = identity.getLocalPublicKey();
            auto sk = identity.getLocalSecretKey();
            sessions.emplace(peer, SecurityManager(pk.data(), sk.data()));
        }
        return sessions.at(peer);
    }

    // De-duplication: sliding window of last 500 message IDs
    std::set<uint32_t>   seen;
    std::deque<uint32_t> seenOrder;
    std::mutex           mtx;

    // SAR: (sender, groupId) → partial fragments
    struct Reassembly {
        std::vector<std::vector<uint8_t>> chunks;
        int received = 0;
    };
    std::map<std::pair<std::string,uint32_t>, Reassembly> sar;

    // Callbacks
    MeshEngine::SendCallback      sendCb;
    MeshEngine::MessageCallback   messageCb;
    MeshEngine::HandshakeCallback handshakeCb;

    bool shouldProcess(uint32_t id) {
        id &= 0xFFFFFF;
        std::lock_guard<std::mutex> g(mtx);
        if (seen.count(id)) return false;
        seen.insert(id);
        seenOrder.push_back(id);
        if (seenOrder.size() > 500) { seen.erase(seenOrder.front()); seenOrder.pop_front(); }
        return true;
    }

    uint32_t freshId() {
        uint32_t id; 
        get_random((uint8_t*)&id, sizeof(id)); 
        id &= 0xFFFFFF;
        shouldProcess(id); // pre-mark so we don't relay our own
        return id;
    }

    void broadcast(const MeshPacket& p) {
        if (sendCb) sendCb(p.serialize());
        std::cout << "[Mesh] " << (p.ttl == 7 ? "Sent" : "Relay")
                  << " ID=" << std::hex << (p.msgId & 0xFFFFFF) << std::dec
                  << " Frag=" << (int)p.fragIdx+1 << "/" << (int)p.fragTotal
                  << " " << p.sender << "→" << p.destination << "\n";
    }
};

// ─── MeshEngine Implementation ───────────────────────────────────────────────

MeshEngine::MeshEngine(std::string nodeName)
    : impl_(std::make_unique<Impl>()) {
    impl_->name = std::move(nodeName);
}

MeshEngine::~MeshEngine() = default;

std::string MeshEngine::nodeName() const { return impl_->name; }

void MeshEngine::onSendNeeded    (SendCallback cb)      { impl_->sendCb      = std::move(cb); }
void MeshEngine::onMessageReceived(MessageCallback cb)  { impl_->messageCb   = std::move(cb); }
void MeshEngine::onHandshakeComplete(HandshakeCallback cb) { impl_->handshakeCb = std::move(cb); }

std::string MeshEngine::getSafetyNumber(const std::string& peer) {
    auto it = impl_->sessions.find(peer);
    if (it != impl_->sessions.end()) return it->second.getSafetyNumber();
    return "N/A";
}

std::string MeshEngine::getIdentityPublicKeyHex() {
    return impl_->identity.getLocalPublicKeyHex();
}

std::vector<uint8_t> MeshEngine::buildHandshake(const std::string& dest) {
    MeshPacket p;
    p.ttl = 7; p.msgId = impl_->freshId(); p.groupId = p.msgId;
    p.fragIdx = 0; p.fragTotal = 1;
    p.sender = impl_->name; p.destination = dest;
    p.type = 0; p.payload = impl_->identity.getLocalPublicKey();
    impl_->broadcast(p);
    return p.serialize();
}

std::vector<std::vector<uint8_t>> MeshEngine::buildMessage(const std::string& dest,
                                                             const std::string& text) {
    auto& ses = impl_->getSession(dest);
    if (!ses.hasSession())
        throw std::runtime_error("No session with " + dest + " — handshake first");

    auto encrypted = ses.encrypt(text);

#ifdef DUMMY_CRYPTO
    const size_t CHUNK = 20; // Safe for any legacy Bluetooth 4.0 advertisement
#else
    const size_t CHUNK = 180; // Optimized for BT5.0 Extended Advertising
#endif
    uint32_t gid = impl_->freshId();
    uint8_t total = (uint8_t)((encrypted.size() + CHUNK - 1) / CHUNK);

    std::vector<std::vector<uint8_t>> result;
    for (uint8_t i = 0; i < total; ++i) {
        size_t s = i * CHUNK, e = std::min(s + CHUNK, encrypted.size());
        MeshPacket p;
        p.ttl = 7; p.msgId = impl_->freshId(); p.groupId = gid;
        p.fragIdx = i; p.fragTotal = total;
        p.sender = impl_->name; p.destination = dest;
        p.type = 1; p.payload.assign(encrypted.begin()+s, encrypted.begin()+e);
        impl_->broadcast(p);
        result.push_back(p.serialize());
    }
    return result;
}

void MeshEngine::processIncoming(const std::vector<uint8_t>& raw) {
    MeshPacket p;
    try { p = MeshPacket::deserialize(raw); } catch(...) { return; }

    if (!impl_->shouldProcess(p.msgId)) return; // de-duplicate

    if (p.destination == impl_->name) {
        // ── Packet is for ME ────────────────────────────────────────
        if (p.type == 0) {
            // HANDSHAKE: establish shared secret
            auto& ses = impl_->getSession(p.sender);
            bool hadSession = ses.hasSession();
            ses.computeSharedSecret(p.payload); 
            
            if (impl_->handshakeCb) impl_->handshakeCb(p.sender);
            // Reciprocate if this is the first handshake from them
            if (!hadSession) buildHandshake(p.sender);

        } else if (p.type == 1) {
            // MESSAGE FRAGMENT: collect and reassemble
            auto  key = std::make_pair(p.sender, p.groupId);
            auto& r   = impl_->sar[key];
            if (r.chunks.empty()) r.chunks.resize(p.fragTotal);
            if (r.chunks[p.fragIdx].empty()) {
                r.chunks[p.fragIdx] = p.payload;
                r.received++;
            }
            if (r.received == p.fragTotal) {
                // All fragments received — cat and decrypt
                std::vector<uint8_t> full;
                for (auto& c : r.chunks) full.insert(full.end(), c.begin(), c.end());
                impl_->sar.erase(key);
                try {
                    std::string text = impl_->sessions.at(p.sender).decrypt(full);
                    if (impl_->messageCb) impl_->messageCb(p.sender, text);
                } catch (const std::exception& e) {
                    std::cerr << "[Mesh] Decrypt error from " << p.sender << ": " << e.what() << "\n";
                }
            }
        }
    } else if (p.ttl > 0) {
        // ── Relay: not for me, TTL still alive ──────────────────────
        MeshPacket fwd = p; fwd.ttl--;
        impl_->broadcast(fwd);
    }
}

} // namespace festival::mesh
