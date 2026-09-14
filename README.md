# 5-Stage MIPS Pipeline: SystemVerilog / SVA / Anvil

Research internship project (Prof. Umang Mathur, FOCS Lab, NUS): a hand-written
5-stage MIPS pipeline in SystemVerilog, a formal SVA specification for it, and
a port of the same design to [Anvil](https://anvil.kisp-lab.org/), a
timing-safe HDL — comparing what Anvil's type system checks for free against
what the SVA suite still has to state and check by hand.

## Quick start

```bash
./run_all.sh
```

This reproduces the project's headline results in one command: the SV
baseline simulation, its formal (SymbiYosys) proof, the Anvil compile, the
Anvil M-C1 mutation-testing result, and the equivalence test suite (8
matched differential programs run against both DUTs). See
[Running `run_all.sh`](#running-run_allsh) below for flags and prerequisites.

## Anvil Compiler Version

**This project was built and tested against Anvil at commit
[`d138cab`](https://github.com/kisp-lab/anvil) (`d138cabedbfc3b65c08249ce6a55cb90dad959da`).**

Anvil is under active development; language behavior, error messages, and
generated RTL shape are not guaranteed to be stable across commits. If a
result in this repo does not reproduce, check the compiler's commit hash
first:

```bash
cd Anvil_compiler/anvil
git log -1 --format="%H"
git checkout d138cab   # if it has moved on
```

`run_all.sh` calls whatever binary the `ANVIL` environment variable points
at (default: `anvil` on `PATH`) — see below for how to build and point it at
that commit.

## Running `run_all.sh`

```
Usage:
  ./run_all.sh [--skip-formal] [--only-anvil] [--help]
```

| Flag | Effect |
|---|---|
| *(none)* | Runs all five stages in order: SV baseline simulation, SV formal verification, Anvil compilation, Anvil M-C1 mutant, equivalence test suite. |
| `--skip-formal` | Runs everything except the SymbiYosys/btormc proofs (stage 2), which are the slow part of a full run (BMC sweep over ~30 properties, twice, plus two mutant proofs). |
| `--only-anvil` | Skips both SV stages and runs only the Anvil-side stages (3, 4, 5) — compilation, the M-C1 mutant test, and the equivalence suite — useful for iterating on the Anvil port without re-running the SV side. |
| `--help`, `-h` | Prints usage and exits. |

Env var `ANVIL` overrides the Anvil compiler binary used (default: `anvil`
on `PATH`).

Each stage checks for its own required tools and prints `[SKIP]` with the
missing tool's name rather than aborting the whole run, so a partial
toolchain still gets you as far as it can. Per-stage output is both printed
live and saved under `run_all_logs/<timestamp>/`.

### What each stage does

1. **SV Baseline Simulation** — `sv_baseline/`, via Verilator.
   Compiles and runs the SV pipeline with the backpressured data-memory
   interface under a fixed-latency and a randomised-latency memory, and
   checks for `SCOREBOARD: PASS` in both.
2. **SV Formal Verification** — `sv_baseline/formal/`, via
   SymbiYosys (`sby`) + btormc. Runs the symbolic-program, free-`ready` BMC
   sweep (depth 14) over the Gold-Standard property suite, then re-runs the
   two headline mutants (M25, M26) through the same formal harness and
   checks that both are caught.
3. **Anvil Compilation** — `port2_static_baseline/`, the static `@#1 - @#1`
   contract port. Compiles with every lifetime/borrow check on (no
   `-disable-lt-checks`) and runs the Icarus testbench, checking the
   architectural end state against the SV baseline.
4. **Anvil M-C1 mutant** — `mutation_testing/M_C1_fanout/`. Applies the
   one-line writeback fan-out mutation (`writeback.anv` line 24: `wb_ex`'s
   payload changed from the muxed `wd` to the raw `*mw_alu`) to a scratch
   copy of `port2_static_baseline/`, confirms Anvil still accepts it
   (`success: true`) with every check on, then runs the SVA-derived checker
   against both the unmodified baseline and the mutant and confirms the
   baseline is clean while the mutant fires assertion C1 and flips the
   end-to-end scoreboard from PASS to FAIL.
5. **Equivalence Test Suite** — `equivalence/`. Assembles 8 named matched
   programs (original program, distinguishable branch target, far jump,
   four-deep RAW chain, write to `$zero`, load into `$zero`,
   store-then-load, double load-use), compiles and simulates each one
   against *both* the SV baseline (`sv_baseline/`) and the Anvil
   port (`port2_static_baseline/`), and diffs the PC-change trace, the full
   32-entry register file, and the first 16 data-memory words between the
   two runs. Normalizes a genuine, structural one-cycle boot offset (Anvil's
   `Fetch` spends its first post-reset cycle loading `imem`/`init_done`
   before the SV baseline's reset block, which preloads `pc` and `imem`
   together, has done so) before comparing. All 8 programs currently match.

### Prerequisites

| Tool | Used by | Notes |
|---|---|---|
| `verilator` | stage 1 | tested with 5.036 |
| `sby` (SymbiYosys), `yosys`, `z3` | stage 2 | `sby` must resolve to a working SymbiYosys install with a BMC-capable engine |
| Anvil compiler (`$ANVIL`) | stages 3–4 | commit `d138cab`, see above |
| `iverilog` | stages 3–4 | tested with Icarus Verilog 12.0 |
| `python3` | stage 2 | drives the formal-harness generator scripts, no extra packages required |

## Repository layout

```
run_all.sh                     one-command reproduction (this file's companion)
README.md                      this file

sv_baseline/          SV baseline + backpressured data-memory interface
  mips_pipeline_processor.sv     the pipeline
  mips_sva.sv                    Gold-Standard SVA suite (30 properties, pruned from 60)
  formal/                        SymbiYosys/btormc formal harness + mutant proofs

port1_serialised/                first Anvil prototype: fully dynamic channels, fully
                                  serialised (11 cycles/instruction), superseded below
port2_static_baseline/           static @#1 - @#1 contracts, true 1 IPC -- every
                                  downstream result in the report uses this port
port3_dynamic_backpressured/     dynamic channels, models variable memory latency
                                  directly (needs -disable-lt-checks -- see README)
Anvil_compiler/anvil/            the Anvil compiler itself (see commit hash above)

mutation_testing/              mutant catalogue and results
  M_C1_fanout/                   the M-C1 writeback fan-out mutant used by run_all.sh
  MUTATION_RESULTS.md
  run_mutants.py                 the SV-side mutant harness (M1, M2, ..., not M-C1)

equivalence/                    Part C equivalence test suite (Rubric §3.3/§6)
  assemble.py                    MIPS assembler + the 8 named matched programs
  run_equivalence.py             drives SV + Anvil sims for each program, diffs
                                  PC trace / regfile / data memory, used by
                                  run_all.sh's stage 5
  *.template, tb_equiv_*.sv       per-program instruction-memory templates and
                                  the generic dump testbenches for each side

formal/                        formal proof of the Anvil-generated RTL itself
                                (channel-pairing / $zero properties, separate from
                                run_all.sh's stage 2, which proves the SV side)

Lab assignment original/       the pre-existing SV coursework this project started from
docs/, report_testbenches/     supporting material
```

For the full write-up — porting notes, the friction log, the timing-safety
analysis, and the mutation-testing results in detail — see
`Anvil_MIPS_Master_Report.md`, `Executive_Summary.md`,
`SVA_AUDIT_REPORT.md`, and `Anvil-MIPS-Port-Review.md` at the repo root.
`Observation_3_compiler_trace.md` (also at the repo root) is a condensed,
report-ready extract of the static-timing-contract → generated-FSM trace
(`EVENTS0`), for Rubric §4's compiler-construct-trace observation.
