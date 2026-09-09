#!/usr/bin/env bash
set -euo pipefail

# Build one native target and stage its shared libraries. Pass a Meson cross
# file for a non-host target, or no argument for the host platform.
cross_file="${1:-}"
source_dir="native"
build_dir="${BUILD_DIR:-native/build-ci}"
output_dir="${OUTPUT_DIR:-native/build-output}"

rm -rf "$build_dir"
mkdir -p "$output_dir"

meson_args=(setup "$build_dir" "$source_dir" -Dbuildtype=release -Db_lto=true -Duse_local_jni=true)
if [[ -n "$cross_file" ]]; then
  meson_args+=(--cross-file "$cross_file")
fi

meson "${meson_args[@]}"
meson compile -C "$build_dir"

find "$build_dir" -maxdepth 1 -type f \( -name '*.dll' -o -name '*.dylib' -o -name '*.so' \) -exec cp {} "$output_dir" \;
