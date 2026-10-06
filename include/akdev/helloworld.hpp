// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once

/**
 * @file
 * @brief Public API of the helloworld library.
 *
 * @code
 * #include <akdev/helloworld.hpp>
 * @endcode
 */

#include <akdev/helloworld/version.hpp>

#include <string>
#include <string_view>

/// @namespace akdev
/// @brief Root namespace for akdev projects.

/// @brief The helloworld library.
namespace akdev::helloworld {

/**
 * @brief Build a greeting for @p name.
 *
 * @param name Who to greet. Defaults to "world".
 * @return The greeting, e.g. "Hello, world!".
 */
[[nodiscard]] std::string greet(std::string_view name = "world");

} // namespace akdev::helloworld
