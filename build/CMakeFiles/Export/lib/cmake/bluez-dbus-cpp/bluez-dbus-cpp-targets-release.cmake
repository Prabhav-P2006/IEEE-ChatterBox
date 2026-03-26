#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "BlueZ::bluez-dbus-cpp" for configuration "Release"
set_property(TARGET BlueZ::bluez-dbus-cpp APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(BlueZ::bluez-dbus-cpp PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libbluez-dbus-cpp.so.0.0.1"
  IMPORTED_SONAME_RELEASE "libbluez-dbus-cpp.so.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS BlueZ::bluez-dbus-cpp )
list(APPEND _IMPORT_CHECK_FILES_FOR_BlueZ::bluez-dbus-cpp "${_IMPORT_PREFIX}/lib/libbluez-dbus-cpp.so.0.0.1" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
