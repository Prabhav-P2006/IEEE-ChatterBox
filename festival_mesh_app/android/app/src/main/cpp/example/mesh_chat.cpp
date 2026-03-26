/**
 * mesh_chat: Festival Mesh demo CLI
 *
 * Usage (simulation mode):  ./mesh_chat sim <name> <port>
 */
#include <iostream>
#include <string>
#include <thread>
#include <atomic>
#include <sstream>
#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <unistd.h>

#include "MeshEngine.h"

using namespace festival::mesh;

// ─── UDP Simulation Transport (5-node ring on 127.0.0.1:10000-10004) ─────────

struct SimTransport {
    MeshEngine& engine;
    uint16_t port;
    int sock = -1;
    std::atomic<bool> run{true};
    std::thread recvThread;

    SimTransport(MeshEngine& e, uint16_t p) : engine(e), port(p) {
        sock = socket(AF_INET, SOCK_DGRAM, 0);
        sockaddr_in addr{}; addr.sin_family = AF_INET;
        addr.sin_port = htons(port); addr.sin_addr.s_addr = INADDR_ANY;
        bind(sock, (sockaddr*)&addr, sizeof(addr));
        fcntl(sock, F_SETFL, O_NONBLOCK);

        // Wire engine → UDP broadcast
        engine.onSendNeeded([this](const std::vector<uint8_t>& data) {
            sockaddr_in dst{}; dst.sin_family = AF_INET;
            dst.sin_addr.s_addr = inet_addr("127.0.0.1");
            for (int p : {10000,10001,10002,10003,10004}) {
                if (p == this->port) continue;
                dst.sin_port = htons(p);
                sendto(this->sock, data.data(), data.size(), 0, (sockaddr*)&dst, sizeof(dst));
            }
        });

        recvThread = std::thread([this]{
            std::vector<uint8_t> buf(4096);
            while (run) {
                sockaddr_in from{}; socklen_t fl = sizeof(from);
                int n = recvfrom(sock, buf.data(), buf.size(), 0, (sockaddr*)&from, &fl);
                if (n > 0) try { engine.processIncoming({buf.begin(), buf.begin()+n}); } catch(...) {}
                std::this_thread::sleep_for(std::chrono::milliseconds(5));
            }
        });
    }

    ~SimTransport() {
        run = false;
        if (recvThread.joinable()) recvThread.join();
        if (sock >= 0) close(sock);
    }
};

// ─── Main ─────────────────────────────────────────────────────────────────────

int main(int argc, char** argv) {
    if (argc < 4 || std::string(argv[1]) != "sim") {
        std::cerr << "Usage: " << argv[0] << " sim <name> <port>\n";
        return 1;
    }

    std::string name = argv[2];
    uint16_t port = (uint16_t)std::stoi(argv[3]);

    auto engine = std::make_shared<MeshEngine>(name);

    engine->onMessageReceived([](const std::string& sender, const std::string& text) {
        std::cout << "\n[" << sender << "]: " << text << "\n> " << std::flush;
    });
    engine->onHandshakeComplete([](const std::string& peer) {
        std::cout << "\n[Handshake ✓ with " << peer << "]\n> " << std::flush;
    });

    std::unique_ptr<SimTransport> simT = std::make_unique<SimTransport>(*engine, port);
    std::cout << "Mesh '" << name << "' online (sim:" << port << ")\n";

    std::cout << "Your ID: " << engine->getIdentityPublicKeyHex() << "\n> " << std::flush;

    // ── CLI loop ──────────────────────────────────────────────────────────────
    std::string line;
    while (std::getline(std::cin, line)) {
        if (line == "q") break;
        if (line == "id") {
            std::cout << "Public Key: " << engine->getIdentityPublicKeyHex() << "\n";
        } else if (line.rfind("sn ", 0) == 0) {
            std::cout << "Safety Number for " << line.substr(3) << ": " 
                      << engine->getSafetyNumber(line.substr(3)) << "\n";
        } else if (line.rfind("h ", 0) == 0) {
            engine->buildHandshake(line.substr(2));
        } else if (line.rfind("m ", 0) == 0) {
            size_t sp = line.find(' ', 2);
            if (sp != std::string::npos) {
                try { engine->buildMessage(line.substr(2, sp-2), line.substr(sp+1)); }
                catch(const std::exception& e) { std::cerr << "[!] " << e.what() << "\n"; }
            }
        }
        std::cout << "> " << std::flush;
    }
    return 0;
}
