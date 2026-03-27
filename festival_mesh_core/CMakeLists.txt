cmake_minimum_required(VERSION 3.14)
project(festival_mesh_core VERSION 1.0.0 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(festivalmesh SHARED
    src/MeshEngine.cpp
    src/SecurityManager.cpp
    src/mesh_c_api.cpp
    src/monocypher.c
)

target_include_directories(festivalmesh PUBLIC include)

# Use monocypher for all platforms to avoid linking issues
target_compile_definitions(festivalmesh PRIVATE USING_MONOCYPHER=1)

set_target_properties(festivalmesh PROPERTIES
    OUTPUT_NAME "festivalmesh"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    C_VISIBILITY_PRESET default
    CXX_VISIBILITY_PRESET default
)

add_executable(mesh_chat example/mesh_chat.cpp)
target_link_libraries(mesh_chat PRIVATE festivalmesh)

# Tests
add_executable(mesh_test tests/mesh_test.cpp)
target_link_libraries(mesh_test PRIVATE festivalmesh)

include(GNUInstallDirs)
install(TARGETS festivalmesh LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES
    include/mesh_c_api.h
    include/MeshEngine.h
    include/SecurityManager.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/festival-mesh
)
