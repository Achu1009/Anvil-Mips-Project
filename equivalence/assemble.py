#!/usr/bin/env python3
"""
assemble.py -- a tiny assembler for the project's MIPS subset (add, sub,
lw, sw, jz) and the 8 differential-testing programs used by the
equivalence suite.

Encoding, confirmed against the golden RTL (not assumed):
  R-type (add/sub): [31:26]=000000  [25:21]=rs  [20:16]=rt  [15:11]=rd
                     [10:6]=00000   [5:0]=funct  (add=0x20, sub=0x22)
  LW:  [31:26]=100011  [25:21]=rs(base)  [20:16]=rt(dest)  [15:0]=imm16
  SW:  [31:26]=101011  [25:21]=rs(base)  [20:16]=rt(src)   [15:0]=imm16
  JZ:  [31:26]=000010  [25:21]=rs        [20:0]=addr21 (absolute WORD
       address of the target -- not a byte address, not PC-relative;
       confirmed from both mips_pipeline_processor.sv
       ("ex_branch_target = {9'd0, id_ex.addr21, 2'b00}") and
       execute.anv ("btgt = a21 shl 32'd2").

Both instruction_fetch.sv (reset block) and fetch.anv (Fetch's boot
branch) hardcode the program directly as literal 32-bit words -- there
is no $readmemh path on either side in the golden design, so this
script's job is to emit the literal `imem[k] <= ...;` / `set imem[k] :=
...;` lines that get spliced into per-program copies of those two files.
"""

OP_RTYPE = 0b000000
OP_LW    = 0b100011
OP_SW    = 0b101011
OP_JZ    = 0b000010
FUNCT_ADD = 0b100000
FUNCT_SUB = 0b100010


def _u16(imm):
    if imm < 0:
        imm += 1 << 16
    assert 0 <= imm < (1 << 16), f"imm16 out of range: {imm}"
    return imm


def rtype(funct, rd, rs, rt):
    return (OP_RTYPE << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (0 << 6) | funct


def ADD(rd, rs, rt):
    return rtype(FUNCT_ADD, rd, rs, rt)


def SUB(rd, rs, rt):
    return rtype(FUNCT_SUB, rd, rs, rt)


def LW(rt, imm, rs):
    return (OP_LW << 26) | (rs << 21) | (rt << 16) | _u16(imm)


def SW(rt, imm, rs):
    return (OP_SW << 26) | (rs << 21) | (rt << 16) | _u16(imm)


def JZ(rs, word_target):
    assert 0 <= word_target < (1 << 21), f"jz target out of range: {word_target}"
    return (OP_JZ << 26) | (rs << 21) | word_target


NOP = ADD(0, 0, 0)  # add r0, r0, r0 -- both sides decode this as a harmless no-op

# ---------------------------------------------------------------------------
# The 8 differential programs.
# ---------------------------------------------------------------------------
# Both DUTs seed data memory word 0 (byte address 0) to 20 on reset/boot,
# so `lw rX, 0(r0)` reliably produces a known, non-zero starting value.

PROGRAMS = {}

# 1. Original program -- the existing project baseline, reused verbatim as
#    the regression anchor for the new suite.
PROGRAMS["01_original"] = [
    LW(1, 0, 0),      # 0: lw  r1, 0(r0)          r1 <- 20
    ADD(2, 1, 0),     # 1: add r2, r1, r0         load-use stall here
    SUB(2, 2, 1),     # 2: sub r2, r2, r1         r2 <- 0   (EX/MEM forward)
    JZ(2, 5),         # 3: jz  r2, 5              taken
    ADD(3, 2, 1),     # 4: add r3, r2, r1         SQUASHED
    ADD(4, 2, 1),     # 5: L: add r4, r2, r1      r4 <- 20
    SW(1, 0, 4),      # 6: sw  r1, 0(r4)          dmem[word 20] <- 20
]

# 2. Distinguishable branch target -- squash always kills exactly the next
#    two fetched words regardless of where the branch actually lands, so
#    this checks that the ENCODED target (word 6, not "the word right
#    after the squash window", word 5) is what's honoured.
PROGRAMS["02_branch_target"] = [
    LW(1, 0, 0),      # 0: lw  r1, 0(r0)          r1 <- 20
    SUB(2, 1, 1),     # 1: sub r2, r1, r1         r2 <- 0
    JZ(2, 6),         # 2: jz  r2, 6              taken -> word 6
    ADD(5, 1, 1),     # 3: add r5, r1, r1         SQUASHED
    ADD(6, 1, 1),     # 4: add r6, r1, r1         SQUASHED
    ADD(7, 1, 1),     # 5: add r7, r1, r1         never fetched (jumped over)
    ADD(8, 1, 0),     # 6: add r8, r1, r0         landed here: r8 <- 20
    SW(8, 4, 0),      # 7: sw  r8, 4(r0)          dmem[word 1] <- 20
]

# 3. Far jump -- a taken branch (unconditionally, via $zero as rs) whose
#    target is 9 words downstream, exercising more of the 21-bit address
#    field than the other programs and confirming a longer squash-and-skip
#    gap doesn't corrupt anything in either implementation.
PROGRAMS["03_far_jump"] = [
    SUB(1, 0, 0),     # 0: sub r1, r0, r0         r1 <- 0
    JZ(1, 10),        # 1: jz  r1, 10             always taken -> word 10
    ADD(2, 0, 0),     # 2: SQUASHED
    ADD(3, 0, 0),     # 3: SQUASHED
    NOP,              # 4: never fetched (skipped by the far jump)
    NOP,              # 5
    NOP,              # 6
    NOP,              # 7
    NOP,              # 8
    NOP,              # 9
    LW(5, 0, 0),      # 10: lw  r5, 0(r0)         landed here: r5 <- 20
    SW(5, 8, 0),      # 11: sw  r5, 8(r0)         dmem[word 2] <- 20
]

# 4. Four-deep RAW chain -- the exact chain already cited (and manually
#    verified) in Anvil-MIPS-Port-Review.md: a load followed by three
#    chained ALU ops, each consuming the immediately preceding result.
#    Exercises the load-use stall once and EX/MEM forwarding three times
#    in a row.
PROGRAMS["04_raw_chain"] = [
    LW(1, 0, 0),      # 0: lw  r1, 0(r0)          r1 <- 20
    ADD(2, 1, 0),     # 1: add r2, r1, r0         load-use stall, then r2 <- 20
    ADD(3, 2, 0),     # 2: add r3, r2, r0         EX/MEM forward, r3 <- 20
    ADD(4, 3, 0),     # 3: add r4, r3, r0         EX/MEM forward, r4 <- 20
]

# 5. Write to $zero -- an R-type instruction that targets r0 as its
#    destination; the value must not stick, and the very next instruction
#    reading r0 must see 0, not the attempted write.
PROGRAMS["05_write_zero"] = [
    LW(1, 0, 0),      # 0: lw  r1, 0(r0)          r1 <- 20
    ADD(0, 1, 1),     # 1: add r0, r1, r1         attempted r0 <- 40, must stay 0
    ADD(2, 0, 1),     # 2: add r2, r0, r1         r2 <- 0 + 20 = 20 (proves r0 stayed 0)
]

# 6. Load into $zero -- a load whose destination is r0.
PROGRAMS["06_load_zero"] = [
    LW(0, 0, 0),      # 0: lw  r0, 0(r0)          attempted r0 <- 20, must stay 0
    ADD(1, 0, 0),     # 1: add r1, r0, r0         r1 <- 0 (proves r0 stayed 0)
]

# 7. Store-then-load -- a store followed one instruction later by a load
#    from the SAME address, with no forwarding path between them: this is
#    a pure memory-ordering check through the shared single-port memory.
PROGRAMS["07_store_then_load"] = [
    LW(1, 0, 0),      # 0: lw  r1, 0(r0)          r1 <- 20
    ADD(2, 1, 1),     # 1: add r2, r1, r1         r2 <- 40
    SW(2, 12, 0),     # 2: sw  r2, 12(r0)         dmem[word 3] <- 40
    LW(3, 12, 0),     # 3: lw  r3, 12(r0)         r3 <- dmem[word 3], must read 40
]

# 8. Double load-use -- two independent load-use hazards back to back,
#    checking that the hazard detector re-arms correctly and doesn't leak
#    state from the first stall into the second.
PROGRAMS["08_double_load_use"] = [
    LW(1, 0, 0),      # 0: lw  r1, 0(r0)          r1 <- 20
    ADD(2, 1, 0),     # 1: add r2, r1, r0         load-use stall #1, r2 <- 20
    LW(3, 4, 0),      # 2: lw  r3, 4(r0)          r3 <- dmem[word 1] = 0
    ADD(4, 3, 0),     # 3: add r4, r3, r0         load-use stall #2, r4 <- 0
]


def words_hex(prog):
    return [f"{w & 0xFFFFFFFF:08x}" for w in prog]


if __name__ == "__main__":
    import sys
    for name, prog in PROGRAMS.items():
        print(f"{name}: {len(prog)} words")
        for i, w in enumerate(prog):
            print(f"  {i:3d}: 0x{w & 0xFFFFFFFF:08x}")
