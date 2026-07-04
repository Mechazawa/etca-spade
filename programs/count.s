; Minimal base-ISA program for the Spade CPU.
; Counts r0 down from 5 to 0, then spins forever.
;
; Uses only what the CPU currently decodes/executes:
;   - ComputeImm  (mov = movz opcode 8, sub opcode 1)
;   - CondRelJump (jne, jmp)
; No stack / call / load / store yet (those need extensions or the
; data-memory path the CPU doesn't drive from asm yet).
;
; ETCa execution starts at 0x8000, which is the CPU's initial pc.

_start:
    mov r0, 5

.loop:
    sub r0, 1        ; sets Z when r0 reaches 0
    jne .loop        ; keep looping while r0 != 0

.done:
    jmp .done        ; halt: spin in place
