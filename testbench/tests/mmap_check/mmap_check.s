// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Western Digital Corporation or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// Assembly code for Hello World
// Not using only ALU ops for creating the string


#include "defines.h"

#define STDOUT 0xd0580000


// Code to execute
.section .text
.global _start
_start:

    // Clear minstret
    csrw minstret, zero
    csrw minstreth, zero

    // Set trap handler
    la x1, _trap
    csrw mtvec, x1

    // Enable Caches in MRAC
    li x1, 0x5f555555
    csrw 0x7c0, x1

    // Load string from hw_data
    // and write to stdout address

    li x3, 0x00000001
    li x4, 32

loop:
    li x5, STDOUT
    or x5, x5, x3
    lb x5, 0(x5)
    slli x3, x3, 1
    addi x4, x4, -1
    bnez x4, loop
    li a0, 0x01 # failure

// Write return value (a0) from printf to STDOUT for TB to termiate test.
_finish:
    li x3, STDOUT
    sb a0, 0(x3)
    beq x0, x0, _finish
.rept 100
    nop
.endr

.align 4
_trap:
    li a0, 0xff # success
    j _finish

.data
