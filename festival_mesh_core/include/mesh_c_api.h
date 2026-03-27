/**
 * @file mesh_c_api.h
 * @brief Pure C API for Flutter dart:ffi integration.
 *
 * This is the ONLY header Flutter needs. All C++ internals are hidden.
 *
 * Dart FFI usage:
 *   final lib = DynamicLibrary.open('libfestivalmesh.so');
 *   final create = lib.lookupFunction<MeshHandle Function(Pointer<Utf8>), ...>('mesh_create');
 */
#pragma once
#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>

/* Opaque handle — one per node */
typedef void* mesh_handle;

/* Callback types (safe to use from Dart isolates) */
typedef void (*mesh_message_cb)(const char* sender, const char* text, void* userdata);
typedef void (*mesh_handshake_cb)(const char* peer, void* userdata);
/** Called when the engine wants to broadcast bytes on any transport.
 *  Flutter should forward these bytes over BLE / UDP. */
typedef void (*mesh_send_cb)(const uint8_t* data, int len, void* userdata);

/* ── Lifecycle ─────────────────────────────────────────────────── */

/** Create a mesh node. @param node_name Your display name (UTF-8). */
mesh_handle mesh_create(const char* node_name);

/** Destroy a mesh node and free all resources. */
void mesh_destroy(mesh_handle h);

/* ── Callbacks ─────────────────────────────────────────────────── */

void mesh_set_on_send    (mesh_handle h, mesh_send_cb      cb, void* userdata);
void mesh_set_on_message (mesh_handle h, mesh_message_cb   cb, void* userdata);
void mesh_set_on_handshake(mesh_handle h, mesh_handshake_cb cb, void* userdata);

/* ── Receiving ─────────────────────────────────────────────────── */

/**
 * Feed raw bytes into the engine (received from BLE/transport by Flutter).
 * The engine will route/decrypt and fire the appropriate callback.
 */
void mesh_process_packet(mesh_handle h, const uint8_t* data, int len);

/* ── Sending ───────────────────────────────────────────────────── */

/**
 * Initiate a key-exchange handshake with a peer.
 * The mesh_send_cb will be triggered with the bytes to broadcast.
 */
void mesh_send_handshake(mesh_handle h, const char* destination);

/**
 * Send an encrypted message (requires prior handshake with destination).
 * The mesh_send_cb may be triggered multiple times (one per fragment).
 * Returns 0 on success, -1 if no session with destination.
 */
int mesh_send_message(mesh_handle h, const char* destination, const char* text);

/* ── Info ──────────────────────────────────────────────────────── */

/** Get the node's public key as hex (for QR code display). */
const char* mesh_get_public_key_hex(mesh_handle h);

/** Get the safety number for MITM verification (show in UI). Returns "N/A" if no session. */
const char* mesh_get_safety_number(mesh_handle h, const char* peer);

#ifdef __cplusplus
}
#endif
