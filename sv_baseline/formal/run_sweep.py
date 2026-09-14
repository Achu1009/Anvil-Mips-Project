#!/usr/bin/env python3
"""BMC the model, mask the first reachable bad state, repeat -- so one
sweep enumerates every property that fails rather than stopping at the
first."""
import re, subprocess, sys, shutil
DEPTH = int(sys.argv[1]); BASE = sys.argv[2]
PRE   = sys.argv[3] if len(sys.argv) > 3 else ""
src = open(BASE).read()
names = re.findall(r"\b(a_p\w+)\s*:\s*assert\s*\(", src)
s2 = re.sub(r"\b(a_p\w+)\s*:\s*assert\s*\(",
            lambda m: "%s : assert (`D_%s || (" % (m.group(1), m.group(1)), src)
s2 = re.sub(r"a_p\w+ : assert \(`D_a_p\w+ \|\| \((?:[^;]|\n)*?\);",
            lambda m: m.group(0)[:-2] + "));", s2)
print("maskable asserts:", len(names))
masked = [n for n in PRE.split(",") if n]
for it in range(12):
    defs = "\n".join("`define D_%s %s" % (n, "1'b1" if n in masked else "1'b0") for n in names)
    open("f_run.sv", "w").write(defs + "\n" + s2)
    open("run.sby", "w").write(
        "[options]\nmode bmc\ndepth %d\n[engines]\nbtor btormc\n[script]\n"
        "read -sv -formal -DFORMAL f_run.sv\nprep -top mips_pipeline_processor\n"
        "async2sync\n[files]\nf_run.sv\n" % DEPTH)
    shutil.rmtree("run", ignore_errors=True)
    r = subprocess.run(["sby", "-f", "run.sby"], capture_output=True, text=True)
    log = r.stdout + r.stderr
    hits = re.findall(r"bad state property (\d+) reachable at bound k = (\d+)", log)
    if not hits:
        if "DONE (PASS" in log:
            print("PASS at depth %d, %d masked: %s" % (DEPTH, len(masked), masked)); return_ok = True
        else:
            print("ENGINE PROBLEM:", re.findall(r"ERROR.*", log)[:3])
        break
    order = re.findall(r"bad \d+ (a_p\w+)", open("run/model/design_btor.btor").read())
    for idx, k in hits:
        n = order[int(idx)]
        print("FAIL k=%-3s %s" % (k, n)); masked.append(n)
print("masked:", ",".join(masked))
