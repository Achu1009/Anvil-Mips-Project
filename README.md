# 5-Stage MIPS Pipeline: SystemVerilog / SVA / Anvil

A hand-written
5-stage MIPS pipeline in SystemVerilog, a formal SVA specification for it, and
a port of the same design to [Anvil](https://anvil.kisp-lab.org/), comparing what Anvil's type system checks for free against
what the SVA suite still has to state and check by hand.

## Quick start

```bash
./run_all.sh
```

This reproduces the project's headline results in one command: the SV
baseline simulation, its formal (SymbiYosys) proof, the Anvil compile, and
the equivalence test suite (8 matched differential programs run against
both DUTs) — all against `port2_static_baseline` by default. Pass
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
| `--only-anvil` | Skips both SV stages and runs only the Anvil-side stages — compilation (3) and the equivalence suite (5) by default, plus the M-C1 mutant test (4) if `--mutant` is also passed — useful for iterating on the Anvil port without re-running the SV side. |
| `--mutant` | Also runs stage 4, the Anvil M-C1 mutant test. Off by default. Combined with `--port3`, prints an explanatory `[SKIP]` instead of running anything (see `--port3` below). |
| `--port3` | Targets `port3_dynamic_backpressured` (dynamic, backpressured channels) instead of `port2_static_baseline` for stages 3 and 5. Stage 4, if requested via `--mutant`, is `[SKIP]`ped: no SVA/procedural checker exists for port3, and M-C1/M25/M26 are documented as unrepresentable under its dynamic-channel semantics. Stage 5 checks **architectural equivalence** (final registers + data memory) rather than cycle-accurate parity, since port3's backpressure handshakes take real, expected extra cycles the SV baseline doesn't. |
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

1. **SV Baseline Simulation** — `sv_baseline/`, via Verilator.
   Compiles and runs the SV pipeline with the backpressured data-memory
   interface under a fixed-latency and a randomised-latency memory, and
   checks for `SCOREBOARD: PASS` in both.
2. **SV Formal Verification** — `sv_baseline/formal/`, via SymbiYosys (sby) + btormc. Runs a Bounded Model Checking (BMC) sweep (depth 14) to formally prove the SVA suite against any arbitrary instruction sequence and any random memory stall duration. It then re-runs the two mutants (M25, M26) through the same formal harness and checks that the assertions successfully catch both of them.
3. **Anvil Compilation** — `port2_static_baseline/`, the static `@#1 - @#1`
   contract port. Compiles with every lifetime/borrow check on (no
   `-disable-lt-checks`) and runs the Verilator-built binary, checking
   the architectural end state against the SV baseline. **With `--port3`**,
   compiles `port3_dynamic_backpressured/` instead, with `-disable-lt-checks`,
   for both memory-latency configs, and checks for `RESULT: PASS` in each.
4. **Anvil M-C1 mutant** — `mutation_testing/M_C1_fanout/`. Applies the
   one-line writeback fan-out mutation (`writeback.anv` line 24: `wb_ex`'s
   payload changed from the muxed `wd` to the raw `*mw_alu`) to a scratch
   copy of `port2_static_baseline/`, confirms Anvil still accepts it
   (`success: true`) with every check on, then runs the SVA-derived checker
   against both the unmodified baseline and the mutant and confirms the
   baseline is clean while the mutant fires assertion C1 and flips the
   end-to-end scoreboard from PASS to FAIL. **Off by default** — pass
   `--mutant` to run it. **With `--port3`**, it `[SKIP]`s instead.
5. **Equivalence Test Suite** — `equivalence/`. Assembles 8 matched
   programs (original program, distinguishable branch target, far jump,
   four-deep RAW chain, write to `$zero`, load into `$zero`,
   store-then-load, double load-use), compiles and simulates each one
   against both the SV baseline (`sv_baseline/`) and the Anvil
   port (`port2_static_baseline/`), and diffs the PC-change trace, the full
   32-entry register file, and the first 16 data-memory words between the
   two runs.
 For port 3, the script ignores the cycle-by-cycle PC trace and strictly compares the final register file and data memory states.
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

```
run_all.sh                     one-command reproduction (this file's companion)
run_all_icarus.sh              archived: the prior Icarus-based version of run_all.sh,
                                  kept as a fallback -- see 'Verification Toolchain'
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
                                  directly (needs -disable-lt-checks -- see README);
                                  also reachable via run_all.sh --port3 (stages 3, 5)
Anvil_compiler/anvil/            the Anvil compiler itself (see commit hash above)

mutation_testing/              mutant catalogue and results
  M_C1_fanout/                   the M-C1 writeback fan-out mutant used by run_all.sh
  MUTATION_RESULTS.md
  run_mutants.py                 the SV-side mutant harness (M1, M2, ..., not M-C1)

equivalence/                    Part C equivalence test suite (Rubric §3.3/§6)
  assemble.py                    MIPS assembler + the 8 named matched programs
  run_equivalence.py             drives SV + Anvil sims for each program (Verilator),
                                  diffs PC trace / regfile / data memory, used by
                                  run_all.sh's stage 5 (port2, default)
  run_equivalence_port3.py       same, targeting port3_dynamic_backpressured; checks
                                  architectural equivalence only (final regs + dmem,
                                  not cycle-accurate PC trace) -- used by run_all.sh's
                                  stage 5 under --port3
  run_equivalence_icarus.py      archived: the prior Icarus-based run_equivalence.py
  run_equivalence_port3_trial.py archived: an earlier port3 diagnostic script,
                                  superseded by run_equivalence_port3.py above
  *.template, tb_equiv_*.sv       per-program instruction-memory templates and
                                  the generic dump testbenches for each side

formal/                        formal proof of the Anvil-generated RTL itself
                                (channel-pairing / $zero properties, separate from
                                run_all.sh's stage 2, which proves the SV side)

Lab assignment original/       the pre-existing SV coursework this project started from
docs/, report_testbenches/     supporting material
```
