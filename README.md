# etca-spade

A minimal [Spade HDL](https://spade-lang.org) stub for the **iCESugar v1.5**
(Lattice iCE40UP5K-SG48). It cycles the on-board RGB LED red → green → blue at
about 1 Hz — enough to confirm the full toolchain and board work end to end.

## Prerequisites

- [Rust](https://rustup.rs) (for `cargo`).
- An iCESugar v1.5 with its on-board iCELink debugger (the default USB mode).

## Setup

Installs `swim` (the Spade build tool) and the OSS CAD Suite
(yosys, nextpnr-ice40, icepack, …; ~2.5 GB):

```sh
./setup.sh
```

Or run the two steps manually:

```sh
cargo install --git https://gitlab.com/spade-lang/swim
swim install-tools
```

## Build & flash

```sh
swim build      # Spade -> Verilog -> synth -> place & route -> .bin
swim upload     # copies the .bin onto the mounted iCELink volume
```

`swim upload` uses the `[upload]` block in `swim.toml`, which copies the packed
bitstream to `/Volumes/iCELink`. Plug the board in first — it mounts as a USB
drive named **iCELink**. You can also drag `build/*.bin` onto that drive by hand.

> Prefer the native programmer? Put `icesprog` (from the
> [icesugar repo](https://github.com/wuxx/icesugar)) on your `PATH` and switch
> `swim.toml`'s `[upload]` block to `tool = "icesprog"`. It is not part of the
> OSS CAD Suite.

## Layout

| File | Purpose |
| --- | --- |
| `swim.toml` | Project + toolchain config (device `iCE40UP5K`, package `sg48`). |
| `src/main.spade` | The design: `icesugar_top` (pins) wraps `main` (logic). |
| `icesugar.pcf` | Pin constraints. Active pins on top; full board pinout below, commented. |
| `setup.sh` | Installs swim + the OSS CAD Suite. |

## Pin notes

- 12 MHz clock on pin 35.
- RGB LED: R = 40, G = 41, B = 39. **Active-low** (common anode): drive a pin
  LOW to light that channel.
- Top-entity port names must match the `set_io` names in `icesugar.pcf`;
  `#[no_mangle(all)]` on `icesugar_top` keeps them verbatim in the Verilog.

To use more pins (PMODs, UART, SPI, switches), uncomment the relevant lines in
`icesugar.pcf` and add matching ports to `icesugar_top`.
