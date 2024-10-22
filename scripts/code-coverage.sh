#!/usr/bin/env bash

set -e

cwd=`pwd`
script_folder=`cd $(dirname $0) && pwd`
build_folder=$script_folder/../.build
output_folder=$script_folder/../.output

mkdir -p $output_folder

swift test --enable-code-coverage

# if in the CI environment, then use llvm-cov report instead
if [ -n "$CI" ]; then
  xcrun llvm-cov report \
    --ignore-filename-regex='(.build|Tests)[/\\].*' \
    -instr-profile "$(swift test --show-codecov-path | xargs dirname)/default.profdata" \
    .build/debug/sendkeysPackageTests.xctest/Contents/*/sendkeysPackageTests
  exit 0
fi

xcrun llvm-cov export \
  --format=lcov \
  --ignore-filename-regex='(.build|Tests)[/\\].*' \
  -instr-profile "$(swift test --show-codecov-path | xargs dirname)/default.profdata" \
  .build/debug/sendkeysPackageTests.xctest/Contents/*/sendkeysPackageTests > "$output_folder/coverage.lcov"

genhtml -o "$output_folder/coverage" "$output_folder/coverage.lcov"

open "file://$output_folder/coverage/index.html"
