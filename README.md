# Festival Mesh: Secure P2P Multi-Hop Messenger

A decentralized "Zero-Bar" messenger for festivals and dense crowds where cell service is non-existent. It roots messages through a multi-hop mesh network using only Bluetooth and other local P2P transports.

### Architecture

The system is split into two layers:
- **Mobile Frontend (`/festival_mesh_app`)**: Built with Flutter. Handles the UI, OS permissions, and the physical P2P transport layer (Nearby Connections / Multipeer Connectivity).
- **Core Engine (`/festival_mesh_core`)**: Pure C++ library. Handles the mesh routing logic, packet fragmentation, and end-to-end encryption. FFI is used to bridge the two.

### Security (E2EE)
Messages are fully encrypted end-to-end (X25519 + ChaCha20-Poly1305 via Monocypher). Key exchange happens either via QR code scanning or through safety-number verification for in-mesh handshakes.

### Getting Started
1. Build the C++ core: `cd festival_mesh_core && mkdir build && cd build && cmake .. && make`
2. Run the Flutter app: `cd festival_mesh_app && flutter run`

### Folder Structure
- `festival_mesh_app/`: UI and Transport (Flutter)
- `festival_mesh_core/`: Mesh Engine and Crypto (C++)
