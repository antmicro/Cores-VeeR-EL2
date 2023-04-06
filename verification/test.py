#!/usr/bin/env python3

import os
import sys
import pytest
from cocotb_test.simulator import run

try:
    rv_root = os.environ["RV_ROOT"]
except KeyError:
    print("RV_ROOT not set", file=sys.stderr)
    sys.exit(1)

includes = ["snapshots/default"]
common_sources = [
    "snapshots/default/common_defines.vh",
    "snapshots/default/el2_pdef.vh",
    "design/include/el2_def.sv",
    "design/lib/beh_lib.sv"
]

def test_exu_alu():
    extra_env = {}

    verilog_sources = common_sources + [
        "design/exu/el2_exu_alu_ctl.sv"
    ]

    run(
        simulator = "verilator",
        verilog_sources = ["{}/{}".format(rv_root, el) for el in verilog_sources],
        includes = ["{}/{}".format(rv_root, el) for el in includes],
        toplevel = "el2_exu_alu_ctl",
        module = "tests.test-exu-alu",
        extra_env = extra_env,
        waves = True,
    )
