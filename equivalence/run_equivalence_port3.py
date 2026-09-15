#!/usr/bin/env python3
"""
run_equivalence_port3.py -- targets port3_dynamic_backpressured,
used by run_all.sh's Stage 5 under --port3.

Verilator-based, unified with the rest of the toolchain -- see
run_equivalence.py's docstring for the full Icarus->Verilator
rationale. This replaced run_equivalence_port3_trial.py (an earlier
Icarus-based diagnostic script, kept in the repo for reference but no
longer wired into run_all.sh) after confirming Verilator handles
port3's dynamic-channel RTL cleanly too, with no combinational-loop
failures -- see README.md, "Verification Toolchain".

UPDATE (carried over from run_equivalence_port3_trial.py): initial
trial runs showed all 8 programs already match bit-for-bit on final
registers and DMEM, but mismatch on PC-trace event count (SV ~58-60
events, Anvil ~95-99) -- expected, because port3's dynamic
send-first/.upd handshake rounds cost real cycles the SV baseline
(and port2) don't spend. Per that same prior decision, THIS script
also checks ARCHITECTURAL equivalence only (final regs + dmem) and
does NOT gate PASS/FAIL on PC-trace/cycle-count match. The cycle-count
difference is still computed and printed as a non-gating informational
note -- never delete that reporting. A result from this script must be
described as "architectural equivalence" in any writeup, not
"equivalence" or "match" unqualified, and never as cycle-accurate
parity.

Differences from run_equivalence_port3_trial.py, each mirroring the
Icarus->Verilator swap already made in run_equivalence.py (see
that file's docstring for the full rationale -- summarized here):

  * Build: `iverilog -g2012 -o sim.vvp <files>` becomes
    `verilator --binary --timing -Wno-fatal -Wno-TIMESCALEMOD
    --top-module <top> <files>`, via the same verilate() helper.
  * Run: `./sim.vvp` becomes exec'ing the compiled binary directly at
    `./obj_dir/V<top>` -- no `vvp` involved anywhere.
  * Parsing: parse_trace()'s PCTRACE/REG/DMEM regexes are unchanged
    (line-by-line, skip-on-no-match, so they tolerate whatever a
    different simulator prints around the testbench's own $display
    output). extract_verilator_error() and
    strip_verilator_finish_notice() are carried over unchanged from
    run_equivalence.py.

Differences from run_equivalence.py / run_equivalence.py (port2),
each forced by a real, confirmed incompatibility (not guessed) --
carried over unchanged from run_equivalence_port3_trial.py:
  * ANVIL_GOLDEN -> port3_dynamic_backpressured.
  * Anvil invocations pass -disable-lt-checks (port3's own README:
    the lifetime pass rejects 3 of 5 stages; codegen is unaffected).
  * The .anv copy list adds data_memory_bp_fixed.anv (renamed to
    data_memory.anv in the scratch dir) instead of using port3's
    default data_memory.anv -- this is the FIXED-latency variant
    (extra_latency -> 2'd0), which data_memory.anv's own comment
    confirms reproduces "the pre-backpressure cadence" -- i.e. it's
    the one config that's actually comparable to tb_equiv_sv.sv's
    existing DMEM_LATENCY=1/RANDOMISE=0 SV config without also having
    to solve independently-random-LFSRs-won't-line-up. The SV side
    (tb_equiv_sv.sv, SV_GOLDEN) is UNCHANGED.
  * Uses fetch_bp.anv.template (port3's real fetch.anv, send-first /
    .upd round shape, with the imem block swapped for the marker) and
    tb_equiv_anvil_bp.sv (MipsPipelineBP / _spawn_5.mem_q), not the
    port2-shaped originals.

Usage:
    python3 run_equivalence_port3.py [--anvil PATH] [--verilator PATH] [--keep]
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
ANVIL_GOLDEN = os.path.join(REPO_ROOT, "port3_dynamic_backpressured")

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


# Verilator's %Error:/%Warning-XXX: lines (the latter only fatal without
# -Wno-fatal) -- used only to pull a short, useful reason out of a failed
# compile's log. Carried over unchanged from run_equivalence.py.
VERILATOR_ERROR_RE = re.compile(r"^%Error[-\w]*:.*$", re.MULTILINE)

# Verilator's own notice for a plain $finish (goes to stderr; Icarus/vvp
# prints nothing at all for $finish). Carried over unchanged from
# run_equivalence.py.
VERILATOR_FINISH_NOTICE_RE = re.compile(r"^- .*: Verilog \$finish\s*$", re.MULTILINE)


def extract_verilator_error(text):
    """Pull the first %Error: line out of a failed Verilator build's
    output, for a more useful "compile failed" reason than Icarus's
    equivalent (which was never parsed either)."""
    m = VERILATOR_ERROR_RE.search(text)
    return m.group(0).strip() if m else None


def strip_verilator_finish_notice(text):
    """Drop Verilator's "- file:line: Verilog $finish" stderr notice
    before logging/inspecting run output, so what's left reads like the
    Icarus/vvp shape. parse_trace() already ignores this line on its
    own since it matches none of the trace regexes -- this is cosmetic."""
    return VERILATOR_FINISH_NOTICE_RE.sub("", text).strip()


def verilate(files, top, d, log, verilator_bin):
    """Build `files` with Verilator (--binary --timing), top module
    pinned explicitly so the output binary's path is deterministic, then
    return (ok, err_msg, binary_path). See run_equivalence.py for
    the full rationale -- identical helper, ported unchanged."""
    ok, out = run(
        [verilator_bin, "--binary", "--timing", "-Wno-fatal", "-Wno-TIMESCALEMOD",
         "--top-module", top] + files,
        d, log)
    if not ok:
        reason = extract_verilator_error(out) or "verilator compile failed"
        return False, reason, None

    binary = os.path.join(d, "obj_dir", f"V{top}")
    if not os.path.isfile(binary):
        return False, f"verilator reported success but {binary!r} is missing", None
    return True, None, binary


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


def run_sv(prog, scratch, anvil_bin, verilator_bin, log):
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

    ok, err, binary = verilate(
        ["mips_pkg.sv", "instruction_fetch.sv", "instruction_decode.sv",
         "register_file.sv", "forwarding_unit.sv", "data_memory.sv",
         "mips_pipeline_processor.sv", "tb_equiv_sv.sv"],
        "tb_equiv_sv", d, log, verilator_bin)
    if not ok:
        return False, err, None

    ok, out = run([binary], d, log)
    out = strip_verilator_finish_notice(out)
    if not ok or "DONE" not in out:
        return False, "simulation failed", None
    return True, None, out


def run_anvil(prog, scratch, anvil_bin, verilator_bin, log):
    d = os.path.join(scratch, "anvil")
    os.makedirs(d)
    for f in ["decode.anv", "execute.anv", "memory.anv", "writeback.anv",
              "top.anv", "types.anv"]:
        shutil.copy(os.path.join(ANVIL_GOLDEN, f), d)
    # FIXED-latency data_memory.anv, not port3's default (randomised) one --
    # see module docstring for why.
    shutil.copy(os.path.join(HERE, "data_memory_bp_fixed.anv"),
                os.path.join(d, "data_memory.anv"))
    shutil.copy(os.path.join(HERE, "tb_equiv_anvil_bp.sv"), d)
    write_from_template(
        os.path.join(HERE, "fetch_bp.anv.template"),
        "// __IMEM_PROGRAM__", anvil_imem_lines(prog),
        os.path.join(d, "fetch.anv"))

    ok, out = run([anvil_bin, "-disable-lt-checks", "top.anv"], d, log)
    if not ok:
        return False, "anvil compile failed", None
    r = subprocess.run([anvil_bin, "-disable-lt-checks", "top.anv"],
                        cwd=d, capture_output=True, text=True)
    if r.returncode != 0 or not r.stdout.strip():
        log.write(r.stdout + r.stderr)
        return False, "anvil compile produced no RTL", None
    open(os.path.join(d, "mips_anvil_bp.sv"), "w").write(r.stdout)

    ok, err, binary = verilate(
        ["mips_anvil_bp.sv", "tb_equiv_anvil_bp.sv"],
        "tb_equiv_anvil_bp", d, log, verilator_bin)
    if not ok:
        return False, err, None

    ok, out = run([binary], d, log)
    out = strip_verilator_finish_notice(out)
    if not ok or "DONE" not in out:
        return False, "simulation failed", None
    return True, None, out


def normalize_anvil_boot_offset(an_pc):
    """Same structural one-cycle boot offset as port2 -- Fetch's first
    post-reset cycle loads imem/init_done before advancing. Not
    reverified specifically for port3 here; if this mismatches on PC
    trace by a suspicious constant offset, check this first before
    assuming the design is wrong. (Not that it matters for PASS/FAIL --
    PC trace isn't gated here -- but it feeds the informational
    cycle-count note below.)"""
    if an_pc and an_pc[0] == (0, "00000000"):
        return [(cyc - 1, pc) for cyc, pc in an_pc[1:]]
    return an_pc


def compare(sv_out, anvil_out):
    sv_pc, sv_regs, sv_dmem = parse_trace(sv_out)
    an_pc_raw, an_regs, an_dmem = parse_trace(anvil_out)
    an_pc = normalize_anvil_boot_offset(an_pc_raw)

    mismatches = []
    pc_note = None
    if sv_pc != an_pc:
        # Intentionally NOT added to `mismatches` / not gating PASS-FAIL.
        # Architectural-equivalence mode: port3's dynamic backpressure
        # handshakes are expected to take a different number of cycles
        # than the SV baseline. Only final regs+dmem are asserted here.
        # Keep this note -- it's the honest caveat for the writeup, not
        # something to silently drop.
        pc_note = (f"(info, not gating) PC trace differs after boot-offset "
                   f"normalization: SV has {len(sv_pc)} PC-change events, "
                   f"Anvil has {len(an_pc)} -- expected from backpressure "
                   f"stall cycles, not treated as a mismatch")
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
    return mismatches, pc_note


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--anvil", default=os.environ.get("ANVIL", "anvil"))
    ap.add_argument("--verilator", default=os.environ.get("VERILATOR", "verilator"))
    ap.add_argument("--keep", action="store_true")
    args = ap.parse_args()

    # Separate log dir from both the Icarus-based
    # run_equivalence_port3_trial.py's equivalence_logs_port3_trial/ and
    # run_equivalence.py's equivalence_logs_vlt/, so none of these
    # runs ever clobber each other's logs.
    log_dir = os.path.join(HERE, "equivalence_logs_port3")
    os.makedirs(log_dir, exist_ok=True)

    all_ok = True
    print("*** port3_dynamic_backpressured, fixed-latency memory, "
          "Verilator-only toolchain (no iverilog/vvp anywhere) ***")
    print("*** Architectural equivalence only -- PC-trace/cycle-count is NOT gated. ***")
    print(f"{'program':<22} {'SV':<8} {'Anvil':<8} {'result'}")
    print("-" * 70)

    for name, prog in PROGRAMS.items():
        scratch = tempfile.mkdtemp(prefix=f"equiv_bp_{name}_")
        log_path = os.path.join(log_dir, f"{name}.log")
        with open(log_path, "w") as log:
            sv_ok, sv_err, sv_out = run_sv(prog, scratch, args.anvil, args.verilator, log)
            an_ok, an_err, an_out = run_anvil(prog, scratch, args.anvil, args.verilator, log)

            if not sv_ok or not an_ok:
                result = f"FAIL ({sv_err or ''} {an_err or ''})".strip()
                all_ok = False
            else:
                mismatches, pc_note = compare(sv_out, an_out)
                if mismatches:
                    result = "MISMATCH:\n    " + "\n    ".join(mismatches)
                    all_ok = False
                else:
                    result = "ARCHITECTURAL MATCH (final regs+dmem; PC/cycle-trace NOT gated)"
                    if pc_note:
                        result += f"\n    {pc_note}"

            passed = sv_ok and an_ok and not mismatches if (sv_ok and an_ok) else False
            print(f"{name:<22} {'ok' if sv_ok else 'FAIL':<8} "
                  f"{'ok' if an_ok else 'FAIL':<8} {result}")
            print(f"  (log: {log_path})" if not passed else "", end="")
            if not passed:
                print()

        if args.keep:
            print(f"  scratch kept at: {scratch}")
        else:
            shutil.rmtree(scratch, ignore_errors=True)

    print("-" * 70)
    print("ALL PROGRAMS ARCHITECTURALLY MATCH (port3, fixed-latency, Verilator -- "
          "final regs+dmem only; PC-trace/cycle-count intentionally NOT "
          "gated here, see module docstring)" if all_ok
          else "AT LEAST ONE PROGRAM MISMATCHED OR FAILED TO BUILD/RUN")
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
