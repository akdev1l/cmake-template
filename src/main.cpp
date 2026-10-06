// SPDX-License-Identifier: GPL-3.0-or-later

#include <akdev/helloworld.hpp>

#include <cstddef>
#include <iostream>
#include <span>
#include <string_view>

namespace hw = akdev::helloworld;

int main(int argc, char **argv) {
  const auto args = std::span(argv, static_cast<std::size_t>(argc)).subspan(1);

  if (args.empty()) {
    std::cout << hw::greet() << '\n';
    return 0;
  }

  const std::string_view arg{args.front()};
  if (arg == "--version" || arg == "-v") {
    std::cout << "helloworld " << hw::version << '\n';
    return 0;
  }

  std::cout << hw::greet(arg) << '\n';
  return 0;
}
