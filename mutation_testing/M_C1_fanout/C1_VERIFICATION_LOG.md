# M-C1 Independent Verification Log

Re-run from scratch on 2026-09-09, independent of the numbers already quoted
in `mutation_testing/M_C1_fanout/README.md` and `MutationC1.md`. Purpose: confirm
those claimed numbers by actually re-executing the compiler and the testbench,
not by re-reading the report.

## Setup

- Duplicated `port2_static_baseline/` → `port2_static_baseline_mut_C1/` (on your
  machine, same parent folder).
- Applied the mutation with the exact command from the report:
  `sed -i '24s/write_data = wd;/write_data = *mw_alu;/' writeback.anv`
- Diffed the result against the pre-existing `mutation_testing/M_C1_fanout/writeback_MUTANT.anv`
  — byte-identical. So this run used the same mutant the earlier report describes,
  not a re-derived approximation of it.
- Compiler: the prebuilt `Anvil_compiler/anvil/_build/default/bin/main.exe`
  (native OCaml binary, GLIBC 2.38+). Your machine's bridged shell runs Ubuntu
  22.04 (GLIBC 2.35), which can't load that binary directly, so the binary and
  the `.anv` sources were run in a separate Ubuntu 24.04 sandbox instead — same
  binary, no rebuild, no edits to it. `iverilog` was installed there fresh:
  Icarus Verilog 12.0 (stable), matching the version the report cites.

## Step 3 — compile, lifetime checks on (no `-disable-lt-checks`)

```
$ anvil -json top.anv        # baseline
success: True
sv lines: 974

$ anvil -json top.anv        # mutant (in port2_static_baseline_mut_C1)
success: True
sv lines: 976
```

Matches the report's table exactly (974 baseline / 976 mutant, both `success: true`).
The only compiler stderr output on either run was 16 identical
`[Warning] The offset is not a constant value for {dmem,regs,imem}, borrowing
full range` lines — diffed baseline-vs-mutant stderr and they're line-for-line
identical, so these are pre-existing array-indexing warnings unrelated to the
mutation, not something the mutation introduced.

## Step 4 — testbench simulation

Ran `tb_c1_checker.sv` (the procedural re-expression of assertion C1) against
both generated `.sv` files with Icarus:

```
$ iverilog -g2012 -o b.vvp baseline.sv tb_c1_checker.sv && ./b.vvp
  end state: r1=20 r2=0 r3=0 r4=20 r0=0 dmem[word5]=20
  C1 fired 0 times
  scoreboard: PASS

$ iverilog -g2012 -o m.vvp mut.sv tb_c1_checker.sv && ./m.vvp
  C1 VIOLATION @cyc 5: wb_id=0000000503  wb_ex=0000000003  (ID and EX disagree on the commit)
  end state: r1=20 r2=4294967276 r3=0 r4=0 r0=0 dmem[word5]=0
  C1 fired 1 times
  scoreboard: FAIL
```

(`r2=4294967276` is `-20` read as unsigned 32-bit — same value the report
quotes as `r2=-20`.)

## Result

Independently reproduced, exactly:
- Anvil accepts the mutant with every lifetime check on (`success: true`,
  974 → 976 lines).
- The SVA-derived checker C1 fires exactly once, at cycle 5, naming
  `wb_id=0000000503` vs `wb_ex=0000000003` — the same values the report cites.
- The end-to-end scoreboard flips PASS → FAIL on the mutant.

This confirms the M-C1 write-up's central claim: a design Anvil's static
timing contracts fully accept is caught by an SVA property that reasons
across two channels, something the per-channel `@#1 - @#1` contract can't
express.

## Files touched on your machine

- `port2_static_baseline_mut_C1/` — new directory, duplicate of
  `port2_static_baseline/` with the M-C1 mutation applied to `writeback.anv`
  line 24. Nothing in the original `port2_static_baseline/` was changed.
- This log.

No existing file was modified.
