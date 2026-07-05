# top = execute::math_harness

import cocotb
from spade import SpadeExt
from cocotb.triggers import Timer


async def check(dut, opcode, a, b, expected):
    s = SpadeExt(dut)
    s.i.opcode = opcode
    s.i.a = a
    s.i.b = b
    await Timer(1, units="ns")          # let combinational logic settle
    assert s.o == expected, f"{opcode} {a},{b} -> {s.o.value()}"


@cocotb.test()
async def add_overflow(dut):
    # 0x7FFF + 1 = 0x8000: pos+pos=neg -> V, N set; no carry; not zero
    await check(dut, "0b000", "0x7FFF", "0x0001",
        "(0x8000, Flags$(zero: false, negative: true, carry: false, overflow: true))")


@cocotb.test()
async def sub_overflow(dut):
    # 0x7FFF - 0xFFFF = 0x8000: the case your global-b_sign version got wrong
    await check(dut, "0b001", "0x7FFF", "0xFFFF",
        "(0x8000, Flags$(zero: false, negative: true, carry: true, overflow: true))")


@cocotb.test()
async def rsub_overflow(dut):
    # RSUB: B - A = 0 - 0x8000 = 0x8000  (a=0x8000, b=0) -> V set
    await check(dut, "0b010", "0x8000", "0x0000",
        "(0x8000, Flags$(zero: false, negative: true, carry: false, overflow: true))")
