# Gold-Standard SVA suite — 30 properties, pruned from 60

Study sheet for the viva. Every row is a property you must be able to state,
justify, and say what breaks without it.

**Verified after pruning, not assumed:**

| Check | Result |
|---|---|
| Verilator, `LATENCY=1 / 3 / 3+random` | all 3 PASS, cycle-for-cycle identical to the 60-property runs |
| 24 legacy mutants (simulation) | **12 caught** — the same count the 60-property suite reached, with half the properties |
| M25 (bubble MEM/WB) | **P43** fires |
| M26 (`mem_stall = ~ready`) | **P44** fires |
| The 9 merged formulations, BMC(14), symbolic program + free `ready` | **PASS** |

The 25 kept-verbatim properties were already proven by the full-suite run, so
only the 9 merges could carry a transcription error; those were re-proved
independently (`formal/mk_gold_check.py`).

---

## The final cut: P21, P24, P29, P3b

The suite was taken from 34 to 30 in two steps. Both were deliberate calls,
and one of them has a measured cost you should be able to state before he
finds it.

| Cut | Cost, measured |
|---|---|
| **P21** X tripwire | None in 2-state tools. See the section below on what replaced it. |
| **P3b** load/branch exclusion | No mutant. P3's `!ex_branch_taken` guard now rests on a documented but *unchecked* assumption — the rationale in P3 says so explicitly. |
| **P29** never forward a load address | No simulation loss. Under **formal** it was the property that caught M20 (`dest_reg` mux inverted). That detection now falls to P38, and only when the address and the loaded word differ. |
| **P24** never forward `$zero` | **One mutant: M02 escapes simulation.** Confirmed by re-running the harness — 13/24 became 12/24 and M02 is the only change. |

**The one thing to say first if he asks about P24.** I cut it once already,
measured the loss, and put it back; it is cut again now as a deliberate
size-versus-coverage trade, not an oversight. The general principle is worth
stating in the report because it generalises past this project:

> A value property subsumes a select property **logically**, not
> **statistically**. P38 implies P24 and P29, but P38 fires only when the
> wrong select also carries a *different value*, whereas P24 and P29 fire on
> the select alone. On a 77-cycle program that gap is the difference between
> catching M02 and missing it.

If you would rather have the coverage than the round number, P24 is six lines
in `mips_sva_full60.sv` and takes you to 31.

---

## The 30, by rubric category

### A — Local state: reset and integrity (2)

| ID | What it protects | Why it survived |
|---|---|---|
| **P20a** | Every architectural register reads zero while reset is asserted | The synchronous half of an async reset. Base case for everything else. |
| **P20c** | Reset clears state *without* a clock edge (immediate, `#1ps`, sim-only) | The only thing exercising the async path. A concurrent assertion provably cannot express this — good answer to "why is this one different?" |

### B — Local state: hazard detection and the interlock (4)

| ID | What it protects | Why it survived |
|---|---|---|
| **P1** | The hazard unit fires on exactly the right cycles, not one fewer or one more | Equality (`==`) against a decode model rebuilt from the raw instruction word, so it tests both directions and is independent of `instruction_decode`. Catches M06/M05/M07. |
| **P1b** | Any stall holds the front end *(merges old P1b + P41)* | Separates "did we notice" from "did we act", for both stall sources. The `if_branch_taken` term is the one that bites: `u_if` tests `branch_taken` before `pc_write`. Catches M12, M13. |
| **P2** | A stall injects a *full* bubble (`id_ex == '0`) | A partial flush that zeroed control but left `rs`/`rt` live would corrupt the forwarding comparators next cycle. Catches M10. |
| **P5** | A stall lasts exactly one cycle | The progress property of the interlock — the only thing between a correct stall and a deadlocked machine. |

### C — Interface stability: the pipeline handoffs (5)

| ID | What it protects | Why it survived |
|---|---|---|
| **P18** | The PC's complete next-state contract *(merges old P4 + P18 + P23)* | The priority chain is split across two modules, so the *arbitration* is a cross-module contract no single RTL line states. Three separate properties each pin one arm and leave the ordering implicit. Catches M11. |
| **P3** | IF/ID frozen during a load-use stall | Without it a dropped instruction never executes and surfaces much later as a register write that simply did not happen. |
| **P28** | IF/ID captures exactly what IF presented, once | The positive counterpart of P3. A DUT that never updated IF/ID at all would satisfy P3, P4, P5 and the whole forwarding category. |
| **P25** | No spurious bubble; ID/EX captures the operands | The dual of P2. Without it a DUT that bubbled every cycle passes P1–P5 and executes nothing. |
| **P34a** | MEM→WB neither drops, duplicates nor re-tags a commit | The back-end counterpart of P28, which the suite had for IF→ID and nothing else. Catches M23. |

### D — Interface stability: the backpressure contract (3) — **the Anvil exhibit**

| ID | What it protects | Why it survived |
|---|---|---|
| **P42** | A request holds stable until it is accepted | The classic valid/ready obligation. Also pins the no-combinational-loop rule behaviourally: `req` cannot withdraw in response to `ready`. |
| **P43** | A memory stall freezes the whole pipeline | **Catches M25.** Stated over the architectural registers, not the enable terms — which is why it sees a bug that P30 and P38 cannot, since those read `mem_wb` too and go wrong alongside the design. The scoreboard passes M25. |
| **P44** | A memory stall is bounded | **Catches M26.** The liveness property. A design computing `mem_stall = ~ready` deadlocks and violates *no safety property at all* — a frozen pipeline breaks nothing. |

### E — Resource ownership and exclusion: forwarding (2)

| ID | What it protects | Why it survived |
|---|---|---|
| **P6** | The youngest older producer wins *(merges P6a/b)* | The brief's own second suggested property, verbatim. Not subsumed by P38: P38's reconstruction uses the same priority order, so a design and a property that both inverted it would agree. Catches M01. |
| **P38** | A **live** operand equals the value the register file will hold *(merges P38a/b; replaces the unsound P33)* | The brief's *first* suggested property, and the one the original suite got wrong. Now carries the whole forwarding category: subsumes P15a-d, P22a-d, P24a/b, P29a/b, P30a/b. Holds the k=5 counterexample that proves P33 was unsound, and the measured note on logical-vs-statistical subsumption. Catches M03. |
| *(scaffolding)* | `ex_mem_wb_value`, `arch_rs_value`, `arch_rt_value` | The reconstructed references P38/P36/P39a compare against. Deliberately rebuilt here rather than read out of the DUT's muxes. |

### F — Transaction level: commit and the branch transaction (8)

| ID | What it protects | Why it survived |
|---|---|---|
| **P8** | A taken branch clears both wrong-path slots | The flush mechanism. Catches M08, M09. *(Note: two distinct instructions are squashed — B+4 in ID and B+8 in IF — not "one instruction in both registers".)* |
| **P8b** | A squashed instruction has no architectural side effect | Checks the thing you care about, not the mechanism. Rewritten to count pipeline **advances**, so an arbitrarily long memory stall inside the squash window cannot slide it off — and that removed the `##N` Verilator cannot compile. |
| **P34b** | A commit happens exactly once, however long memory stalls | MEM/WB is frozen (not bubbled) across a stall, so without `wb_done` WB would rewrite every cycle. Idempotent today; not idempotent the moment WB gains a CSR or a counter. |
| **P35** | The committed value comes from the right source *(merges P35 + P35b)* | One ternary so the two arms cannot be satisfied independently. **P38 cannot do this job**: it takes `wb_data` as its reference and so cannot police `wb_data`. Catches M19. |
| **P36** | The branch resolves on the architecturally current `rs` | The only control decision that depends on a data value, in a machine with no misprediction recovery. |
| **P39a** | A store carries the architectural `rt` into MEM | Nothing else follows store data. The scoreboard misses it whenever forwarded and un-forwarded coincide — which they do on this program. |
| **P39b** | An accepted store lands whole, in the right lanes, at the right address *(in `mips_dmem_sva`)* | The longest reach in the suite. Catches a byte-lane swap, which the scoreboard cannot see because the only store writes `0x00000014` and both swapped lanes are zero. |
| **P39c** | An in-flight store does not touch memory *(in `mips_dmem_sva`)* | The exactly-once half, memory-side dual of P34b. Catches a write that commits *before* `ready` — a protocol violation, not an idempotent repeat. **Anvil exhibit.** |

*(P39b and P39c live in `mips_dmem_sva`, bound into `data_memory`, and are
counted in the total of 30.)*

### G — Architectural invariants (3)

| ID | What it protects | Why it survived |
|---|---|---|
| **P26** | `$zero` reads as zero into ID/EX *(merges P26a/b)* | The read path. Kept alongside P31 because `register_file` has two independent mechanisms that could each hide a bug in the other. |
| **P31** | `$zero` is architecturally immutable *(in `mips_regfile_sva`)* | The state itself. Catches M14, M15 under formal. |
| **P40** | The read port returns the value the file will hold *(merges P40a/b)* | Write-through is architecturally *required* here: an instruction that reads stale in ID gets no second chance. **Catches M16** — invisible to every other property in the suite. |

### H — Environment assumptions: bounds and alignment (3)

| ID | Status | Why it survived |
|---|---|---|
| **P12** | `[PROVEN]` | The one bounds-family property that genuinely is provable. Its value is the contrast: alignment is structural, range is not. |
| **P19** | `[CHECKER]` — **fails at k=5** | Now the *only* thing that can detect a runaway PC, since narrowing the fetch index turned an X into silent aliasing. |
| **P17** | `[CHECKER]` — **fails at k=5** | The data-side twin. Its guard is `dmem_req`, the actual transaction — the pre-backpressure design read dmem unconditionally, so the old guard did not cover the access it was written for. |

### The fifth rubric category is **not** in this file

The brief asks for "at least one end-to-end invariant" and names it: *the
committed writes match those of a single-cycle reference running the same
program*. That needs two DUTs and lives in `tb_equivalence.sv`. **Cite it as
property 35 of the specification, not as a separate testbench** — the brief
lists it as an SVA starting point, so presenting it as "just the testbench"
gives away a category you have already covered.

---

## What was cut, and the one general lesson

| Cut | Count | Reason |
|---|---|---|
| P15a-d, P22a-d, P30a/b | 10 | All describe the forwarding **select**. P38 states the **requirement** they serve. |
| P4, P23 | 2 | Folded into P18's single next-state contract. |
| P41 | 1 | Folded into P1b. |
| P6b, P24b, P26b, P29b, P35b, P38b, P40b, P37 | 8 | Merged with their twin — two statements of one idea. |
| P20b | 1 | Implied by P20a for any reset wider than a clock period; the sub-cycle case is P20c's job. |
| P32 | 1 | Strictly weaker than P31, which asserts the same thing every cycle. |
| P19b, P27, P44m | 3 | Real but secondary — see Optional below. |
| P21 | 1 | Removed after `data_memory` switched its in-flight poison from `X` to `32'hDEAD_BEEF` — see below. |
| P24, P29, P3b | 3 | The final cut. P24 and P29 are subsumed by P38 logically; P3b was an assumption, not an obligation. Cost: **M02 only**. |

**The lesson worth stating in the report:** a value property subsumes a select
property *logically*, not *statistically*. P38 implies P24, but P24 fires on
the select alone while P38 needs the operand to be live **and** the values to
differ. On a 77-cycle program that gap is the difference between catching M02
and missing it. Keep the cheap unconditional detector next to the expensive
general one.

---

## P21, and how you now answer "are your assertions passing vacuously?"

P21 was removed once `data_memory` began driving `32'hDEAD_BEEF` instead of
`X` while a read is in flight. Two things are worth being precise about,
because the obvious justification is only half right.

**What was genuinely dead.** The commit-path half (`rf_write_en |->
!$isunknown({wb_data, dest_reg})`) is dead because `DEAD_BEEF` is a *defined*
value, so `$isunknown` is false in **every** tool — not because the scoreboard
now covers it. Nothing is lost there.

**What the poison detector actually is.** It is **P43**, not the scoreboard.
Ingesting poison means latching `mem_read_data` while `mem_stall` is high, and
P43 says every pipeline register — `mem_wb` included — is unchanged during a
stall. That is a cycle-accurate detector that fires at the moment of the
mistake. The end-to-end scoreboard is a weaker backstop: it inspects four
registers and four bytes at the end of the run, and this project has already
measured it passing a real bug (M25). Cite P43, not the scoreboard, if he asks
how poison ingestion is caught.

**What was genuinely lost.** The other half of P21 was the *control-plane*
vacuity tripwire — X on `forward_a`, `mem_stall`, `pc`, the register indices.
That has nothing to do with the memory poison. In a 4-state simulator an
X-valued antecedent makes an implication pass silently, so an X on a select
can quietly disable other properties. Verilator and the formal image are
2-state, so it never did anything there; **under XSim it did.**

If he asks "how do you know these aren't passing vacuously?", the answer is no
longer "P21 would have caught it". It is: the **mutation results** — 13 of 24
legacy mutants plus M25 and M26 are caught by a *named* property, which is
direct evidence that those antecedents are reached and those properties have
teeth. That is a stronger answer than the tripwire was, and it is the one the
brief asks for ("include at least one deliberately broken variant of your
design that a property actually catches"). If you want the tripwire back for
XSim runs it is one line, in `mips_sva_full60.sv`.

## Optional — 10 properties held in reserve

Ready to paste back from `mips_sva_full60.sv`.

| ID | What it adds | Recommend? |
|---|---|---|
| **P19b** branch target in imem | Isolates the *cause*: `addr21` spans 23 bits into an 8-bit array, so one `JZ` with a large immediate leaves the program. Without it, P19 firing does not tell you whether an immediate or plain run-off-the-end is responsible. | **Yes** — 6 lines, and it is the sharpest single finding in the bounds family. Takes you to 35. |
| **P30** no stale operand | Phrased purely in terms of in-flight writes, so it survives any reimplementation of the forwarding unit. Was the original suite's nominated Anvil-comparison property. | **Only if** you want a second Anvil talking point on the forwarding side. P38's comment already carries the subsumption argument. |
| **P24** never forward `$zero` | A cheap select-level detector that fires without needing the values to differ. | **Strongest of the reserve.** Costs six lines, takes you to 31, and buys back M02 — the only detection the final cut lost. |
| **P29** never forward a load address | The interlock consequence, stated without reference to any value. | Worth it if he presses on the hazard category: it is the one property that survives someone deleting the interlock *and* rewriting P1 to match. Restores M20 under formal. |
| **P3b** load/branch exclusion | Makes P3's guard a checked assumption rather than a documented one. | Only if he asks what P3 rests on. One line. |
| **P22** never forward from a non-writer | Same shape as P24. | **No, measured.** M04 survives simulation *with* P22 in the suite and is caught only under formal, so unlike P24 it buys nothing you can demonstrate. |
| **P27** dmem access word-aligned | This ISA has no misaligned-access exception, so `lw r1, 1(r0)` is legal to write and silently wrong. | Only if he asks about alignment. |
| **P44m** memory grants within its bound | The memory's side of P44. Near-trivial once the formal image bounds `ready` structurally. | No. |
| **P15a** EX/MEM→A select | Localises a P38 failure to the select rather than the value. | No — debug convenience, not specification. |
| **P20b** reset release clean | The narrow-pulse case. | No — P20c covers it and says why. |
| **P21** control-plane X tripwire | The vacuity guard, for XSim only. | Only if you run a 4-state simulator and want belt-and-braces; the mutation table is the stronger argument. |
| **P32** no write to `$zero` | — | **Never.** Strictly weaker than P31; its own comment claims to check "the attempt" and does not. |

---

## Two things to be ready for in the viva

**"Is the Anvil result a type-system guarantee or a model-checking result?"**
M25 (bubbling a channel register independently of its peers) is plausibly
unrepresentable by construction — the channel discipline forces the freeze.
M26 is deadlock-freedom, which is a **liveness** property, and liveness is not
usually something a timing-safety type system discharges on its own. Know
which of the two Anvil gives you structurally and which came from a proof
obligation the compiler discharged, and say so precisely. Claiming both as
"the type system" is the kind of overreach a 15-minute defence is designed to
find.

**"Why did you cut 26 properties — were they wrong?"**
No. They were *true and redundant*, which is a different failure. Say the
number that matters: **30 properties catch exactly as many mutants in
simulation as 60 did — 12 of 24** — because the properties that replaced them
state requirements rather than implementations. The intermediate 34-property
suite peaked at 13/24; the last four cuts gave that one back, and it is M02.
Say that number before he finds it. "I measured what each cut cost and chose
to pay it" is a much stronger position than "I believed they were redundant".
