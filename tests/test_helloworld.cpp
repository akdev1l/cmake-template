// SPDX-License-Identifier: GPL-3.0-or-later

#include <akdev/helloworld.hpp>

#include <gtest/gtest.h>

namespace {

namespace hw = akdev::helloworld;

TEST(Greet, DefaultsToWorld) { EXPECT_EQ(hw::greet(), "Hello, world!"); }

TEST(Greet, UsesGivenName) { EXPECT_EQ(hw::greet("CMake"), "Hello, CMake!"); }

TEST(Greet, HandlesEmptyName) { EXPECT_EQ(hw::greet(""), "Hello, !"); }

TEST(Version, IsNotEmpty) { EXPECT_FALSE(hw::version.empty()); }

} // namespace
