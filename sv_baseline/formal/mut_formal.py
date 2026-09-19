#!/usr/bin/env python3
"""Run the two backpressure mutants through the symbolic-program,
free-ready formal harness."""
import os, re, shutil, subprocess

MASK  = ["a_p19_pc_bounds", "a_p19b_branch_tgt_bnds",
         "a_p17_mem_bounds", "a_p27_mem_alignment"]
DEPTH = 16   # > P44's bound (8) + reset cycles, or M26 escapes
SRCF  = ["mips_pkg.sv", "instruction_fetch.sv", "instruction_decode.sv",
         "register_file.sv", "forwarding_unit.sv", "data_memory.sv",
         "mips_pipeline_processor.sv"]

MUT = {
 "M25-bubble-memwb": ("mips_pipeline_processor.sv",
   "        else if (!mem_stall) begin",
   "        else if (mem_stall) begin\n"
   "            mem_wb <= '0;   // MUTANT M25: bubble MEM/WB instead of freezing\n"
   "        end\n"
   "        else if (!mem_stall) begin"),
 "M26-stall-is-not-ready": ("mips_pipeline_processor.sv",
   "    assign mem_stall  = dmem_req & ~dmem_ready;",
   "    assign mem_stall  = ~dmem_ready;   // MUTANT M26: missing dmem_req term"),
}

print("%-26s %-10s %s" % ("mutant", "formal", "properties that fired"), flush=True)
print("-" * 84, flush=True)

for tag, (fn, old, new) in MUT.items():
    d = os.path.abspath("mwork/" + tag)
    shutil.rmtree(d, ignore_errors=True)
    os.makedirs(d)
    for f in SRCF:
        shutil.copy(os.path.join("..", f), d)
    p = os.path.join(d, fn)
    t = open(p).read()
    assert old in t, "MISS " + tag
    open(p, "w").write(t.replace(old, new, 1))

    g = subprocess.run(["python3", "mk_bp_formal.py", d, d + "/f.sv",
                        "--free-imem", "--free-ready"],
                       capture_output=True, text=True)
    if not os.path.exists(d + "/f.sv"):
        print("%-26s %-10s %s" % (tag, "GEN-FAIL", g.stderr[-200:]), flush=True)
        continue

    src = open(d + "/f.sv").read()
    names = re.findall(r"\b(a_p\w+)\s*:\s*assert\s*\(", src)
    s2 = re.sub(r"\b(a_p\w+)\s*:\s*assert\s*\(",
                lambda m: "%s : assert (`D_%s || (" % (m.group(1), m.group(1)), src)
    s2 = re.sub(r"a_p\w+ : assert \(`D_a_p\w+ \|\| \((?:[^;]|\n)*?\);",
                lambda m: m.group(0)[:-2] + "));", s2)
    defs = "\n".join("`define D_%s %s" % (n, "1'b1" if n in MASK else "1'b0")
                     for n in names)
    open(d + "/f_run.sv", "w").write(defs + "\n" + s2)
    open(d + "/run.sby", "w").write(
        "[options]\nmode bmc\ndepth %d\n[engines]\nbtor btormc\n[script]\n"
        "read -sv -formal -DFORMAL f_run.sv\nprep -top mips_pipeline_processor\n"
        "async2sync\n[files]\nf_run.sv\n" % DEPTH)

    r = subprocess.run(["sby", "-f", "run.sby"], cwd=d,
                       capture_output=True, text=True)
    log = r.stdout + r.stderr
    hits = re.findall(r"bad state property (\d+) reachable at bound k = (\d+)", log)
    if hits:
        order = re.findall(r"bad \d+ ([\w.]+)",  # FIXED 2026-09-17: was (a_p\w+), see run_sweep.py
                           open(d + "/run/model/design_btor.btor").read())
        fired = sorted({"%s(k=%s)" % (order[int(i)], k) for i, k in hits})
        print("%-26s %-10s %s" % (tag, "CAUGHT", ", ".join(fired)), flush=True)
    else:
        v = "SURVIVED" if "DONE (PASS" in log else "ERROR"
        print("%-26s %-10s %s" % (tag, v, re.findall(r"ERROR.*", log)[:1]), flush=True)

print("done", flush=True)
