# Copyright (c) 2023 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: Apache-2.0

import pyuvm
from scoreboards import AccessScoreboard
from sequences import InvalidAddressSequence
from testbench import BaseEnv, BaseTest

# =============================================================================


class TestEnv(BaseEnv):
    def build_phase(self):
        super().build_phase()

        # Add scoreboard
        self.scoreboard = AccessScoreboard("scoreboard", self)

    def connect_phase(self):
        super().connect_phase()

        # Connect monitors
        self.axi_mon.ap.connect(self.scoreboard.fifo.analysis_export)
        self.mem_mon.ap.connect(self.scoreboard.fifo.analysis_export)


# =============================================================================


@pyuvm.test()
class TestAddressOutOfRange(BaseTest):
    """
    Out of range addressing test
    """

    def __init__(self, name, parent):
        super().__init__(name, parent, TestEnv)

    def end_of_elaboration_phase(self):
        super().end_of_elaboration_phase()
        self.seq = InvalidAddressSequence("stimulus", dwidth=self.env.axi_bfm.dwidth)

    async def run(self):
        await self.seq.start(self.env.axi_seqr)
