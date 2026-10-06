# helloworld

A CMake template project that builds a hello world program and library. Use it
as the starting point for new C++ projects.

```cpp
#include <akdev/helloworld.hpp>

auto greeting = akdev::helloworld::greet("CMake"); // "Hello, CMake!"
```

Other CMake projects can consume the installed library with:

```cmake
find_package(helloworld REQUIRED)
target_link_libraries(app PRIVATE akdev::helloworld)
```

## Layout

| Path                    | Purpose                                                    |
|-------------------------|------------------------------------------------------------|
| `CMakeLists.txt`        | Top-level build; project name and version live here        |
| `CMakePresets.json`     | `debug` / `release` presets, all building into `build/`    |
| `include/akdev/`        | Public headers (installed), e.g. `<akdev/helloworld.hpp>`  |
| `src/`                  | Library and program sources                                |
| `tests/`                | GoogleTest unit tests and CLI smoke tests (CTest)          |
| `docs/`                 | Doxygen configuration (`docs` target)                      |
| `cmake/`                | CMake helpers and templates                                |
| `packaging/helloworld.spec` | RPM spec                                               |
| `ci/`                   | Build/lint/test/docs/package scripts used locally and in CI |
| `Containerfile.builder` | The build environment (Fedora)                             |
| `.github/workflows/`    | CI on PRs/main, releases on SemVer tags                    |

## Building

Everything runs inside the builder container, so the only host requirement is
`podman` (or `docker`):

```sh
ci/container.sh ci/build.sh          # configure + build (debug preset)
ci/container.sh ci/test.sh           # build + run tests
ci/container.sh ci/lint.sh           # clang-format, clang-tidy, shellcheck
ci/container.sh ci/lint.sh --fix     # apply formatting / tidy fixes
ci/container.sh ci/docs.sh           # Doxygen -> build/debug/docs/html
ci/container.sh ci/package.sh        # RPMs -> build/rpm/
ci/container.sh                      # interactive shell in the builder
```

Pass `release` to `build.sh` / `test.sh` for an optimized build. With a local
toolchain you can use the presets directly:

```sh
cmake --workflow --preset debug
```

### CMake options

| Option                          | Default         | Description                      |
|---------------------------------|-----------------|----------------------------------|
| `HELLOWORLD_BUILD_TESTS`        | top-level only  | Build the test suite             |
| `HELLOWORLD_BUILD_DOCS`         | top-level only  | Add the `docs` target            |
| `HELLOWORLD_WARNINGS_AS_ERRORS` | `OFF` (presets: `ON`) | `-Werror`                  |
| `HELLOWORLD_ENABLE_CLANG_TIDY`  | `OFF`           | Run clang-tidy during the build  |

## Releasing

1. Bump `VERSION` in the `project()` call in `CMakeLists.txt`.
2. Tag and push: `git tag v1.2.3 && git push origin v1.2.3`.

The release workflow checks that the tag is valid SemVer and matches the CMake
version, runs the full CI, then publishes a GitHub release with the source
tarball, SRPM, RPMs and docs. Pre-release tags (`v1.2.3-rc.1`) are published as
pre-releases and packaged as RPM version `1.2.3~rc.1`.

## Starting a new project from this template

1. Rename the project: replace `helloworld` / `HELLOWORLD_` throughout (CMake
   files, `include/akdev/helloworld.hpp`, `include/akdev/helloworld/`,
   `packaging/helloworld.spec`, `cmake/helloworldConfig.cmake.in`, the
   `akdev::helloworld` namespace and CMake target).
2. Update `HOMEPAGE_URL` in `CMakeLists.txt` and `URL` in the spec (currently
   `https://github.com/akdev1l/cmake-template`).
3. Reset the version to `0.1.0` and the spec `%changelog`.
4. Adjust `LICENSE`, the spec's `License:` field and the SPDX headers if the
   new project uses a different license.

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
