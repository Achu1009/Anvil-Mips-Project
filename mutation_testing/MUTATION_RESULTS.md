# Mutation Testing Results

Ten deliberately broken variants of the pipeline, each a single realistic edit,
run against both testbenches. Reproduce with:

```
python3 run_mutants.py --golden <path-to-src>
```

Simulator: Verilator 5.020 (`--binary --timing --assert`). The golden run is
silent: 43 assertions, zero failures.

The `predicted` column was written **before** running. All nine predictions held.

---

## Results

| | Mutation | Killed by SVA | Killed end-to-end (P11) |
|---|---|---|---|
| **M1** | Forwarding priority inverted (MEM/WB checked before EX/MEM for operand A) | P15, P6, P33 | yes |
| **M2** | `!= 5'd0` guard dropped on the EX/MEM &rarr; A forwarding path | **P24** | **no** |
| **M3** | Load-use detection compares `id_ex.rd` instead of `id_ex.rt` | P1, P29, P33 | yes |
| **M4** | IF/ID flush on a taken branch removed | **P8** | **no** |
| **M5** | ID/EX bubble on a taken branch removed | P8 (also P8b under xsim &mdash; see note) | yes |
| **M6** | PC not frozen during a load-use stall | P1b, P4 | yes |
| **M7** | `$zero` hardwire writes `write_data` instead of zero | **P31** | **no** |
| **M8** | Forward-A mux arm wired to the wrong stage (select stays correct) | **P33** | yes |
| **M9** | Branch target off by one word | **&mdash; survived &mdash;** | yes |
| **M10** | Over-stall: stall after every load, dependency or not | **P1** | yes |

**10 / 10 killed.** No mutant survived both checks.

---

## What the matrix actually shows

**The two checks are complementary, not redundant.** Three mutants (M2, M4, M7)
are completely invisible to the end-to-end equivalence check, and one (M9) is
completely invisible to the SVA suite. Neither on its own is sufficient, which
is the concrete argument for having both.

**M8 justifies P33 on its own.** The mutation rewires the forward-A mux arm to
the wrong stage while leaving the *select* logic untouched. Every select-level
property in the suite &mdash; P15, P6, P22, P24, P29, P30 &mdash; stays silent,
because every one of them only ever inspects `forward_a`/`forward_b`. Only P33,
which compares the operand *value* against the value the register file will
eventually hold, catches it. The end-to-end check also catches it, but ten
cycles later and with no cycle to blame.

**M7 justifies P31 on its own.** Corrupting the `regs[0]` hardwire while leaving
the read-port mux intact means `$zero` still *reads* as zero, so P26 (which
checks the read path) passes, and the architectural behaviour of both processors
is identical, so P11 passes too. P31 checks the stored state directly and is the
only thing that sees it. This is exactly the redundancy argument that motivated
adding P31 alongside P26.

**M2 is behaviourally silent.** Dropping the `$zero` guard changes a forwarding
decision that happens to forward the value zero over the value zero. Nothing
observable changes anywhere in the program, and only P24 notices. A latent bug
that a different program would turn into a real one.

**M4 is caught by the SVA and missed end-to-end.** Removing the IF/ID flush lets
the correct target instruction arrive one cycle early rather than letting a
wrong-path instruction execute, so the final architectural state is unchanged
and P11 is silent. P8 catches it because it checks the flush itself. This is the
clearest case for cycle-level properties over pure output comparison.

**M9 is a real hole in the specification.** Nothing in the SVA suite checks that
the branch *target* is the architecturally correct address. P23 compares the PC
against `$past(ex_branch_target)`, which is the mutated value, so it passes.
P12 (alignment) and P19b (range) both pass on `target+4`. The suite verifies
that the branch mechanism is self-consistent, not that it computes the right
address &mdash; and self-consistency is precisely what survives a mutation of
the address computation.

Closing it inside `mips_sva.sv` would need an independently decoded target,
which means carrying the branch instruction word alongside `id_ex` purely for
the assertion. The honest alternative is to say that this class of bug is what
the end-to-end equivalence check exists for, and to make sure that check is
strong enough to be relied on &mdash; which the current final-state comparison
is not (see the note in `tb_equivalence.sv`).

**M10 is the evidence for rewriting P1.** The original P1 checked

```
(hazard equation) |-> load_use_hazard
```

which only tests one direction: it fires when the design fails to stall, and says
nothing when the design stalls too often. Run against M10, the original P1 does
not fire once. The rewritten P1, which asserts *equality* between the hazard unit
and an independently decoded model, catches it immediately.

M10 needs two edits rather than one, and the harness applies both: the stock
program contains exactly one load and it already stalls, so an over-stall has
nowhere to show up. Two extra instructions (`lw r5, 0(r0)` followed by an
independent `add r6, r0, r0`) give the spurious stall somewhere to appear. That is
itself worth noting &mdash; **the original program cannot distinguish a correct
hazard unit from one that stalls after every single load.**

---

## Correction to an earlier claim about P1

An earlier draft of the audit stated that the original P1 was a tautology of the
form `X |-> X` and could never fail. That was wrong. Its antecedent is a second
copy of the hazard equation written inside the SVA file, not a reference to
`load_use_hazard`, so the two can disagree &mdash; and against M3 (hazard unit
comparing `id_ex.rd` instead of `id_ex.rt`) the original P1 does fire. Verified
by running the original suite, with a corrected 16-port bind, against M3.

The genuine weaknesses, both verified, are the one-directional check described
under M10 above, and the fact that the original reads the DUT's own decoder
outputs (`id_opcode`, `id_rs`, `id_rt`) rather than the raw instruction word, so
a decoder that swapped `rs` and `rt` would feed identical wrong values to the
design and the assertion and they would agree with each other.

---

## Note on M5 and the Verilator shim

`run_mutants.py` applies two documented source shims for Verilator only. One of
them stubs the `##1` continuation in P8b, because Verilator 5.020 does not
implement `##` cycle delays in sequences. That shim weakens P8b to a single
cycle, which is why M5 shows P8 alone here.

With the `##1` intact (xsim), P8b also fires on M5: the un-bubbled wrong-path
`add r3, r2, r1` reaches EX/MEM with `reg_write = 1` two cycles after the
branch, which is exactly the condition P8b was written to catch. Worth
re-running under xsim before quoting this row.

The other shims &mdash; blocking assignment in the array-clear reset loops, and
demoting the assertion `else` clause from `$error` to `$display` so a run
continues past its first failure &mdash; are harness-local and do not change
what any property means.
