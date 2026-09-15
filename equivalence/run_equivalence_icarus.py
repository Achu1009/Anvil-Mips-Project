#!/usr/bin/env python3
"""
run_equivalence.py -- the Part C equivalence test suite.

Drives the SV baseline (sv_baseline/mips_pipeline_processor.sv,
LATENCY=1/RANDOMISE=0 -- the config that reproduces the original
single-cycle-memory baseline bit-for-bit) and the Anvil port
(port2_static_baseline/, the static @#1-@#1 1-IPC design) with the same 8
matched programs from assemble.py, and checks that they agree on:

  * the PC trace (which cycle the PC changes, and to what) -- this is
    the stall/squash-timing check: any divergence here means the two
    pipelines disagree about when to stall or which cycles a squash
    consumes, not just about a final value;
  * the full 32-entry architectural register file after the program
    has drained;
  * the first 16 words of data memory after the program has drained.

Usage:
    python3 run_equivalence.py [--anvil PATH] [--keep]

Env var ANVIL is honoured the same way run_all.sh's is (default: "anvil"
on PATH). --keep preserves the per-program scratch directories for
inspection instead of deleting them.

Exit code is 0 iff every program matches on all three checks.
"""
import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(HERE)
SV_GOLDEN = os.path.join(REPO_ROOT, "sv_baseline")
ANVIL_GOLDEN = os.path.join(REPO_ROOT, "port2_static_baseline")

sys.path.insert(0, HERE)
from assemble import PROGRAMS  # noqa: E402


def sv_imem_lines(prog):
    lines = []
    for i, w in enumerate(prog):
        lines.append(f"            imem[{i}] <= 32'h{w & 0xFFFFFFFF:08x};")
    return "\n".join(lines)


def anvil_imem_lines(prog):
    lines = []
    n = len(prog)
    for i, w in enumerate(prog):
        stmt = f"            set imem[{i}] := 32'h{w & 0xFFFFFFFF:08x}"
        stmt += ";" if i < n - 1 else ""
        lines.append(stmt)
    return "\n".join(lines)


def write_from_template(template_path, marker, replacement, out_path):
    text = open(template_path).read()
    assert marker in text, f"marker {marker!r} not found in {template_path}"
    text = text.replace(marker, replacement)
    open(out_path, "w").write(text)


def run(cmd, cwd, log):
    r = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    log.write(f"$ {' '.join(cmd)}\n{r.stdout}{r.stderr}\n")
    return r.returncode == 0, r.stdout + r.stderr


def parse_trace(text):
    pctrace = []
    regs = {}
    dmem = {}
    for line in text.splitlines():
        m = re.match(r"PCTRACE (\d+) ([0-9a-fA-F]{8})", line)
        if m:
            pctrace.append((int(m.group(1)), m.group(2).lower()))
            continue
        m = re.match(r"REG (\d+) (-?\d+)", line)
        if m:
            regs[int(m.group(1))] = int(m.group(2)) & 0xFFFFFFFF
            continue
        m = re.match(r"DMEM (\d+) (-?\d+)", line)
        if m:
            dmem[int(m.group(1))] = int(m.group(2)) & 0xFFFFFFFF
            continue
    return pctrace, regs, dmem


def run_sv(prog, scratch, anvil_bin, log):
    d = os.path.join(scratch, "sv")
    os.makedirs(d)
    for f in ["mips_pkg.sv", "instruction_decode.sv", "register_file.sv",
              "forwarding_unit.sv", "data_memory.sv", "mips_pipeline_processor.sv"]:
        shutil.copy(os.path.join(SV_GOLDEN, f), d)
    shutil.copy(os.path.join(HERE, "tb_equiv_sv.sv"), d)
    write_from_template(
        os.path.join(HERE, "instruction_fetch.sv.template"),
        "// __IMEM_PROGRAM__", sv_imem_lines(prog),
        os.path.join(d, "instruction_fetch.sv"))

    ok, out = run(["iverilog", "-g2012", "-o", "sim.vvp",
                    "mips_pkg.sv", "instruction_fetch.sv", "instruction_decode.sv",
                    "register_file.sv", "forwarding_unit.sv", "data_memory.sv",
                    "mips_pipeline_processor.sv", "tb_equiv_sv.sv"], d, log)
    if not ok:
        return False, "compile failed", None
    ok, out = run(["./sim.vvp"], d, log)
    if not ok or "DONE" not in out:
        return False, "simulation failed", None
    return True, None, out


def run_anvil(prog, scratch, anvil_bin, log):
    d = os.path.join(scratch, "anvil")
    os.makedirs(d)
    for f in ["decode.anv", "execute.anv", "memory.anv", "writeback.anv",
              "top.anv", "types.anv"]:
        shutil.copy(os.path.join(ANVIL_GOLDEN, f), d)
    shutil.copy(os.path.join(HERE, "tb_equiv_anvil.sv"), d)
    write_from_template(
        os.path.join(HERE, "fetch.anv.template"),
        "// __IMEM_PROGRAM__", anvil_imem_lines(prog),
        os.path.join(d, "fetch.anv"))

    ok, out = run([anvil_bin, "top.anv"], d, log)
    if not ok:
        return False, "anvil compile failed", None
    # anvil writes to stdout; capture it into the RTL file ourselves since
    # run() already captured stdout into the log -- redo with redirection.
    r = subprocess.run([anvil_bin, "top.anv"], cwd=d, capture_output=True, text=True)
    if r.returncode != 0 or not r.stdout.strip():
        log.write(r.stdout + r.stderr)
        return False, "anvil compile produced no RTL", None
    open(os.path.join(d, "mips_anvil_pipelined.sv"), "w").write(r.stdout)

    ok, out = run(["iverilog", "-g2012", "-o", "sim.vvp",
                    "mips_anvil_pipelined.sv", "tb_equiv_anvil.sv"], d, log)
    if not ok:
        return False, "iverilog compile failed", None
    ok, out = run(["./sim.vvp"], d, log)
    if not ok or "DONE" not in out:
        return False, "simulation failed", None
    return True, None, out


def normalize_anvil_boot_offset(an_pc):
    """Anvil's Fetch process spends its first post-reset cycle loading imem
    and setting init_done (PC held at 0 that whole cycle) before advancing;
    the SV baseline's reset block preloads pc=0 and imem together during
    reset itself, so its very first post-reset edge already shows pc=4.
    Confirmed by inspection (not assumed): with this stripped, every
    subsequent (cycle, pc) pair in Anvil's trace equals SV's trace shifted
    by exactly +1 cycle. This is a genuine, structural one-cycle boot
    difference between the two designs, not a bug in either -- normalize
    it here, explicitly, rather than let it read as 8/8 false mismatches.
    """
    if an_pc and an_pc[0] == (0, "00000000"):
        return [(cyc - 1, pc) for cyc, pc in an_pc[1:]]
    return an_pc


def compare(sv_out, anvil_out):
    sv_pc, sv_regs, sv_dmem = parse_trace(sv_out)
    an_pc_raw, an_regs, an_dmem = parse_trace(anvil_out)
    an_pc = normalize_anvil_boot_offset(an_pc_raw)

    mismatches = []
    if sv_pc != an_pc:
        mismatches.append(f"PC trace differs after boot-offset normalization: "
                           f"SV has {len(sv_pc)} PC-change events, Anvil has {len(an_pc)}")
        for i in range(min(len(sv_pc), len(an_pc))):
            if sv_pc[i] != an_pc[i]:
                mismatches.append(f"  first divergence at event {i}: SV={sv_pc[i]} Anvil={an_pc[i]}")
                break
    for k in range(32):
        sv_v = sv_regs.get(k)
        an_v = an_regs.get(k)
        if sv_v != an_v:
            mismatches.append(f"REG r{k}: SV={sv_v} Anvil={an_v}")
    for k in range(16):
        sv_v = sv_dmem.get(k)
        an_v = an_dmem.get(k)
        if sv_v != an_v:
            mismatches.append(f"DMEM word {k}: SV={sv_v} Anvil={an_v}")
    return mismatches


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--anvil", default=os.environ.get("ANVIL", "anvil"))
    ap.add_argument("--keep", action="store_true")
    args = ap.parse_args()

    log_dir = os.path.join(HERE, "equivalence_logs")
    os.makedirs(log_dir, exist_ok=True)

    all_ok = True
    print(f"{'program':<22} {'SV':<8} {'Anvil':<8} {'result'}")
    print("-" * 70)

    for name, prog in PROGRAMS.items():
        scratch = tempfile.mkdtemp(prefix=f"equiv_{name}_")
        log_path = os.path.join(log_dir, f"{name}.log")
        with open(log_path, "w") as log:
            sv_ok, sv_err, sv_out = run_sv(prog, scratch, args.anvil, log)
            an_ok, an_err, an_out = run_anvil(prog, scratch, args.anvil, log)

            if not sv_ok or not an_ok:
                result = f"FAIL ({sv_err or ''} {an_err or ''})".strip()
                all_ok = False
            else:
                mismatches = compare(sv_out, an_out)
                if mismatches:
                    result = "MISMATCH:\n    " + "\n    ".join(mismatches)
                    all_ok = False
                else:
                    result = "MATCH"

            print(f"{name:<22} {'ok' if sv_ok else 'FAIL':<8} "
                  f"{'ok' if an_ok else 'FAIL':<8} {result}")
            print(f"  (log: {log_path})" if not (sv_ok and an_ok and result == 'MATCH') else "", end="")
            if not (sv_ok and an_ok and result == "MATCH"):
                print()

        if args.keep:
            print(f"  scratch kept at: {scratch}")
        else:
            shutil.rmtree(scratch, ignore_errors=True)

    print("-" * 70)
    print("ALL PROGRAMS MATCH" if all_ok else "AT LEAST ONE PROGRAM MISMATCHED OR FAILED TO BUILD/RUN")
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
