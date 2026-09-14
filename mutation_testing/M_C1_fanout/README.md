# Mutation M-C1 — a design Anvil accepts that the SVA suite rejects

*Rubric item: "Capture one design Anvil accepts that your SVA-derived tests catch
as wrong, with an explanation of why it's timing-safe despite being incorrect."*

Target: `port2_static_baseline/` — the 1-IPC pipeline under static `@#1 - @#1`
contracts. This design is used deliberately: it compiles with **every** Anvil
check enabled. (The Phase 2 backpressured port needs `-disable-lt-checks`, which
would reduce "Anvil accepts it" to "Anvil was told not to look.")

## The mutation

`writeback.anv`, line 24 — one field of one struct literal.

Writeback resolves the write-back mux once and fans the result out on **two**
channels: `wb_id` to Decode (the architectural register-file write and the read
bypass) and `wb_ex` to Execute (the MEM/WB forwarding level).

```
 19  let wd = if *mw_m2r == 1'b1 { *mw_mdata } else { *mw_alu } >>
 23  send ep_id.req(wb_update_t::{ write_data = wd;       dest_reg = dst; reg_write = we }) >>
 24  send ep_ex.req(wb_update_t::{ write_data = *mw_alu;  dest_reg = dst; reg_write = we }) >>
                                                ^^^^^^^^ was `wd`
```

Reproduce:

```bash
cp -r port2_static_baseline mut && cd mut
sed -i '24s/write_data = wd;/write_data = *mw_alu;/' writeback.anv
```

The bug it models is the ordinary one: the fan-out was written twice by hand and
the second copy was left with the pre-mux value. Loads reach Decode correctly and
reach Execute as the ALU result (the address) instead of the loaded word.

## Anvil accepts it

| | baseline | mutant |
|---|---|---|
| `anvil top.anv` — lifetime checks **on** | `success: true` | **`success: true`** |
| generated RTL | 974 lines | 976 lines |

No error, no warning, and the compiler cheerfully builds two extra lines of logic
for the mutant.

## Why it is timing-safe despite being wrong

Anvil's guarantee is that any value referenced across cycles is *stable* and
*meaningful* for the window its contract declares. It is a statement about
**when** a wire is valid. It says nothing about **what** the wire carries.

1. **The lifetime arithmetic is unchanged.** `*mw_alu` is a read of the same
   register, at the same point in the same loop body, borrowed for the same
   window as `wd` — indeed `wd` is *itself* `*mw_alu` on the non-load path.
   There is no fact about the mutant that a lifetime check could dislike.

2. **Each channel is checked in isolation.** `wb_id` and `wb_ex` are two separate
   instances of the class `wb_ch`:

   ```
   chan wb_ch { right req : (wb_update_t @#1) @#1 - @#1 }
   chan wb_id_le -- wb_id_ri : wb_ch;
   chan wb_ex_le -- wb_ex_ri : wb_ch;
   ```

   Anvil verifies, per instance, that exactly one message is produced and one
   consumed every cycle and that the payload is live for its declared `@#1`.
   All of that is true of both instances, in both the baseline and the mutant.

3. **No contract can relate two channels.** A sync mode may only reference a
   message inside its own channel class (`@#msg + k`). "These two buses must
   carry the same value" is not an unchecked obligation — it is one the type
   system cannot express at all.

The point worth making in the report is the last one, sharpened: **this bug class
exists *because* of the static contract.** Under `@#1 - @#1` the compiler emits
zero handshake wires (0 in this RTL, against 464 in the serialised version).
Under a dynamic contract the fan-out was still two transactions, but each one was
acknowledged. Anvil bought a cheaper interface by deleting the acknowledgement,
and the deleted acknowledgement was the last thing that made the two copies one
transaction. Timing safety is per-channel and per-value-window; datapath
agreement across channels is out of scope by construction.

## Which assertion catches it

`anvil_1ipc_sva.sv`, line 406:

```systemverilog
a_C1_wb_fanout_identical: assert property (@(posedge clk_i) disable iff (!rst_ni)
  wb_id === wb_ex)
  else $error("C1: Writeback's two fan-out copies differ - ID and EX disagree on the commit");
```

`tb_c1_checker.sv` in this directory re-expresses C1 as a procedural check with
identical sampling semantics, so the experiment runs under Icarus without a
Verilator/XSim SVA flow.

### Measured — Icarus 12.0, 40 cycles

```
BASELINE   C1 fired 0 times    r1=20 r2=0   r3=0 r4=20  dmem[word5]=20   scoreboard PASS
MUTANT     C1 fired 1 time     r1=20 r2=-20 r3=0 r4=0   dmem[word5]=0    scoreboard FAIL

  C1 VIOLATION @cyc 5: wb_id=0000000503   wb_ex=0000000003
                        write_data=20      write_data=0
                        dest_reg=r1        dest_reg=r1
                        reg_write=1        reg_write=1
```

C1 fires exactly **once**, on the single cycle a load occupies WB, and names the
two buses and the disagreeing field.

> Note for anyone re-running: the M-C entry in the `anvil_1ipc_sva.sv` header
> predicted "killed by C1 alone (40x)" for a *flipped bit*, which differs every
> cycle. This mutation differs only when `mem_to_reg` is set, so the measured
> count is 1. Quote the measured 1x.

### What the end-to-end scoreboard sees instead

| cycle | baseline | mutant |
|---|---|---|
| 3 | load-use stall | load-use stall (hazard unit is untouched) |
| 5 | `wb_id`/`wb_ex` both carry 20 | **C1 fires** |
| 7 | branch taken, PC redirected | branch **not** taken — `r2 = -20`, so `jz` falls through |
| 12 | `r4 = 20` | `r4 = 0` |
| end | `dmem[word5] = 20` | `dmem[word5] = 0` — the store went to address 0 |

One field in one struct literal, and the program takes the wrong branch and
writes to the wrong memory address. `r1` is still 20 — the ID copy was untouched,
so the register file is correct and only the bypass is poisoned. That is exactly
the failure shape an end-to-end test localises worst: three wrong registers and a
missing store, 35 cycles after the cause, with nothing pointing at Writeback.

## Generalisation

`a_C2_branch_fanout_identical` (`br_if === br_id`) is the same property for
Execute's two-way branch fan-out. The bug class is systematic — one property per
fan-out point — not a one-off.

## Files

| File | What it is |
|---|---|
| `writeback_MUTANT.anv` | the mutated Writeback (drop into a copy of `port2_static_baseline/`) |
| `tb_c1_checker.sv` | C1 as a procedural checker + end-state scoreboard, Icarus-compatible |

```bash
anvil top.anv > mut.sv                      # succeeds, all checks on
iverilog -g2012 -o m.vvp mut.sv tb_c1_checker.sv && ./m.vvp
```
