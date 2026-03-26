#include "SecurityManager.h"
#include <sodium.h>
#include <stdexcept>
#include <sstream>
#include <iomanip>
#include <cstring>

namespace festival::mesh {

struct SecurityManager::Impl {
    unsigned char pk[crypto_kx_PUBLICKEYBYTES];
    unsigned char sk[crypto_kx_SECRETKEYBYTES];
    unsigned char rx[crypto_kx_SESSIONKEYBYTES]; // decrypt incoming
    unsigned char tx[crypto_kx_SESSIONKEYBYTES]; // encrypt outgoing
    bool has_session = false;

    Impl() {
        if (sodium_init() < 0) throw std::runtime_error("sodium_init failed");
        crypto_kx_keypair(pk, sk);
    }
    
    Impl(const uint8_t* p, const uint8_t* s) {
        if (sodium_init() < 0) throw std::runtime_error("sodium_init failed");
        memcpy(pk, p, crypto_kx_PUBLICKEYBYTES);
        memcpy(sk, s, crypto_kx_SECRETKEYBYTES);
    }
};

SecurityManager::SecurityManager() : impl_(std::make_unique<Impl>()) {}

SecurityManager::SecurityManager(const uint8_t* pk, const uint8_t* sk) 
    : impl_(std::make_unique<Impl>(pk, sk)) {}

SecurityManager::~SecurityManager() = default;

SecurityManager::SecurityManager(SecurityManager&&) noexcept = default;
SecurityManager& SecurityManager::operator=(SecurityManager&&) noexcept = default;

std::vector<uint8_t> SecurityManager::getLocalPublicKey() const {
    return {impl_->pk, impl_->pk + crypto_kx_PUBLICKEYBYTES};
}

std::vector<uint8_t> SecurityManager::getLocalSecretKey() const {
    return {impl_->sk, impl_->sk + crypto_kx_SECRETKEYBYTES};
}

std::string SecurityManager::getLocalPublicKeyHex() const {
    char hex[crypto_kx_PUBLICKEYBYTES * 2 + 1];
    sodium_bin2hex(hex, sizeof(hex), impl_->pk, crypto_kx_PUBLICKEYBYTES);
    return std::string(hex);
}

void SecurityManager::computeSharedSecret(const std::vector<uint8_t>& peerKey) {
    if (peerKey.size() != crypto_kx_PUBLICKEYBYTES)
        throw std::runtime_error("Invalid peer key size");

    // Deterministic role: smaller key = client, larger key = server
    if (memcmp(impl_->pk, peerKey.data(), crypto_kx_PUBLICKEYBYTES) < 0)
        crypto_kx_client_session_keys(impl_->rx, impl_->tx, impl_->pk, impl_->sk, peerKey.data());
    else
        crypto_kx_server_session_keys(impl_->rx, impl_->tx, impl_->pk, impl_->sk, peerKey.data());

    impl_->has_session = true;
}

std::vector<uint8_t> SecurityManager::encrypt(const std::string& plain) {
    if (!impl_->has_session) throw std::runtime_error("No session — handshake first");

    // Layout: [24-byte nonce][ciphertext + 16-byte MAC]
    std::vector<uint8_t> out(crypto_secretbox_NONCEBYTES + crypto_secretbox_MACBYTES + plain.size());
    auto* nonce = out.data();
    auto* ct    = out.data() + crypto_secretbox_NONCEBYTES;
    randombytes_buf(nonce, crypto_secretbox_NONCEBYTES);
    crypto_secretbox_easy(ct, (const uint8_t*)plain.data(), plain.size(), nonce, impl_->tx);
    return out;
}

std::string SecurityManager::decrypt(const std::vector<uint8_t>& pkt) {
    const size_t overhead = crypto_secretbox_NONCEBYTES + crypto_secretbox_MACBYTES;
    if (pkt.size() <= overhead) throw std::runtime_error("Packet too short");
    if (!impl_->has_session) throw std::runtime_error("No session");

    size_t ct_len = pkt.size() - crypto_secretbox_NONCEBYTES;
    std::string plain(ct_len - crypto_secretbox_MACBYTES, '\0');
    if (crypto_secretbox_open_easy((uint8_t*)plain.data(),
                                   pkt.data() + crypto_secretbox_NONCEBYTES,
                                   ct_len, pkt.data(), impl_->rx) != 0)
        throw std::runtime_error("Decryption failed — tampered or wrong key");
    return plain;
}

bool SecurityManager::hasSession() const { return impl_->has_session; }

std::string SecurityManager::getSafetyNumber() const {
    if (!impl_->has_session) return "N/A";
    
    // Combine RX and TX to make SN direction-independent (Alice.tx == Eve.rx, Alice.rx == Eve.tx)
    unsigned char combined[crypto_kx_SESSIONKEYBYTES];
    for (size_t i = 0; i < crypto_kx_SESSIONKEYBYTES; ++i) {
        combined[i] = impl_->rx[i] ^ impl_->tx[i];
    }

    std::ostringstream ss;
    for (int i = 0; i < 3; ++i) {
        uint16_t chunk;
        memcpy(&chunk, &combined[i * 2], 2);
        ss << std::setw(5) << std::setfill('0') << (chunk % 100000) << (i < 2 ? " " : "");
    }
    return ss.str();
}

} // namespace festival::mesh
