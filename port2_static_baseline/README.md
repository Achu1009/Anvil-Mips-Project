# port2_static_baseline -- true 1-IPC MIPS pipeline in Anvil

Build:      anvilc top.anv > mips_anvil_pipelined.sv
Simulate:   iverilog -g2012 -o sim.vvp mips_anvil_pipelined.sv tb_mips_pipelined.sv && ./sim.vvp

## Result

| | SV baseline | port1_serialised (original) | port1_serialised review_patch | this directory |
|---|---|---|---|---|
| cycles / instruction | 1 | 11 | 4 | **1** |
| stages overlapped | 5 | 1 | 1 | **5** |
| handshake wires in RTL | n/a | 464 | 464 | **0** |
| generated RTL lines | n/a | 2625 | 2625 | **967** |
| forwarding unit | yes | none | none | **yes** |
| load-use stall | yes | none | none | **yes** |
| $zero violations | 0 | 1 | 0 | **0** |

Verified: 8/8 differential programs match mips_pipeline_processor.sv exactly,
and the PC trace is identical cycle-for-cycle (offset by one boot cycle),
including both load-use stall cycles and the branch redirect.

## What is where

- types.anv      9 one-way channel classes, all `@#1 - @#1`
- fetch.anv      PC, imem, next-PC priority mux
- decode.anv     IF/ID register, register file, LOAD-USE HAZARD DETECTOR
- execute.anv    ID/EX register, ALU, FORWARDING UNIT, branch resolve
- memory.anv     EX/MEM register, dmem
- writeback.anv  MEM/WB register, write-back mux, fan-out to ID and EX
- top.anv        wiring
