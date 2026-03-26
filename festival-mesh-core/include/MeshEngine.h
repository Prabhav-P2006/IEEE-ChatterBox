#pragma once
#include <vector>
#include <string>
#include <memory>
#include <cstdint>
#include <functional>

namespace festival::mesh {

/**
 * @brief A single packet in the mesh network.
 *
 * Binary wire format:
 *   [1]  TTL
 *   [3]  msgId      (24-bit de-duplication ID)
 *   [3]  groupId    (24-bit fragmentation group ID)
 *   [1]  fragIdx    (0-based fragment index)
 *   [1]  fragTotal  (total number of fragments)
 *   [1]  senderLen  + [N] sender name
 *   [1]  destLen    + [N] destination name
 *   [1]  type       (0=handshake, 1=encrypted message fragment)
 *   [N]  payload
 */
struct MeshPacket {
    uint8_t  ttl       = 7;   // Festival-safe default (covers any venue in ≤5 hops)
    uint32_t msgId     = 0;   // Unique per link-layer broadcast
    uint32_t groupId   = 0;   // Shared across fragments of the same message
    uint8_t  fragIdx   = 0;
    uint8_t  fragTotal = 1;
    std::string sender;
    std::string destination;
    uint8_t  type      = 0;   // 0=handshake, 1=message
    std::vector<uint8_t> payload;

    std::vector<uint8_t> serialize() const;
    static MeshPacket deserialize(const std::vector<uint8_t>& data);
};

/**
 * @brief Transport-agnostic mesh routing engine.
 *
 * This class does NOT know about BLE, UDP, or any transport.
 * Call processIncoming() with raw bytes received from any transport.
 * Use the packet-ready callback to send bytes out on any transport.
 *
 * This design makes it callable from Flutter (dart:ffi) where Flutter
 * owns the BLE transport layer.
 */
class MeshEngine {
public:
    // Callbacks
    using SendCallback      = std::function<void(const std::vector<uint8_t>&)>;
    using MessageCallback   = std::function<void(const std::string& sender, const std::string& text)>;
    using HandshakeCallback = std::function<void(const std::string& peer)>;

    explicit MeshEngine(std::string nodeName);
    ~MeshEngine();

    // Feed incoming raw bytes from any transport (BLE, UDP, TCP…)
    void processIncoming(const std::vector<uint8_t>& raw);

    // Generate bytes to broadcast for a handshake initiation
    std::vector<uint8_t> buildHandshake(const std::string& destination);

    // Generate a list of fragment byte-arrays to broadcast for a message
    std::vector<std::vector<uint8_t>> buildMessage(const std::string& destination,
                                                    const std::string& text);

    // Register callbacks
    void onSendNeeded(SendCallback cb);       // called when this node needs to broadcast
    void onMessageReceived(MessageCallback cb);
    void onHandshakeComplete(HandshakeCallback cb);

    std::string nodeName() const;
    std::string getSafetyNumber(const std::string& peer);
    std::string getIdentityPublicKeyHex();

private:
    struct Impl;
    std::unique_ptr<Impl> impl_;
};

} // namespace festival::mesh
