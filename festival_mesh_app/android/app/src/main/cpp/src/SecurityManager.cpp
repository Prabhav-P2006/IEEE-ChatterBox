#include "SecurityManager.h"
#include "monocypher.h"
#include <iomanip>
#include <sstream>
#include <cstring>
#include <random>
#include <vector>

extern "C" {
    int sodium_init() { return 0; }
    void randombytes_buf(void * const buf, const size_t size) {
        std::random_device rd;
        uint8_t* p = (uint8_t*)buf;
        for (size_t i = 0; i < size; ++i) {
            p[i] = static_cast<uint8_t>(rd());
        }
    }
}

namespace festival::mesh {

struct SecurityManager::Impl {
    uint8_t public_key[32];
    uint8_t secret_key[32];
    uint8_t session_key[32];
    bool has_session = false;

    Impl() {
        // Generate a random secret key
        randombytes_buf(secret_key, 32);
        crypto_x25519_public_key(public_key, secret_key);
    }

    Impl(const uint8_t* pk, const uint8_t* sk) {
        std::memcpy(public_key, pk, 32);
        std::memcpy(secret_key, sk, 32);
        std::memset(session_key, 0, 32);
        has_session = false; 
    }
};

SecurityManager::SecurityManager() : impl_(std::make_unique<Impl>()) {}

SecurityManager::SecurityManager(const uint8_t* pk, const uint8_t* sk) 
    : impl_(std::make_unique<Impl>(pk, sk)) {}

SecurityManager::~SecurityManager() {
    if (impl_) {
        crypto_wipe(impl_->secret_key, 32);
        crypto_wipe(impl_->session_key, 32);
    }
}

SecurityManager::SecurityManager(SecurityManager&&) noexcept = default;
SecurityManager& SecurityManager::operator=(SecurityManager&&) noexcept = default;

std::vector<uint8_t> SecurityManager::getLocalPublicKey() const {
    return std::vector<uint8_t>(impl_->public_key, impl_->public_key + 32);
}

std::vector<uint8_t> SecurityManager::getLocalSecretKey() const {
    return std::vector<uint8_t>(impl_->secret_key, impl_->secret_key + 32);
}

std::string SecurityManager::getLocalPublicKeyHex() const {
    std::stringstream ss;
    ss << std::hex << std::setfill('0');
    for (int i = 0; i < 32; ++i) {
        ss << std::setw(2) << (int)impl_->public_key[i];
    }
    return ss.str();
}

void SecurityManager::computeSharedSecret(const std::vector<uint8_t>& peerPublicKey) {
    if (peerPublicKey.size() != 32) return;

    uint8_t raw_shared[32];
    crypto_x25519(raw_shared, impl_->secret_key, peerPublicKey.data());

    // Derive a proper session key using Blake2b (uniform distribution)
    crypto_blake2b(impl_->session_key, 32, raw_shared, 32);
    
    impl_->has_session = true;
    crypto_wipe(raw_shared, 32);
}

std::vector<uint8_t> SecurityManager::encrypt(const std::string& plaintext) {
    if (!impl_->has_session) return {};

    uint8_t nonce[24];
    randombytes_buf(nonce, 24);

    size_t pt_len = plaintext.length();
    // Output format: [NONCE 24][MAC 16][CIPHERTEXT PT_LEN]
    std::vector<uint8_t> ciphertext(24 + 16 + pt_len);

    std::memcpy(ciphertext.data(), nonce, 24);

    crypto_aead_lock(
        ciphertext.data() + 24 + 16,
        ciphertext.data() + 24,
        impl_->session_key,
        nonce,
        nullptr, 0,
        (const uint8_t*)plaintext.c_str(), pt_len
    );

    return ciphertext;
}

std::string SecurityManager::decrypt(const std::vector<uint8_t>& ciphertext) {
    if (!impl_->has_session || ciphertext.size() < (24 + 16)) return "";

    const uint8_t* nonce = ciphertext.data();
    const uint8_t* mac = ciphertext.data() + 24;
    const uint8_t* ct = ciphertext.data() + 24 + 16;
    size_t ct_len = ciphertext.size() - 24 - 16;

    std::vector<uint8_t> plaintext(ct_len);
    if (crypto_aead_unlock(
        plaintext.data(),
        mac,
        impl_->session_key,
        nonce,
        nullptr, 0,
        ct, ct_len
    ) != 0) {
        return ""; // Auth failed
    }

    return std::string((const char*)plaintext.data(), plaintext.size());
}

bool SecurityManager::hasSession() const {
    return impl_->has_session;
}

std::string SecurityManager::getSafetyNumber() const {
    auto pk = getLocalPublicKey();
    std::stringstream ss;
    ss << std::hex << std::setfill('0');
    // Simple verification number: first 8 bytes of PK
    for (int i = 0; i < 8; ++i) {
        ss << std::setw(2) << (int)pk[i];
    }
    return ss.str();
}

} // namespace festival::mesh
