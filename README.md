# 5-Stage MIPS Pipeline: SystemVerilog / SVA / Anvil

A hand-written
5-stage MIPS pipeline in SystemVerilog, a formal SVA specification for it, and
a port of the same design to [Anvil](https://anvil.kisp-lab.org/), comparing what Anvil's type system checks for free against
what the SVA suite still has to state and check by hand.

## Quick start

```bash
./run_all.sh
```

This reproduces the project results in one command: the SV
baseline simulation, its formal (SymbiYosys) proof, the Anvil compile, and
the equivalence test suite (8 matched differential programs run against
both DUTs), all against `port2_static_baseline` by default. Pass
`--mutant` to also include the Anvil M-C1 mutation-testing result, or
`--port3` to target the dynamically backpressured port instead. See
[Running `run_all.sh`](#running-run_allsh) below for flags and prerequisites.

## Anvil Compiler Version

**This project was built and tested against Anvil at commit
[`d138cab`](https://github.com/kisp-lab/anvil) (`d138cabedbfc3b65c08249ce6a55cb90dad959da`).**

<!-- Anvil is under active development; language behavior, error messages, and
generated RTL shape are not guaranteed to be stable across commits. If a
result in this repo does not reproduce, check the compiler's commit hash
first:

```bash
cd Anvil_compiler/anvil
git log -1 --format="%H"
git checkout d138cab   # if it has moved on
``` -->

`run_all.sh` calls whatever binary the `ANVIL` environment variable points
at (default: `anvil` on `PATH`).

## Running `run_all.sh`

```
Usage:
  ./run_all.sh [--skip-formal] [--only-anvil] [--port3] [--mutant] [--help]
```

| Flag | Effect |
|---|---|
| *(none)* | Runs stages 1, 2, 3, and 5 (SV baseline simulation, SV formal verification, Anvil compilation, equivalence test suite) against `port2_static_baseline`. Stage 4 (the M-C1 mutant) is opt-in — see `--mutant`. |
| `--skip-formal` | Runs everything except the SymbiYosys/btormc proofs (stage 2), which are the slow part of a full run (BMC sweep over ~30 properties, twice, plus two mutant proofs). |
| `--only-anvil` | Skips both SV stages and runs only the Anvil-side stages (3,5)
| `--mutant` | Runs stage 4, the Anvil M-C1 mutant test. Off by default. 
| `--port3` | Targets port3_dynamic_backpressured.
| `--help`, `-h` | Prints usage and exits. |

Env var `ANVIL` overrides the Anvil compiler binary used (default: `anvil`
on `PATH`).

Each stage checks for its own required tools and prints `[SKIP]` with the
missing tool's name rather than aborting the whole run, so a partial
toolchain still gets you as far as it can. Per-stage output is both printed
live and saved under `run_all_logs/<timestamp>/`.

### What each stage does

By default, stages target `port2_static_baseline` (stage 4 is opt-in, see
`--mutant` above); pass `--port3` to target `port3_dynamic_backpressured`
instead for stages 3 and 5, as noted in each below.

1. **SV Baseline Simulation** — `sv_baseline/`
   Simulates the handwritten SV pipeline via Verilator against both fixed and randomised memory latencies. Asserts `SCOREBOARD: PASS`.
2. **SV Formal Verification** — `sv_baseline/formal/`
   Uses SymbiYosys (BMC depth 14) to mathematically prove the SVA suite against arbitrary instruction sequences and memory stalls. Also proves that the assertions successfully catch mutants M25 and M26.
3. **Anvil Compilation** — `port2_static_baseline/`
   Compiles the static contract port with all lifetime/borrow checks enabled. **With `--port3`:** Compiles `port3_dynamic_backpressured` instead (using `-disable-lt-checks`) and verifies both memory configs pass cleanly.
4. **Anvil M-C1 Mutant** — `mutation_testing/M_C1_fanout/`
   Injects a functional writeback bug. Proves that Anvil's type-checker blindly accepts the faulty data routing, while our SVA-derived checker successfully catches the bug and fails the test. *(Opt-in via `--mutant`. Automatically `[SKIP]`s if targeting `--port3`)*.
5. **Equivalence Test Suite** — `equivalence/`
   Runs 8 diagnostic MIPS programs on both the SV baseline and the Anvil port. Diffs the PC-trace, registers, and data memory to ensure perfect cycle-accurate parity. **With `--port3`:** Ignores the PC-trace and strictly checks architectural equivalence (final registers and memory).
### Prerequisites

| Tool | Used by | Notes |
|---|---|---|
| `verilator` | stages 1, 3, 5 (and 4 if `--mutant`) | tested with 5.051; the sole simulation engine used by this repo |
| `sby` (SymbiYosys), `yosys`, `z3` | stage 2 | `sby` must resolve to a working SymbiYosys install with a BMC-capable engine |
| Anvil compiler (`$ANVIL`) | stages 3, 5 (and 4 if `--mutant`) | commit `d138cab`, see above |
| `python3` | stage 2, 5 | drives the formal-harness generator scripts and the equivalence suite, no extra packages required |

## Verification Toolchain

Verilator is the sole simulation engine used across this project, for
both the hand-written SV baseline and the Anvil-generated ports
(`port2_static_baseline` and `port3_dynamic_backpressured`). It builds
and runs the machine-generated RTL cleanly, with no combinational-loop
failures on either port -- confirmed with real passing runs.
## Repository layout

```text
run_all.sh                       Main automation script
run_all_icarus.sh                Legacy Icarus fallback script
README.md                        Documentation
Anvil_report_final.pdf           Final project report
SVA_Rationale_Supplementary.pdf  Supplementary SVA docs
Submission_Manifest.md           Submission details

sv_baseline/                     Handwritten SV pipeline & SVA suite
port1_serialised/                Anvil prototype: Fully serialised (11 cycles/instr;
                                  refactored for dead code/duplicate branches,
                                  verified cycle-accurate to the original)
port1_serialised_legacy/         Pre-refactor original of port1_serialised, kept
                                  for provenance/diffing
port2_static_baseline/           Anvil port: Static contracts (Cycle-Accurate)
port3_dynamic_backpressured/     Anvil port: Dynamic channels (Architectural)

mutation_testing/                Mutant test harnesses and results
  M_C1_fanout/                   M-C1 writeback fan-out mutant
  MUTATION_RESULTS.md            SV baseline mutation findings
  run_mutants.py                 SV-side mutant harness

equivalence/                     Diff checkers for SV vs Anvil