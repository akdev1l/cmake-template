#!/usr/bin/env bash
# Run clang-format, clang-tidy and shellcheck.
# Usage: ci/lint.sh [--fix]   (--fix rewrites files instead of failing)
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

FIX=0
[[ "${1:-}" == "--fix" ]] && FIX=1

mapfile -t cxx_files < <(find include src tests -type f \
    \( -name '*.hpp' -o -name '*.h' -o -name '*.cpp' -o -name '*.cc' \) | sort)

log "clang-format (${#cxx_files[@]} files)"
if ((FIX)); then
    clang-format -i "${cxx_files[@]}"
else
    clang-format --dry-run --Werror "${cxx_files[@]}"
fi

log "clang-tidy"
cmake --preset debug >/dev/null
tidy_args=(-p build/debug -quiet)
if ((FIX)); then
    tidy_args+=(-fix -format)
else
    tidy_args+=(-warnings-as-errors='*')
fi
run-clang-tidy "${tidy_args[@]}" "$ROOT_DIR/(src|tests)/.*"

log "shellcheck"
shellcheck -x ci/*.sh

log "Lint passed"
