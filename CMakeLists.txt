cmake_minimum_required(VERSION 3.25)

project(
  helloworld
  VERSION 0.1.0
  DESCRIPTION "Hello world program built from the CMake template"
  HOMEPAGE_URL "https://github.com/akdev1l/cmake-template"
  LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

# ---------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------
option(HELLOWORLD_BUILD_TESTS "Build the test suite" ${PROJECT_IS_TOP_LEVEL})
option(HELLOWORLD_BUILD_DOCS "Add the 'docs' target (requires Doxygen)" ${PROJECT_IS_TOP_LEVEL})
option(HELLOWORLD_WARNINGS_AS_ERRORS "Treat compiler warnings as errors" OFF)
option(HELLOWORLD_ENABLE_CLANG_TIDY "Run clang-tidy as part of the build" OFF)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(HELLOWORLD_ENABLE_CLANG_TIDY)
  find_program(CLANG_TIDY_EXE NAMES clang-tidy REQUIRED)
  set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_EXE}")
endif()

include(GNUInstallDirs)
include(CompilerWarnings)

# ---------------------------------------------------------------------------
# Library: akdev::helloworld, public header <akdev/helloworld.hpp>
# ---------------------------------------------------------------------------
configure_file(cmake/version.hpp.in
               "${PROJECT_BINARY_DIR}/generated/include/akdev/helloworld/version.hpp" @ONLY)

add_library(helloworld_lib src/helloworld.cpp)
add_library(akdev::helloworld ALIAS helloworld_lib)
target_include_directories(
  helloworld_lib
  PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
         $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/generated/include>
         $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
target_compile_features(helloworld_lib PUBLIC cxx_std_20)
set_target_properties(
  helloworld_lib
  PROPERTIES OUTPUT_NAME helloworld
             EXPORT_NAME helloworld
             VERSION ${PROJECT_VERSION}
             SOVERSION ${PROJECT_VERSION_MAJOR})
helloworld_set_warnings(helloworld_lib)

# ---------------------------------------------------------------------------
# Executable
# ---------------------------------------------------------------------------
add_executable(helloworld src/main.cpp)
target_link_libraries(helloworld PRIVATE akdev::helloworld)
helloworld_set_warnings(helloworld)

# ---------------------------------------------------------------------------
# Tests / docs
# ---------------------------------------------------------------------------
if(HELLOWORLD_BUILD_TESTS)
  enable_testing()
  add_subdirectory(tests)
endif()

if(HELLOWORLD_BUILD_DOCS)
  add_subdirectory(docs)
endif()

# ---------------------------------------------------------------------------
# Install / export: find_package(helloworld) -> akdev::helloworld
# ---------------------------------------------------------------------------
include(CMakePackageConfigHelpers)

install(TARGETS helloworld RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(
  TARGETS helloworld_lib
  EXPORT helloworldTargets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(DIRECTORY include/ "${PROJECT_BINARY_DIR}/generated/include/"
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

set(HELLOWORLD_CMAKE_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/helloworld)
install(
  EXPORT helloworldTargets
  NAMESPACE akdev::
  DESTINATION ${HELLOWORLD_CMAKE_DIR})
configure_package_config_file(
  cmake/helloworldConfig.cmake.in "${PROJECT_BINARY_DIR}/helloworldConfig.cmake"
  INSTALL_DESTINATION ${HELLOWORLD_CMAKE_DIR})
write_basic_package_version_file(
  "${PROJECT_BINARY_DIR}/helloworldConfigVersion.cmake"
  COMPATIBILITY SameMajorVersion)
install(FILES "${PROJECT_BINARY_DIR}/helloworldConfig.cmake"
              "${PROJECT_BINARY_DIR}/helloworldConfigVersion.cmake"
        DESTINATION ${HELLOWORLD_CMAKE_DIR})
