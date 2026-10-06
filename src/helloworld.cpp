// SPDX-License-Identifier: GPL-3.0-or-later

#include <akdev/helloworld.hpp>

#include <string>
#include <string_view>

namespace akdev::helloworld {

std::string greet(std::string_view name) {
  std::string greeting{"Hello, "};
  greeting.append(name);
  greeting.push_back('!');
  return greeting;
}

} // namespace akdev::helloworld
