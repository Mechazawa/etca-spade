#!/usr/bin/env sh
# One-time toolchain setup for this Spade / iCESugar project.
# Prerequisite: Rust installed via rustup (provides cargo).
set -eu

echo ">> Installing swim (the Spade build tool)…"
cargo install --git https://gitlab.com/spade-lang/swim

echo ">> Installing the OSS CAD Suite (yosys, nextpnr-ice40, icepack, …)."
echo ">> This is a large download (~2.5 GB)."
swim install-tools

echo ">> Done. Build with:  swim build      Flash with:  swim upload"
