# Copyright (c) 2023 Antmicro <www.antmicro.com>
# SPDX-License-Identifier: Apache-2.0


from pyuvm import ConfigDB, test
from testbench import (
    BaseEnv,
    BaseTest,
    PMPWriteAddrCSRItem,
    PMPWriteCfgCSRItem,
    getDecodedEntryCfg,
)

from common import BaseSequence


# =============================================================================


class TestSequence(BaseSequence):
    def __init__(self, name):
        super().__init__(name)

    async def body(self):
        test_iterations = ConfigDB().get(None, "", "TEST_ITERATIONS")


# ==============================================================================


@test()
class TestStub(BaseTest):
    """
    """

    def __init__(self, name, parent):
        super().__init__(name, parent, BaseEnv)

    def end_of_elaboration_phase(self):
        super().end_of_elaboration_phase()
        self.seq = TestSequence.create("stimulus")

    async def run(self):
        await self.seq.start()
