# Phase 1b — backpressured data-memory interface + data-plane SVA

Self-contained. Everything here builds and runs with the commands below.

## What changed

| File | Status |
|---|---|
| `data_memory.sv` | **new** — byte array behind a `req`/`ready` handshake, parameterised latency, optional pseudo-random backpressure |
| `instruction_fetch.sv` | fetch index narrowed from `pc[31:2]` to `pc[IAW+1:2]`; `IMEM_WORDS` parameterised |
| `mips_pipeline_processor.sv` | 9 edits (105 lines): memory instance, `mem_stall`, freeze semantics, `wb_done`, qualified branch redirect |
| `mips_sva.sv` | **30 properties (Gold-Standard suite)** — pruned from 60; see `AUDIT_PRUNING.md` |
| `mips_sva_full60.sv` | the 60-property working suite, retained as the audit record |
| `tb_mips_pipeline_processor.sv` | third bind (`data_memory`), extended regfile bind, parameterised run length |
| `mips_sva_vlt.sv` | generated: the one `##2` cover removed (Verilator has no `##N` through 5.036) |
| `tb_mon.sv`, `tb_nosva.sv` | generated: stall-counting monitor, and an assertions-removed build for measuring what the scoreboard alone catches |
| `formal/` | `mk_bp_formal.py` (Yosys image generator), `run_sweep.py`, `mut_formal.py` |

## The design decision that matters

A **load-use** stall bubbles: the front freezes, the back drains, because the
blockage is upstream. A **memory** stall *freezes*: nothing drains, because the
blockage is at the back and there is nowhere to drain to.

Bubbling MEM/WB on a memory stall — the obvious first implementation — is a
silent data-corruption bug. MEM/WB is not just a pipeline register, it is a
**forwarding source**. Zero it and `forward_a` falls back to `2'b00` for an
instruction already in EX, which then reads a stale `id_ex.rd1`:

```
A: add r1, r0, r0     <- in WB (mem_wb)
C: lw  r5, 0(r0)      <- in MEM, stalled
B: add r2, r1, r0     <- in EX, needs r1 from A via forward_a = 2'b01
```

Neither P30 nor P38 catches it — both read `mem_wb` too, so the property and
the design go wrong together. That is mutant **M25** below, and **P43** is the
only thing in the suite that sees it.

The consequence of freezing instead is that WB would repeat its register-file
write once per stall cycle. `wb_done` suppresses that; the forwarding unit
keeps using `mem_wb.reg_write` (the value is still architecturally current),
only `rf_write_en` is gated. **P34b** is the exactly-once property.

## Results

### Simulation — Verilator 5.036

| Config | Cycles | mem_stall cycles | Longest stall | Scoreboard | Assertions |
|---|---|---|---|---|---|
| `LATENCY=1, RANDOMISE=0` | 21 | 0 | 0 | **PASS** | 30 silent |
| `LATENCY=3, RANDOMISE=0` | 37 | 4 | 2 | **PASS** | 30 silent |
| `LATENCY=3, RANDOMISE=1` | 77 | 8 | 4 | **PASS** | 30 silent |

Row 1 reproduces the pre-backpressure baseline bit-for-bit
(R1=20, R2=0, R3=0, R4=20, DMEM[20..23]=0,0,0,20) — the refactor is
behaviour-preserving at `LATENCY=1`. Rows 2 and 3 are backpressure *exercised*,
not declared.

### Formal — SymbiYosys + btormc, symbolic program, free `ready`

`imem` unconstrained (any program) and `ready` a free per-cycle input with a
structural fairness bound (any backpressure schedule the contract permits).

**BMC(14): 53 of 57 properties PASS.** The four failures are exactly the
properties the suite already labels `[CHECKER]`, at exactly the same depths as
before backpressure was added:

| Property | First counterexample |
|---|---|
| `a_p19b_branch_tgt_bnds` | k = 4 |
| `a_p17_mem_bounds` | k = 5 |
| `a_p19_pc_bounds` | k = 5 |
| `a_p27_mem_alignment` | k = 5 |

Everything new — P34a/b, P35, P35b, P36, P38a/b, P39a/b/c, P40a/b, P41, P42,
P43, P44, P44m — holds over all programs and all backpressure schedules to
depth 14.

### Mutants

| Mutant | Change | Simulation | Scoreboard **alone** | Formal |
|---|---|---|---|---|
| **M25** | bubble MEM/WB instead of freezing it | **P43** at 65 ns | **PASSES** | **P43** at k=6 |
| **M26** | `mem_stall = ~dmem_ready` (missing `dmem_req`) | **P44** at 115 ns | fails (deadlock) | **P44** at k=11 |

M25 is the headline. With the assertion suite removed, the end-to-end
scoreboard reports **PASS** on a design that drops a MEM/WB→EX bypass. It is
caught only by an interface property, and only because that property is stated
over the architectural registers rather than over the enable terms.

M26 needs BMC depth > P44's bound (8) plus the reset cycles — it survives at
depth 10 and is caught at depth 16. P44 is a liveness property; the bound and
the depth have to be chosen together.

## Reproducing

```bash
# --- simulation -------------------------------------------------------
FILES="mips_pkg.sv instruction_fetch.sv instruction_decode.sv register_file.sv \
       forwarding_unit.sv data_memory.sv mips_pipeline_processor.sv \
       mips_sva_vlt.sv tb_mips_pipeline_processor.sv"

verilator --binary --timing --assert -o sim -GDMEM_LATENCY=1 -GDMEM_RANDOMISE=0 $FILES && ./obj_dir/sim
verilator --binary --timing --assert -o sim -GDMEM_LATENCY=3 -GDMEM_RANDOMISE=1 $FILES && ./obj_dir/sim

# --- formal -----------------------------------------------------------
cd formal
python3 mk_bp_formal.py .. f_sym.sv --free-imem --free-ready
python3 run_sweep.py 14 f_sym.sv        # enumerates every failing property
python3 mut_formal.py                   # M25 and M26

# --- Vivado / XSim (P20c is the only 4-state property left) -----------
xvlog -sv mips_pkg.sv instruction_fetch.sv instruction_decode.sv \
          register_file.sv forwarding_unit.sv data_memory.sv \
          mips_pipeline_processor.sv mips_sva.sv tb_mips_pipeline_processor.sv
xelab -debug typical tb_mips_pipeline_processor -s tb_run && xsim tb_run -runall
```

Use `mips_sva.sv` (not `mips_sva_vlt.sv`) under XSim — it keeps the `##2` cover.

## Pruning to the Gold-Standard suite

`mips_sva.sv` now holds **30 properties**, pruned from the 60 the audit
produced. Full reasoning, the per-property study list and the reserve set are
in `AUDIT_PRUNING.md`. Re-verified after pruning:

| Check | Result |
|---|---|
| Verilator, all three configs | PASS, cycle-for-cycle identical to the 60-property runs |
| 24 legacy mutants (simulation) | **12 caught** — the same count the 60-property suite reached |
| M25 / M26 | **P43** / **P44** still fire |
| the 9 merged formulations, BMC(14) symbolic + free `ready` | **PASS** (`formal/mk_gold_check.py`) |

The final cut (P21, P24, P29, P3b) costs exactly one detection: mutant **M02**
escapes simulation without P24, because P38 subsumes it *logically* but not
*statistically* — P38 fires only when the wrong select also carries a
different value. That trade was measured, not assumed; P24 is six lines in
`mips_sva_full60.sv` if you want it back.

## Fetch index (`instruction_fetch.sv`)

`imem[pc[31:2]]` was a 30-bit index into a 256-entry array — an out-of-range
access for any PC >= 1 KiB, X in simulation and undefined in synthesis. It is
now `imem[pc[IAW+1:2]]` with `IAW = $clog2(IMEM_WORDS)`, the same narrowing
`data_memory` applies on the data side. Verilator's `WIDTHTRUNC` warning is
gone and the design lints clean.

**This makes fetch total, not correct.** Neither cause of a runaway PC has
changed: nothing halts the increment, and `ex_branch_target` still spans 23
bits. What changed is the consequence — an out-of-range fetch no longer
returns X, it silently *aliases* back into the program and executes whatever
word it lands on. An X would at least have propagated somewhere visible.

So P19 is now the only thing in the suite that can detect a PC leaving the
program, which is a stronger reason to keep it than the one it replaced. Its
rationale in `mips_sva.sv` has been rewritten to say so, and P17's stale note
about the old 12-bit dmem index has been updated the same way.

Confirmed no regression: all three simulation configs are bit-identical to
before the change (same cycle counts, same stall counts), and the formal sweep
returns the same result — PASS at depth 14 with the same four `[CHECKER]`
properties masked, failing at the same depths (k=4, 5, 5, 5). Both mutants are
still caught at the same depths (P43 k=6, P44 k=11).

## Tool notes

- **Verilator ≤ 5.036 does not implement `##N` in a sequence.** The rewritten
  P8b avoids it by counting pipeline *advances* in a register instead, which
  was needed for backpressure correctness anyway. Only one cover still uses
  `##`, and `mips_sva_vlt.sv` drops it.
- **Open-source Yosys has no concurrent SVA** (that needs Verific), no `bind`,
  and no `import pkg::*`. `formal/mk_bp_formal.py` is the translation layer;
  every transform it makes is listed in its header.
- **Yosys mis-elaborates `$past` of a part-select of a packed-struct member.**
  Reduced to a 10-line testcase; it disagrees with a shadow register of the
  same expression. The formal image uses shadow registers where that pattern
  would appear. `mips_sva.sv` keeps the `$past` form, which is correct
  SystemVerilog and behaves correctly under Verilator and XSim.
- **`mk_bp_formal.py` hard-asserts that `--free-imem` actually applied.** Its
  regex keyed on the literal `i < 256`, which the `IMEM_WORDS`
  parameterisation renamed. A transform that silently fails to apply looks
  exactly like one that worked: `imem` would stay initialised and the
  "symbolic program" run would quietly become the concrete-program run. The
  generator now refuses to emit anything rather than allow that.
- **P20c is the only 4-state property left** and is a no-op under Verilator and
  the formal image. It does real work only under XSim/Questa/VCS. P21 (the X
  tripwire) was removed once `data_memory`'s in-flight poison changed from `X`
  to `32'hDEAD_BEEF`; see `AUDIT_PRUNING.md` for what that did and did not
  cost.

## Still open

- The pure-ALU mutants (`SUB`→`ADD`, `alu_src` ignored) survive by design.
  Asserting the ALU's arithmetic function would mean writing a second
  subtractor in the assertion; that obligation belongs to the end-to-end
  invariant in `tb_equivalence.sv` (the brief's Category E).
- A trap or halt on a runaway PC. The fetch index is now narrowed (see below),
  so the access is in range, but nothing stops the PC leaving the program — it
  aliases instead. This ISA subset has no exception mechanism to hang a trap
  on, which is the honest reason it is not implemented.
- k-induction / PDR on the backpressured model has not been run. The
  pre-backpressure set was proven unbounded by `abc pdr`; the free `ready`
  input makes that considerably harder and it was not attempted here.
