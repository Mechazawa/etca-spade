# Linux x86_64 environment for running `swim test` (cocotb).
#
# Why this exists: on macOS/arm64 swim (0.19.0-r330) hardcodes the spade cocotb
# helper wheel name to `...manylinux_2_34_x86_64.whl`, which pip rejects, and the
# cocotb Makefile flow needs GNU make + a working cocotb-config. All of those
# assumptions hold on x86_64 Linux, so we just run swim there.
#
# Must be built/run as linux/amd64 (the hardcoded wheel tag is x86_64); on arm64
# Linux the same mismatch reappears.
FROM rust:1-bookworm

# swim builds the spade compiler + python bindings at runtime, and OSS CAD Suite
# is a self-contained download — these cover both.
RUN apt-get update && apt-get install -y --no-install-recommends \
        git curl ca-certificates xz-utils build-essential \
        python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# The Spade build tool / package manager. Compiled once into the image.
RUN cargo install --git https://gitlab.com/spade-lang/swim swim
RUN swim install-tools

WORKDIR /work
