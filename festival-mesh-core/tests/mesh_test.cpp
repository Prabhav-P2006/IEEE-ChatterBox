#include "MeshEngine.h"
#include <iostream>
#include <vector>
#include <string>
#include <cassert>

using namespace festival::mesh;

void test_fragmentation() {
    std::cout << "[Test] Fragmentation & Reassembly..." << std::endl;
    MeshEngine alice("Alice");
    MeshEngine bob("Bob");

    // Mock direct link: pipe bytes from Alice to Bob
    alice.onSendNeeded([&](const std::vector<uint8_t>& data) {
        bob.processIncoming(data);
    });

    bool handed_over = false;
    bob.onHandshakeComplete([&](const std::string& sender) {
        handed_over = true;
        assert(sender == "Alice");
    });

    // 1. Initial Handshake
    alice.buildHandshake("Bob");
    assert(handed_over);

    // 2. Large Message (Trigger fragmentation)
    std::string long_text = "This is a very long message that is guaranteed to be fragmented "
                           "because it exceeds the default CHUNK size of the mesh engine. "
                           "We want to ensure that all pieces arrive and are reassembled correctly.";
    
    std::string received_text;
    bob.onMessageReceived([&](const std::string& sender, const std::string& text) {
        received_text = text;
        assert(sender == "Alice");
    });

    alice.buildMessage("Bob", long_text);
    assert(received_text == long_text);
    std::cout << "[Test] SUCCESS: Reassembled " << long_text.size() << " bytes." << std::endl;
}

void test_ttl_and_relaying() {
    std::cout << "[Test] TTL & Relaying..." << std::endl;
    MeshEngine alice("Alice");
    MeshEngine eve("Eve");
    MeshEngine bob("Bob");

    // Link: Alice -> Eve -> Bob (Eve relays)
    alice.onSendNeeded([&](const std::vector<uint8_t>& data) {
        eve.processIncoming(data);
    });
    eve.onSendNeeded([&](const std::vector<uint8_t>& data) {
        bob.processIncoming(data);
    });

    bool bob_received = false;
    bob.onHandshakeComplete([&](const std::string& peer) {
        bob_received = true;
    });

    alice.buildHandshake("Bob");
    assert(bob_received);
    std::cout << "[Test] SUCCESS: Eve relayed handshake." << std::endl;
}

int main() {
    try {
        test_fragmentation();
        test_ttl_and_relaying();
        std::cout << "\nALL CORE TESTS PASSED!" << std::endl;
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "CORE TEST FAILED: " << e.what() << std::endl;
        return 1;
    }
}
