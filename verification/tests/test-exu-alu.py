from os import environ

import os
import sys
import random
import cocotb
import logging
import inspect
from itertools import repeat
from cocotb.triggers import Timer
from cocotb.result import raise_error
from cocotb.result import TestError
from cocotb.result import ReturnValue
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.triggers import RisingEdge
from cocotb.triggers import FallingEdge
from cocotb.triggers import ClockCycles
from cocotb.binary import BinaryValue
from .common import make_clock, Harness


@cocotb.test()
async def test_add(dut):
    inputs = random.sample(range(0x1, 0x3fffffff), 2)

    harness = Harness(dut)
    clk_gen = make_clock(harness.dut, 100)

    await harness.reset()

    harness.dut.enable.value = 1
    harness.dut.ap.value = 1<<8          # predecoded operation
    harness.dut.a_in.value = inputs[0]
    harness.dut.b_in.value = inputs[1]
    harness.dut.valid_in.value = 1

    await ClockCycles(harness.dut.clk, 1)

    assert harness.dut.result.value.integer == (inputs[0] + inputs[1])

    clk_gen.kill()

@cocotb.test()
async def test_sub(dut):
    inputs = random.sample(range(0x1, 0x3fffffff), 2)

    harness = Harness(dut)
    clk_gen = make_clock(harness.dut, 100)

    await harness.reset()

    harness.dut.enable.value = 1
    harness.dut.ap.value = 1<<7          # predecoded operation
    harness.dut.a_in.value = max(inputs[0], inputs[1])
    harness.dut.b_in.value = min(inputs[0], inputs[1])
    harness.dut.valid_in.value = 1

    await ClockCycles(harness.dut.clk, 1)

    assert harness.dut.result.value.integer == (max(inputs[0], inputs[1]) - min(inputs[0], inputs[1]))

    clk_gen.kill()
