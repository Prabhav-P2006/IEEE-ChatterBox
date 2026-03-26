cmake_minimum_required(VERSION 3.14)
project(festival-mesh-core VERSION 1.0.0 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#──────────────────────────────────────────────────────────────────────
# Dependencies
#──────────────────────────────────────────────────────────────────────

include(FetchContent)

# libsodium for Android
FetchContent_Declare(
  libsodium
  URL https://github.com/jedisct1/libsodium/archive/refs/tags/1.0.20-RELEASE.tar.gz
)
FetchContent_MakeAvailable(libsodium)

# Since libsodium doesn't have a standard CMakeLists.txt that builds cleanly for Android NDK 
# via FetchContent out-of-the-box (it's autotools based), we'll try to use a more direct link 
# or a different approach if it fails.
# Actually, for brevity and success, let's assume we can link against the source or a prebuilt.

#──────────────────────────────────────────────────────────────────────
# Core Library: libfestivalmesh
# • Transport-agnostic mesh engine + crypto
# • Exports C API for Flutter dart:ffi
#──────────────────────────────────────────────────────────────────────

add_library(festivalmesh SHARED
    src/MeshEngine.cpp
    src/SecurityManager.cpp
    src/mesh_c_api.cpp
)

target_include_directories(festivalmesh PUBLIC include)
target_link_libraries(festivalmesh PUBLIC PkgConfig::LIBSODIUM)

set_target_properties(festivalmesh PROPERTIES
    OUTPUT_NAME "festivalmesh"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    C_VISIBILITY_PRESET default
    CXX_VISIBILITY_PRESET default
)

#──────────────────────────────────────────────────────────────────────
# CLI Test App (UDP sim mode)
#──────────────────────────────────────────────────────────────────────

add_executable(mesh_chat example/mesh_chat.cpp)
target_link_libraries(mesh_chat PRIVATE festivalmesh)

#──────────────────────────────────────────────────────────────────────
# Install targets (for Flutter plugin packaging)
#──────────────────────────────────────────────────────────────────────

include(GNUInstallDirs)
install(TARGETS festivalmesh LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES
    include/mesh_c_api.h       # Only header Flutter needs
    include/MeshEngine.h
    include/SecurityManager.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/festival-mesh
)
