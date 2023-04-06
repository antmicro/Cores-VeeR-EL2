import os
import sys
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


def make_clock(dut, clock_mhz):
    clk_period_ns = round(1 / clock_mhz * 1000, 2)
    dut._log.info("input clock = %d MHz, period = %.2f ns" % (clock_mhz, clk_period_ns))
    clock = Clock(dut.clk, clk_period_ns, units="ns")
    clock_sig = cocotb.start_soon(clock.start())
    return clock_sig

class Harness(object):
    def __init__(self, dut, **kwargs):
        self.dut = dut

        # # Set the signal "test_name" to match this test
        # test_name = kwargs.get('test_name', inspect.stack()[1][3])
        # tn = cocotb.binary.BinaryValue(value=test_name.encode(), n_bits=4096)
        # self.dut.test_name.value = tn
    
    @cocotb.coroutine
    async def reset(self):
        self.dut.rst_l.value = 1
        await ClockCycles(self.dut.clk, 2)
        self.dut.rst_l.value = 0
        await ClockCycles(self.dut.clk, 2)
        self.dut.rst_l.value = 1
        await ClockCycles(self.dut.clk, 2)