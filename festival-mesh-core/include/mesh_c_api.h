#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stddef.h>

typedef void* mesh_handle;

typedef void (*mesh_message_cb)(const char* sender, const char* text, void* userdata);
typedef void (*mesh_handshake_cb)(const char* peer, void* userdata);
typedef void (*mesh_send_cb)(const uint8_t* data, int len, void* userdata);

// Lifecycle
mesh_handle mesh_create(const char* node_name);
void mesh_destroy(mesh_handle h);

// Callbacks
void mesh_set_on_send(mesh_handle h, mesh_send_cb cb, void* userdata);
void mesh_set_on_message(mesh_handle h, mesh_message_cb cb, void* userdata);
void mesh_set_on_handshake(mesh_handle h, mesh_handshake_cb cb, void* userdata);

// Processing incoming bytes
void mesh_process_packet(mesh_handle h, const uint8_t* data, int len);

// Operations
void mesh_send_handshake(mesh_handle h, const char* destination);
int mesh_send_message(mesh_handle h, const char* destination, const char* text);

// Information
const char* mesh_get_public_key_hex(mesh_handle h);
const char* mesh_get_safety_number(mesh_handle h, const char* peer);

#ifdef __cplusplus
}
#endif
