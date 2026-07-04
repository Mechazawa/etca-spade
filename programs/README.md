# programs

ETCa assembly for the Spade CPU. Assembled with the Python assembler
[etc-as](https://github.com/MegaIng/etca-asm) (installed in a venv at
`~/Projects/etca-asm/.venv`).

## Assembling

```sh
~/Projects/etca-asm/.venv/bin/etc-as count.s -o count.bin   # flags TBD, see --help
```

The CPU fetches 16-bit words, MSB first (the format-marker byte). Execution
starts at `0x8000`, which the CPU maps to program-memory word 0
(`pc & 0x7FFF`), so the first instruction goes at index 0 of the init array.

## Constraints (current CPU)

Only instructions the decoder handles: `ComputeReg`, `ComputeImm`,
`CondRelJump`, with size field `01`. No `functions` extension (push/pop/call),
and load/store aren't wired from a loaded program yet.

## Loading into the CPU

See the memory-init notes in the chat / project docs: assembled words become a
compile-time `[uint<16>; N]` array fed to an init-capable block RAM.
