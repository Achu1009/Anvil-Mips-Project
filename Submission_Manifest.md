# Submission Manifest

5-Stage MIPS Pipeline: SystemVerilog / SVA / Anvil — Research internship
project (Prof. Umang Mathur, FOCS Lab, NUS). This package contains everything
needed to read the report and reproduce its results.

## Where to start

**`Anvil_report_final.pdf`** is the final report. Read this first.

**`run_all.sh`** reproduces every headline result in the report with one
command (`./run_all.sh`) — the SV baseline simulation, its formal proof, the
Anvil compile, the Anvil M-C1 mutation-testing result, and the 8-program
equivalence suite. See `README.md` for flags, prerequisites, and the exact
Anvil compiler commit this project was built against.

## Contents

| File / folder | What it is |
|---|---|
| `Anvil_report_final.pdf` | The final report: what was built, the SVA rationale, what the Anvil port revealed, and what we'd change about Anvil. |
| `README.md` | Project overview, one-command reproduction instructions, the Anvil compiler version this project depends on, and a guide to the repository layout. |
| `run_all.sh` | The one-command script that reproduces all of the report's headline results in sequence; see README.md for usage flags. |
| `SVA_Rationale_Supplementary.tex` | Supplementary write-up giving the rationale behind each property in the SVA suite — why it exists and what breaks without it. (LaTeX source; not yet compiled to PDF.) |
| `sv_baseline/` | The hand-written SystemVerilog baseline: the 5-stage pipeline with a backpressured (variable-latency) data-memory interface, the 30-property Gold-Standard SVA suite, and the SymbiYosys/btormc formal verification harness. |
| `port1_serialised/` | The first Anvil port: fully dynamic channels throughout. Fully serialised (11 cycles/instruction, no forwarding needed) and superseded by the two ports below — kept to document the porting journey. |
| `port2_static_baseline/` | The static-contract Anvil port (`@#1 - @#1` on every channel). This is the port every downstream result in the report assumes: compiles with every lifetime/borrow check on, and reaches 1 instruction per cycle — parity with the SV baseline. |
| `port3_dynamic_backpressured/` | The dynamic, backpressured Anvil port: a real 5-stage pipeline that models variable memory latency directly, reaching 1 IPC when memory is idle. Requires `-disable-lt-checks`, so it does not carry Anvil's own timing-safety guarantee — this tradeoff is discussed in the report. |
| `equivalence/` | The Part C equivalence test suite: 8 matched differential programs, each assembled and simulated against both the SV baseline and the Anvil port, diffing the PC trace, register file, and data memory. |
| `mutation_testing/` | The mutant catalogue, including the M-C1 writeback fan-out mutant — a design Anvil's type system accepts under full lifetime checking but which the SVA suite catches — and its verification log. |
