#!/usr/bin/env bash
# Run a swim command inside a Linux x86_64 container, where swim's toolchain
# assumptions hold (correct wheel tag, GNU make, working cocotb-config). This
# sidesteps the macOS-native failures for `swim test`.
#
#   docker/swim.sh               # runs `swim test`
#   docker/swim.sh test add      # runs `swim test add` (pattern)
#   docker/swim.sh build         # any swim subcommand works
#
# The host's macOS build/ is left untouched: the container gets its own build/
# in a named volume, and the OSS CAD Suite + spade build are cached there and in
# a cargo cache volume, so only the first run is slow.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="etca-spade-swim"
PLATFORM="linux/amd64"                 # swim hardcodes the x86_64 wheel name
BUILD_VOL="etca-spade-linux-build"     # isolated Linux build/ (not the mac one)
CACHE_VOL="etca-spade-swim-cache"      # spade compiler build + cargo target

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo ">> building $IMAGE (one-time; compiles swim) ..."
    docker build --platform "$PLATFORM" -t "$IMAGE" "$REPO/docker"
fi

swim_args=("${@:-test}")
tty=(); [ -t 1 ] && tty=(-it)

exec docker run --rm "${tty[@]}" --platform "$PLATFORM" \
    -v "$REPO":/work \
    -v "$BUILD_VOL":/work/build \
    -v "$CACHE_VOL":/root/.cache \
    -w /work \
    "$IMAGE" \
    bash -c 'swim '"$(printf '%q ' "${swim_args[@]}")"
