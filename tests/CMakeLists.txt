find_package(GTest REQUIRED)
include(GoogleTest)

add_executable(helloworld_tests test_helloworld.cpp)
target_link_libraries(helloworld_tests PRIVATE akdev::helloworld GTest::gtest_main)
helloworld_set_warnings(helloworld_tests)
gtest_discover_tests(helloworld_tests)

# Smoke tests for the CLI.
add_test(NAME cli.default COMMAND helloworld)
set_tests_properties(cli.default PROPERTIES PASS_REGULAR_EXPRESSION "^Hello, world!\n$")

add_test(NAME cli.name COMMAND helloworld CMake)
set_tests_properties(cli.name PROPERTIES PASS_REGULAR_EXPRESSION "^Hello, CMake!\n$")

add_test(NAME cli.version COMMAND helloworld --version)
set_tests_properties(cli.version PROPERTIES PASS_REGULAR_EXPRESSION
                                            "^helloworld ${PROJECT_VERSION}\n$")
