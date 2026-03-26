#pragma once
#include <vector>
#include <string>
#include <memory>
#include <cstdint>

namespace festival::mesh {

/**
 * @brief Handles all cryptographic operations for the mesh network.
 * 
 * Uses libsodium's X25519 key exchange (crypto_kx) + XSalsa20-Poly1305 encryption.
 * PIMPL pattern hides all libsodium types from this header.
 */
class SecurityManager {
public:
    SecurityManager();
    SecurityManager(const uint8_t* pk, const uint8_t* sk);
    ~SecurityManager();

    // Movable but not copyable (due to PIMPL unique_ptr)
    SecurityManager(SecurityManager&&) noexcept;
    SecurityManager& operator=(SecurityManager&&) noexcept;
    SecurityManager(const SecurityManager&) = delete;
    SecurityManager& operator=(const SecurityManager&) = delete;

    // Key Exchange
    std::vector<uint8_t> getLocalPublicKey() const;
    std::vector<uint8_t> getLocalSecretKey() const;
    std::string getLocalPublicKeyHex() const;
    void computeSharedSecret(const std::vector<uint8_t>& peerPublicKey);

    // Encryption / Decryption
    std::vector<uint8_t> encrypt(const std::string& plaintext);
    std::string decrypt(const std::vector<uint8_t>& ciphertext);

    // Session state
    bool hasSession() const;

    // Human-verifiable fingerprint for MITM detection (QR code / voice verify)
    std::string getSafetyNumber() const;

private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
};

} // namespace festival::mesh
