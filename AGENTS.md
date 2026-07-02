# AGENTS.md

Spade HDL project targeting the **iCESugar v1.5** FPGA board.

## Working agreement for AI assistants (read first)

This is a **human-made** project. The point is for the human to learn Spade and
FPGA design by writing it themselves. Any AI assistant (Claude Code included)
is here to **assist, not author**. You may:

- explain concepts, Spade/Verilog syntax, and toolchain/board behaviour;
- help debug: read errors, logs, timing reports, and waveforms and reason about causes;
- answer questions, review code the human has written, and suggest approaches.

You may **not** write or edit the project's HDL/source or build config
autonomously. Do not generate, add, or refactor `.spade` files or `swim.toml`
on the human's behalf. When a change is needed, describe it and let the human
type it. (Editing docs like this file when explicitly asked is fine.)

## Board: iCESugar v1.5

- FPGA: **Lattice iCE40UP5K**, package **SG48** (QFN48).
- Clock: 12 MHz on pin 35 (top-entity port `clk`).
- On-board RGB LED: R = 40, G = 41, B = 39. **Active-low** (common anode): drive
  a pin LOW to light that channel.
- Programmed via the on-board **iCELink** debugger, which mounts as a USB
  mass-storage volume at `/Volumes/iCELink`. `iceprog` (FTDI-based) does **not**
  work with this board.

## Toolchain

- **swim** — the Spade build tool / package manager (config in `swim.toml`).
- **OSS CAD Suite** — yosys, nextpnr-ice40, icepack; installed via
  `swim install-tools`. See `setup.sh` for one-time setup.

## Commands

- `swim build` — Spade → Verilog → synth → place & route → `.bin` (output in `build/`).
- `swim upload` — flashes; copies the `.bin` onto `/Volumes/iCELink` (plug board in first).
- `swim test` — run simulation / unit tests.

## Conventions & gotchas

- Top entity is `icesugar_top` in `src/main.spade`, marked `#[no_mangle(all)]`.
  Its port names **must match** the `set_io` names in `icesugar.pcf`.
- Keep `icesugar.pcf` minimal: a `set_io` for a signal not present on the top
  entity makes nextpnr-ice40 error. The full board pinout is in that file,
  commented out. Uncomment a pin only when you add the matching port.
- LED outputs are active-low, so drive `&!signal` where `signal` means "lit".
