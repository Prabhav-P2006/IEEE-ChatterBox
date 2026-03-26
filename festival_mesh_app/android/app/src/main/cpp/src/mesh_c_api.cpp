#include "mesh_c_api.h"
#include "MeshEngine.h"
#include "SecurityManager.h"

#include <string>
#include <cstring>
#include <stdexcept>

struct MeshNode {
    festival::mesh::MeshEngine engine;

    mesh_send_cb       send_cb   = nullptr;
    mesh_message_cb    msg_cb    = nullptr;
    mesh_handshake_cb  hs_cb     = nullptr;
    void* send_ud   = nullptr;
    void* msg_ud    = nullptr;
    void* hs_ud     = nullptr;

    // Cached string returns (kept alive until next call)
    std::string pubkey_hex_cache;
    std::string safety_cache;

    explicit MeshNode(const char* name)
        : engine(std::string(name)) {
        // Wire engine callbacks to our C callbacks
        engine.onSendNeeded([this](const std::vector<uint8_t>& data) {
            if (send_cb) send_cb(data.data(), (int)data.size(), send_ud);
        });
        engine.onMessageReceived([this](const std::string& sender, const std::string& text) {
            if (msg_cb) msg_cb(sender.c_str(), text.c_str(), msg_ud);
        });
        engine.onHandshakeComplete([this](const std::string& peer) {
            if (hs_cb) hs_cb(peer.c_str(), hs_ud);
        });
    }
};


static inline MeshNode* N(mesh_handle h) { return static_cast<MeshNode*>(h); }


mesh_handle mesh_create(const char* node_name) {
    if (!node_name || !*node_name) return nullptr;
    try { return new MeshNode(node_name); } catch (...) { return nullptr; }
}

void mesh_destroy(mesh_handle h) { delete N(h); }

void mesh_set_on_send(mesh_handle h, mesh_send_cb cb, void* ud)       { N(h)->send_cb = cb; N(h)->send_ud = ud; }
void mesh_set_on_message(mesh_handle h, mesh_message_cb cb, void* ud)  { N(h)->msg_cb  = cb; N(h)->msg_ud  = ud; }
void mesh_set_on_handshake(mesh_handle h, mesh_handshake_cb cb, void* ud){ N(h)->hs_cb  = cb; N(h)->hs_ud  = ud; }

void mesh_process_packet(mesh_handle h, const uint8_t* data, int len) {
    try { N(h)->engine.processIncoming({data, data + len}); } catch (...) {}
}

void mesh_send_handshake(mesh_handle h, const char* destination) {
    try { N(h)->engine.buildHandshake(destination); } catch (...) {}
}

int mesh_send_message(mesh_handle h, const char* destination, const char* text) {
    try {
        N(h)->engine.buildMessage(destination, text);
        return 0;
    } catch (...) {
        return -1;
    }
}

const char* mesh_get_public_key_hex(mesh_handle h) {
    auto& node = *N(h);
    node.pubkey_hex_cache = node.engine.getIdentityPublicKeyHex();
    return node.pubkey_hex_cache.c_str();
}

const char* mesh_get_safety_number(mesh_handle h, const char* peer) {
    if (!peer) return "N/A";
    auto& node = *N(h);
    node.safety_cache = node.engine.getSafetyNumber(peer);
    return node.safety_cache.c_str();
}
