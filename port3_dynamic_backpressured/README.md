# Phase 2 — the Anvil port of the backpressured pipeline

Port of `sv_baseline/` (5-stage MIPS + `req`/`ready` data memory + 59 SVAs)
onto Anvil, replacing the Phase 1 static `@#1 - @#1` contracts with **dynamic
channels** — blocking `send`/`recv` rendezvous with compiler-generated
valid/ack.

Everything here builds and runs with `./build.sh` (needs the Anvil compiler and
`iverilog`).

## Files

| File | What it is |
|---|---|
| `types.anv` | structs + all eleven channel classes, with the contracts commented one by one |
| `fetch.anv` | IF: PC, imem, next-PC priority mux |
| `decode.anv` | ID: IF/ID register, register file, load-use hazard detector |
| `execute.anv` | EX: ID/EX register, forwarding unit, ALU, branch resolve **and the ID/EX branch flush** |
| `memory.anv` | MEM: EX/MEM register, **the dynamic memory transaction** |
| `data_memory.anv` | the variable-latency data memory (Anvil counterpart of `data_memory.sv`) |
| `writeback.anv` | WB: MEM/WB register, write-back mux, fan-out to ID and EX |
| `top.anv` | wiring |
| `lifetime_limit.anv` | minimal reproducer for the checker limitation described below |
| `mips_anvil_bp.sv` | generated RTL, randomised memory (0–3 extra cycles) |
| `mips_anvil_bp_fixed.sv` | generated RTL, fixed minimum-latency memory |
| `tb_mips_bp.sv`, `tb_trace.sv`, `tb_count.sv` | Icarus testbenches |

## Results

Same 7-instruction program as the SystemVerilog baseline
(`lw r1,0(r0); add r2,r1,r0; sub r2,r2,r1; jz r2,L; add r3,r2,r1; L: add r4,r2,r1; sw r1,0(r4)`).

| Build | R1 | R2 | R3 | R4 | R0 | DMEM word 5 | verdict |
|---|---|---|---|---|---|---|---|
| fixed-latency memory | 20 | 0 | **0** | 20 | 0 | 20 | **PASS** |
| randomised memory (0–3 extra cycles) | 20 | 0 | **0** | 20 | 0 | 20 | **PASS** |

`R3 = 0` is the branch flush working; `R0 = 0` throughout (no `$zero` violation);
`DMEM[word 5] = 20` is the store committing exactly once.
Bit-for-bit identical to `mips_pipeline_processor.sv`.

### The freeze, per cycle

Fixed-latency memory — 4 non-advancing cycles in 24:

```
cyc 0..2   PC 0,4,8              1 IPC, memory idle
cyc 3,4    --- pipeline frozen   lw is in MEM
cyc 5..7   PC c,10,14            1 IPC
cyc 8      --- pipeline frozen   load-use BUBBLE (not the memory)
cyc 9..12  PC 18..24             1 IPC
cyc 13     --- pipeline frozen   sw is in MEM
cyc 14..   PC 28..               1 IPC
```

Randomised memory — 7 non-advancing cycles in 24: the two memory stalls grow to
3 cycles each; the load-use bubble stays exactly one cycle. Backpressure is
*exercised*, not declared.

### Cost

| | Phase 1 (static `@#1 - @#1`) | Phase 2 (dynamic) |
|---|---|---|
| cycles / instruction, memory idle | 1 | **1** |
| cycles / instruction, memory busy | n/a (cannot express) | 1 + memory latency |
| generated RTL lines | 974 | 1474 |
| distinct handshake wires in the RTL | 1 | **59** |
| hand-written stall logic | `hz` only | `hz` only |

The 500 extra lines and 59 handshake wires are the price of the dynamic
contracts, and the compiler writes every one of them.

---

## How Anvil's transaction mechanics handled the freeze

This is the part worth reading.

### 1. The freeze is not implemented anywhere

In `mips_pipeline_processor.sv` the freeze is five separate pieces of hand-written
plumbing that all have to agree:

```systemverilog
assign dmem_req   = ex_mem.mem_read | ex_mem.mem_write;
assign mem_stall  = dmem_req & ~dmem_ready;          // one global stall
assign pc_write        = ~load_use_hazard & ~mem_stall;
assign if_id_write     = ~load_use_hazard & ~mem_stall;
assign if_branch_taken =  ex_branch_taken & ~mem_stall;
always_ff @(posedge clk) if (!mem_stall) begin ...every pipeline register... end
```

`mem_stall` is a *level* that must be fanned out to every sequential element and
every control decision, and correctness is the claim that nothing was missed.
The Anvil port has none of it. The whole of the freeze is this, in `memory.anv`:

```
let rd = if is_m == 1'b1 {
             send ep_dm.req(...) >>
             recv ep_dm.resp
         } else { 32'd0 } >>
```

A blocking `recv` parks the `Memory` thread. `Memory` is therefore not at its
`recv ep_in.req`, so `Execute`'s `send ep_out.req(...)` does not complete, so
`Execute` is not at its `recv`, so `Decode`'s `send` does not complete, so
`Fetch`'s `send` does not complete and the PC does not move. **Backpressure is
the transitive closure of "my consumer has not taken it yet"**, and it is
generated, not written. There is no `mem_stall` signal in the design or in the
RTL.

### 2. `wb_done` disappears

The SV needs `wb_done` because MEM/WB is *frozen* rather than bubbled, and an
`always_ff` block re-executes on every clock edge whether or not the pipeline
advanced — so the register-file write would repeat once per stalled cycle:

```systemverilog
always_ff @(posedge clk or posedge reset)
    if (reset) wb_done <= 1'b0; else if (mem_stall) wb_done <= 1'b1; else wb_done <= 1'b0;
assign rf_write_en = mem_wb.reg_write & ~wb_done;     // P34b: exactly once
```

A thread does not re-execute. `set regs[wdest] := wdata` happens once per **round**,
and a round is one write-back, however long the round lasts. The exactly-once
property (P34b) stops being an assertion about a suppression term and becomes a
structural fact. `wb_done` is not in the Anvil port at all.

### 3. Mutant M25 becomes unrepresentable

M25 — "bubble MEM/WB instead of freezing it" — is the headline result of Phase 1b:
the end-to-end scoreboard reports **PASS** on a design that silently drops a
MEM/WB→EX bypass, and only P43 catches it. The mutation is a one-line edit
because in SV the MEM/WB *register* and the MEM/WB *forwarding source* are the
same `always_ff` target, and `<= '0` is always available.

In Anvil `mw_*` is assigned in exactly one place, at the end of `Writeback`'s
round, when `Memory` hands over a new bundle. There is no clock edge during a
stall on which anything could be zeroed. Beyond that, `wb_ch` says it in the type:

```
chan wb_ch {
    right upd  : (wb_update_t @done),   // live until the consumer releases it
    left  done : (logic @#1)
}
```

`@done` means *Writeback may not disturb the value while ID or EX is still
reading it*. In the SV that obligation is a comment plus a run-time assertion; in
Anvil it is a compile error. (See the caveat in the next section — Anvil could
not actually discharge it here, but the intent is stated in the interface rather
than in prose.)

### 4. Mutant M26 becomes unrepresentable

M26 is `mem_stall = ~dmem_ready` — dropping the `dmem_req &` term, so an idle
memory stalls the machine forever. That term exists because `mem_stall` is a
level derived from a `ready` output that is meaningless when no request is
outstanding. Anvil has no `ready` output: a memory that is not asked for
anything simply has no rendezvous pending, and the `if is_m` in `memory.anv`
means no request is issued for a non-memory instruction. The bug has nothing to
attach to.

### 5. P42 becomes a type, not an assertion

`data_memory.sv` states in a comment, and `mips_sva.sv` checks with P42, that the
requester must hold `we`/`addr`/`wdata` stable for the whole time a transaction
is in flight. In Anvil that is the request message's lifetime:

```
chan dmem_ch {
    left  req  : (dmem_req_t @resp),   // live until the response comes back
    right resp : (logic[32]  @#1)
}
```

A design that clocked EX/MEM mid-transaction would be a compile error at the
requester, not a simulation failure at the memory.

### 6. What still has to be said by hand

Two things did **not** come for free.

* **The load-use bubble.** It is genuinely different from the memory freeze —
  the blockage is *upstream*, the back of the pipe drains, and one instruction
  is killed. It is still `hz` in `decode.anv`, computed combinationally exactly
  as in the SV. Anvil helps with backpressure, not with hazards.
* **P44, the liveness bound.** "A transaction completes within `MAX_STALL+1`
  cycles" is not a safety property and no type system discharges it. It stays an
  assertion.

### 7. One structural change the port forced

In Phase 1 the branch flush of ID/EX was done in `Decode` (`live = if kill …`),
using a redirect message from `Execute`. Under dynamic contracts that message
would have to be taken at the *start* of ID's round and consumed at its *end*.
Moving the ID/EX flush into `Execute` — which resolves the branch and therefore
already has the signal — removes the round trip and matches
`if (load_use_hazard || ex_branch_taken) id_ex <= '0;` in the SV more literally
than the Phase 1 code did. `execute.anv` now kills `reg_write`, `mem_read`,
`mem_write` and `branch_zero` on the edge it sends the redirect.

---

## What Anvil would not let us write

**`mips_anvil_bp.sv` is generated with `-disable-lt-checks`.** The design is
timing-correct (verified in simulation, above), but Anvil's lifetime pass rejects
three of the five stages. This is the most interesting result of Phase 2 and it
should not be buried.

### The rule

`lifetime_limit.anv` is the whole thing in ten lines:

```
chan dyn_in  { right req : (logic[32] @#1) }
chan dyn_out { right req : (logic[32] @#1) }

proc DynStage(ei: right dyn_in, eo: left dyn_out) {
    reg r : logic[32];
    loop {
        let x = recv ei.req >>   // arrives at some cycle T
        send eo.req(32'd0) >>    // unbounded wait: completes at T+k, k unknown
        set r := x               // REJECTED: x is only guaranteed at T
    }
}
```

> `Borrow checking failed: Value does not live long enough in reg assignment!`

Give the two channels `@#1 - @#1` contracts instead and the identical body
compiles. **A value taken off a dynamic channel does not survive the next dynamic
exchange in the same thread**, because a dynamic exchange is an unbounded wait
and `@#N` lifetime arithmetic cannot close across it. Declaring a release
message (`@done`) does not help: the release is itself a dynamic exchange.

### Why that hits a pipeline

Every stage of a 5-stage MIPS has to consume more than one dynamically-arrived
value per beat, and they arrive on *different* channels:

| Stage | values consumed in one round | sources |
|---|---|---|
| IF | stall, branch redirect | ID, EX |
| ID | write-back bundle, redirect, next IF/ID slot | WB, EX, IF |
| EX | write-back bundle, next ID/EX slot | WB, ID |
| MEM | load data, next EX/MEM slot | dmem, EX |
| WB | ID release, EX release, next MEM/WB slot | ID, EX, MEM |

Compiling each process on its own:

| Process | verdict |
|---|---|
| `Fetch` | `Value does not live long enough in reg assignment!` (`fetch.anv:61`, `set pc := np`) |
| `Decode` | `Value does not live long enough in reg assignment!` (`decode.anv:127`) |
| `Execute` | `Attempted assignment to a borrowed register!` (`execute.anv:103`, borrowed at `:63`) |
| `Memory` | `Attempted assignment to a borrowed register!` (`memory.anv:59`, borrowed at `:49`) |
| `Writeback` | **OK** |
| `DataMemory` | **OK** |

`Writeback` and `DataMemory` pass because each has exactly one value that has to
cross a wait, and it crosses on the channel that carries the wait.

Anvil's own answer to this is the **dependent sync mode** — `@#msg + k`, as in the
tutorial's `right read_resp : (logic[8]@read_req) @#read_req+1 - @#read_req+1`.
That pins one message's timing to another message's, so lifetimes compose again.
But a sync mode can only reference a message **in the same channel**, and a
pipeline beat is a global event spanning nine channels. There is no way to say
"this exchange happens at the same instant as that exchange on another channel".
So the two available regimes are:

* everything static (Phase 1): lifetimes compose, no variable latency possible;
* everything dynamic (Phase 2): variable latency works, lifetimes do not compose
  for any stage with more than one input.

and the backpressured pipeline sits exactly in the gap between them.

### What would close the gap

Three candidate directions, in increasing order of language change:

1. **Cross-channel sync modes.** Allow `@#other_ep.msg + k`. A stage could then
   anchor all of its exchanges to one nominated beat channel and every `@#N`
   lifetime would close again. This looks like the smallest change that fixes
   the whole class.
2. **A "stable until my next round" lifetime.** Most of the values here are
   combinational functions of registers that only change at the end of a round.
   A lifetime meaning "until this thread's next loop iteration" would be true by
   construction and would discharge `Fetch`, `Decode` and `Memory` immediately.
3. **Bounded dynamic contracts.** `@dyn(≤N)` — a dynamic exchange with a declared
   worst case, which is exactly what `MAX_STALL` already is on the SystemVerilog
   side and what P44 already asserts. Lifetime arithmetic could then use `N`.

### Honest caveat

`-disable-lt-checks` turns off the lifetime pass only; parsing, type checking and
codegen — including all 59 handshake wires — are unaffected, and the resulting
RTL simulates correctly. But the Phase 2 port therefore does **not** carry
Anvil's timing-safety guarantee, and the claims in sections 3 and 5 above
("compile error if broken") are claims about what the contracts *say*, not about
what this build *checked*. That distinction should be stated plainly to the
professor rather than glossed.

---

## Reproducing

```bash
# generate + simulate both memory configurations, and print the cycle trace
ANVIL=/path/to/anvil ./build.sh

# see the checker rejection on its own
/path/to/anvil lifetime_limit.anv
```

## Still open

* `imem` is still indexed `pc[2+:8]` into a 256-word array — same narrowing issue
  the SV side still has on the instruction side.
* No SVAs have been written against the Anvil RTL yet. The generated valid/ack
  wires are named systematically (`_<chan>_<msg>_valid` / `_ack`), so the Phase 1b
  interface properties (P42, P44) should bind to them directly; the data-plane
  properties (P43, P34b) need re-stating over the generated pipeline registers
  (`_spawn_1.regs_q`, `_spawn_3.em_*_q`, …).
* k-induction on the Anvil RTL has not been attempted.
