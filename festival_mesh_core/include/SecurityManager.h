#pragma once
#include <vector>
#include <string>
#include <memory>
#include <cstdint>

#define crypto_kx_PUBLICKEYBYTES 32
#define crypto_kx_SECRETKEYBYTES 32
#define crypto_kx_SESSIONKEYBYTES 32
#define crypto_secretbox_NONCEBYTES 24
#define crypto_secretbox_MACBYTES 16

namespace festival::mesh {
    // Utility for random data (Platform specific implementation in .cpp)
    void get_random(uint8_t* buf, size_t size);
}

namespace festival::mesh {

class SecurityManager {
public:
    SecurityManager();
    SecurityManager(const uint8_t* pk, const uint8_t* sk);
    ~SecurityManager();

    // Movable but not copyable
    SecurityManager(SecurityManager&&) noexcept;
    SecurityManager& operator=(SecurityManager&&) noexcept;
    SecurityManager(const SecurityManager&) = delete;
    SecurityManager& operator=(const SecurityManager&) = delete;

    // Key Exchange (X25519)
    std::vector<uint8_t> getLocalPublicKey() const;
    std::vector<uint8_t> getLocalSecretKey() const;
    std::string getLocalPublicKeyHex() const;
    void computeSharedSecret(const std::vector<uint8_t>& peerPublicKey);

    // Encryption / Decryption (ChaCha20-Poly1305)
    std::vector<uint8_t> encrypt(const std::string& plaintext);
    std::string decrypt(const std::vector<uint8_t>& ciphertext);

    // Session state
    bool hasSession() const;

    // Fingerprint
    std::string getSafetyNumber() const;

private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
};

} // namespace festival::mesh
