#!/usr/bin/env python3
"""
Mutation testing harness for the 5-stage MIPS pipeline SVA suite.

The project brief asks for "at least one deliberately broken variant of your
design that a property actually catches". This harness produces nine, each a
single realistic edit, and reports which assertion kills which mutant.

A mutant that nothing kills is the interesting result: it is either an
equivalent mutant (no observable difference) or a genuine hole in the
specification. Both are worth writing down.

Usage:
    python3 run_mutants.py --golden ../Lab*/..../src --sim verilator
    python3 run_mutants.py --only M8            # one mutant
    python3 run_mutants.py --list

Verilator 5.020 is the reference simulator (the brief names Verilator and
SymbiYosys). Two shims are applied to the sources for Verilator only, and
both are documented in SHIMS below -- neither is needed under xsim.
"""

import argparse, os, re, shutil, subprocess, sys, tempfile

# ----------------------------------------------------------------------
# Verilator-only source shims. NOT bug workarounds -- tool limitations.
# ----------------------------------------------------------------------
SHIMS = [
    # Verilator: "Delayed assignment to array inside for loops". The reset
    # loops that clear imem/dmem/regs are legal SV and fine in xsim.
    ("imem[i] <= 32'd0;", "imem[i] = 32'd0;"),
    ("dmem[i] <= 8'd0;",  "dmem[i] = 8'd0;"),
    ("regs[i] <= 32'd0;", "regs[i] = 32'd0;"),
    # A failing concurrent assertion ABORTS the run in Verilator, so only the
    # first killer would ever be seen. Demoting the else-clause to $display
    # lets the run continue and reveals every property that catches a mutant.
    # (mips_sva.sv ships with $error, which is what you want in a real run.)
    ("else $error(\"P", "else $display(\"P"),
    # Verilator 5.020 does not implement ## cycle delays in sequences.
    ("""        ex_branch_taken |=> (!ex_mem.reg_write && !ex_mem.mem_write)
                        ##1 (!ex_mem.reg_write && !ex_mem.mem_write);""",
     """        ex_branch_taken |=> (!ex_mem.reg_write && !ex_mem.mem_write);"""),
    ("""                                         load_use_hazard ##2 (forward_a == 2'b01 || forward_b == 2'b01));""",
     """                                         load_use_hazard);"""),
]

RTL = ["mips_pkg.sv", "instruction_fetch.sv", "instruction_decode.sv",
       "forwarding_unit.sv", "register_file.sv", "mips_pipeline_processor.sv",
       "mips_single_cycle.sv", "mips_sva.sv"]
TBS = {"sva": "tb_mips_pipeline_processor.sv", "equiv": "tb_equivalence.sv"}

WARN = ("-Wno-fatal -Wno-TIMESCALEMOD -Wno-DECLFILENAME -Wno-WIDTH "
        "-Wno-UNUSEDSIGNAL -Wno-MULTIDRIVEN -Wno-BLKSEQ -Wno-STMTDLY")

# ----------------------------------------------------------------------
# The mutants. Each is ONE edit that a competent engineer could plausibly
# make by accident. `expect` records the prediction made BEFORE running.
# ----------------------------------------------------------------------
MUTANTS = [
{
 "id": "M1", "file": "forwarding_unit.sv",
 "desc": "Forwarding priority inverted: MEM/WB checked before EX/MEM for operand A",
 "expect": "P6a (priority), P15a, P33a; diverges end-to-end",
 "old": """        if (ex_mem_regwrite && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs)) begin
            forward_a = 2'b10;
        end else if (mem_wb_regwrite && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs)) begin
            forward_a = 2'b01;
        end""",
 "new": """        if (mem_wb_regwrite && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs)) begin
            forward_a = 2'b01;
        end else if (ex_mem_regwrite && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs)) begin
            forward_a = 2'b10;
        end""",
},
{
 "id": "M2", "file": "forwarding_unit.sv",
 "desc": "$zero guard dropped on the EX/MEM -> A forwarding path",
 "expect": "P24a only; behaviourally SILENT in this program",
 "old": "        if (ex_mem_regwrite && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs)) begin",
 "new": "        if (ex_mem_regwrite && (ex_mem_rd == id_ex_rs)) begin",
},
{
 "id": "M3", "file": "mips_pipeline_processor.sv",
 "desc": "Load-use detection compares id_ex.rd instead of id_ex.rt (LW writes rt)",
 "expect": "P1 (independent model), then P29 / P33; diverges end-to-end",
 "old": """    assign load_use_hazard = id_ex.mem_read && (
        ((id_ex.rt == id_rs) && if_uses_rs && (id_ex.rt != 5'd0)) ||
        ((id_ex.rt == id_rt) && if_uses_rt && (id_ex.rt != 5'd0)) // as reg 0 in mips is harwired to 0
    );""",
 "new": """    assign load_use_hazard = id_ex.mem_read && (
        ((id_ex.rd == id_rs) && if_uses_rs && (id_ex.rd != 5'd0)) ||
        ((id_ex.rd == id_rt) && if_uses_rt && (id_ex.rd != 5'd0)) // [MUTANT M3]
    );""",
},
{
 "id": "M4", "file": "mips_pipeline_processor.sv",
 "desc": "IF/ID flush on a taken branch removed",
 "expect": "P8; end-to-end may NOT catch it (same instructions, one cycle earlier)",
 "old": """            if (ex_branch_taken) begin
                if_id <= '0; // Flush
            end""",
 "new": """            if (1'b0) begin
                if_id <= '0; // [MUTANT M4] flush disabled
            end""",
},
{
 "id": "M5", "file": "mips_pipeline_processor.sv",
 "desc": "ID/EX bubble on a taken branch removed (stall bubble kept)",
 "expect": "P8, P8b; wrong-path instruction commits, diverges end-to-end",
 "old": "            if (load_use_hazard || ex_branch_taken) begin",
 "new": "            if (load_use_hazard) begin // [MUTANT M5]",
},
{
 "id": "M6", "file": "mips_pipeline_processor.sv",
 "desc": "PC not frozen during a load-use stall",
 "expect": "P1b, P4; an instruction is dropped, diverges end-to-end",
 "old": "    assign pc_write    = ~load_use_hazard;",
 "new": "    assign pc_write    = 1'b1; // [MUTANT M6]",
},
{
 "id": "M7", "file": "register_file.sv",
 "desc": "$zero hardwire writes write_data instead of zero (read mux left intact)",
 "expect": "P31 ONLY. P26 cannot see it -- the read port still forces 0",
 "old": """            // Hardwire R0 to always be 0
            regs[5'd0] <= 32'd0;""",
 "new": """            // [MUTANT M7] hardwire corrupted
            regs[5'd0] <= write_data;""",
},
{
 "id": "M8", "file": "mips_pipeline_processor.sv",
 "desc": "Forward-A mux arm wired to the wrong stage (select stays correct)",
 "expect": "P33a. Every select-level property (P15/P6/P22/P24/P29/P30) stays silent",
 "old": "            2'b10: ex_forward_a_data = ex_mem.alu_result; //ex/mem forwarding",
 "new": "            2'b10: ex_forward_a_data = wb_data; // [MUTANT M8] wrong stage",
},
{
 "id": "M9", "file": "mips_pipeline_processor.sv",
 "desc": "Branch target off by one word",
 "expect": "NOTHING in the SVA suite. End-to-end equivalence only",
 "old": "        ex_branch_target = {9'd0, id_ex.addr21, 2'b00}; //last 2 bits 0 as all instr are 32 bits",
 "new": "        ex_branch_target = {9'd0, id_ex.addr21, 2'b00} + 32'd4; // [MUTANT M9]",
},

{
 "id": "M10", "file": "mips_pipeline_processor.sv",
 "desc": "Over-stall: stall after EVERY load, dependency or not",
 "expect": "New P1 (equality check). The ORIGINAL P1 misses this entirely -- see notes",
 "old": """    assign load_use_hazard = id_ex.mem_read && (
        ((id_ex.rt == id_rs) && if_uses_rs && (id_ex.rt != 5'd0)) ||
        ((id_ex.rt == id_rt) && if_uses_rt && (id_ex.rt != 5'd0)) // as reg 0 in mips is harwired to 0
    );""",
 "new": "    assign load_use_hazard = id_ex.mem_read; // [MUTANT M10] over-stall",
 # The stock program has exactly one load and it already stalls, so an
 # over-stall is unobservable. Append an independent load/use pair so the
 # spurious stall has somewhere to show up.
 "also": [{
   "file": "instruction_fetch.sv",
   "old": "            imem[6] <= 32'hAC810000; // sw  r1, 0(r4)\n",
   "new": ("            imem[6] <= 32'hAC810000; // sw  r1, 0(r4)\n"
           "            imem[7] <= 32'h8C050000; // lw  r5, 0(r0)      [M10 stimulus]\n"
           "            imem[8] <= 32'h00003020; // add r6, r0, r0  -- does NOT use r5\n"),
 }],
},
]

VIOLATION = re.compile(r"(P\d+[a-z]?) Violated: ([^\\n\"]+)")


def build_and_run(work, tb_file, top, tag, verbose=False):
    files = " ".join(RTL) + " " + tb_file
    cmd = (f"verilator --binary --timing --assert -sv {WARN} "
           f"--x-assign unique --x-initial unique {files} "
           f"--top-module {top} -o {tag}")
    b = subprocess.run(cmd, shell=True, cwd=work, capture_output=True, text=True)
    if not os.path.exists(os.path.join(work, "obj_dir", tag)):
        return None, "BUILD FAILED\n" + b.stdout + b.stderr
    r = subprocess.run(f"./obj_dir/{tag}", shell=True, cwd=work,
                       capture_output=True, text=True, timeout=180)
    out = r.stdout + r.stderr
    hits = []
    for pid, _msg in VIOLATION.findall(out):
        entry = pid
        if entry not in hits:
            hits.append(entry)
    return hits, out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--golden", default=".", help="directory holding the RTL + SVA + testbenches")
    ap.add_argument("--only", default=None, help="comma-separated mutant ids, e.g. M8 or M1,M2")
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--no-shim", action="store_true", help="skip the Verilator source shims")
    ap.add_argument("--keep", action="store_true", help="keep the mutant work directories")
    ap.add_argument("--skip-golden", action="store_true", help="skip the clean reference run")
    args = ap.parse_args()

    if args.list:
        for m in MUTANTS:
            print(f"{m['id']:4} {m['file']:28} {m['desc']}")
        return 0

    golden = os.path.abspath(args.golden)
    need = RTL + list(TBS.values())
    missing = [f for f in need if not os.path.exists(os.path.join(golden, f))]
    if missing:
        print(f"Missing in {golden}: {', '.join(missing)}", file=sys.stderr)
        return 2

    sel = set(args.only.split(",")) if args.only else None
    todo = [m for m in MUTANTS if sel is None or m["id"] in sel]
    results = []

    # ---- golden reference run: the suite must be clean before mutating ----
    print("=" * 78)
    print("GOLDEN RUN (no mutation) -- the suite must be silent here")
    print("=" * 78)
    if args.skip_golden:
        print("  (skipped)")
    base = tempfile.mkdtemp(prefix="mut_golden_")
    for f in need:
        shutil.copy(os.path.join(golden, f), base)
    if not args.no_shim:
        apply_shims(base, need)
    gk, gout = build_and_run(base, TBS["sva"], "tb_mips_pipeline_processor", "g1")
    if gk is None:
        print(gout); return 3
    print(f"  assertions fired : {gk if gk else 'none'}")
    if gk:
        print("  !! golden run is not clean -- fix that before trusting any result below")
    if not args.keep:
        shutil.rmtree(base, ignore_errors=True)

    # ---- mutants ----
    for m in todo:
        work = tempfile.mkdtemp(prefix=f"mut_{m['id']}_")
        for f in need:
            shutil.copy(os.path.join(golden, f), work)

        edits = [{"file": m["file"], "old": m["old"], "new": m["new"]}] + m.get("also", [])
        drifted = False
        for e in edits:
            target = os.path.join(work, e["file"])
            src = open(target).read()
            if e["old"] not in src:
                print(f"{m['id']}: PATTERN NOT FOUND in {e['file']} -- golden sources have drifted")
                drifted = True
                break
            open(target, "w").write(src.replace(e["old"], e["new"], 1))
        if drifted:
            results.append((m, ["<not applied>"], ["<not applied>"]))
            continue

        if not args.no_shim:
            apply_shims(work, need)

        print("=" * 78)
        print(f"{m['id']}  {m['desc']}")
        print(f"      file      : {m['file']}")
        print(f"      predicted : {m['expect']}")

        sva_k, _   = build_and_run(work, TBS["sva"],   "tb_mips_pipeline_processor", "s")
        equiv_k, _ = build_and_run(work, TBS["equiv"], "tb_equivalence",             "e")
        sva_k   = sva_k   if sva_k   is not None else ["<build failed>"]
        equiv_k = equiv_k if equiv_k is not None else ["<build failed>"]

        print(f"      SVA       : {', '.join(sva_k)   if sva_k   else 'SURVIVED'}")
        print(f"      end-to-end: {', '.join(equiv_k) if equiv_k else 'SURVIVED'}")
        results.append((m, sva_k, equiv_k))
        if not args.keep:
            shutil.rmtree(work, ignore_errors=True)

    # ---- summary ----
    print()
    print("=" * 78)
    print("SUMMARY")
    print("=" * 78)
    print(f"{'':4} {'MUTATION':52} {'KILLED BY'}")
    survivors = 0
    for m, sva_k, equiv_k in results:
        ids = []
        for k in sva_k:
            i = k.split()[0]
            if i not in ids and i.startswith("P"):
                ids.append(i)
        e2e = any(k.startswith("P11") for k in equiv_k)
        label = ", ".join(ids) if ids else ""
        if e2e:
            label = (label + " | P11" ) if label else "P11 (end-to-end ONLY)"
        if not label:
            survivors += 1
            label = "SURVIVED"
        print(f"{m['id']:4} {m['desc'][:50]:50} {label}")
    print()
    print(f"{len(results) - survivors}/{len(results)} mutants killed; {survivors} survived.")
    print("A survivor is either an equivalent mutant or a hole in the specification.")
    return 0


def apply_shims(work, files):
    for f in files:
        p = os.path.join(work, f)
        s = open(p).read()
        o = s
        for a, b in SHIMS:
            s = s.replace(a, b)
        if s != o:
            open(p, "w").write(s)


if __name__ == "__main__":
    sys.exit(main())
