#!/usr/bin/env bash
#
# run_all.sh -- one-command reproduction of the SV/SVA baseline and the
# Anvil port's headline results (Rubric §6).
#
# Default (no args): runs all five stages in order:
#   1. SV Baseline Simulation      (Verilator, sv_baseline/)
#   2. SV Formal Verification      (SymbiYosys/btormc, sv_baseline/formal/)
#   3. Anvil Compilation           (port2_static_baseline/, static @#1-@#1 port)
#   4. Anvil M-C1 mutant           (mutation_testing/M_C1_fanout/, matches
#                                    the writeback fan-out mutation)
#   5. Equivalence Test Suite      (equivalence/, 8 matched differential
#                                    programs against both DUTs -- Rubric §3.3)
#
# Usage:
#   ./run_all.sh [--skip-formal] [--only-anvil] [--help]
#
#   --skip-formal   Run everything except stage 2 (the SymbiYosys BMC
#                    sweep + mutant proofs are the slow part of the run).
#   --only-anvil    Run only the Anvil-side stages (3, 4, 5) -- compilation,
#                    the M-C1 mutant test, and the equivalence suite. Skips
#                    both SV stages, since none of the three needs Verilator
#                    or SymbiYosys, only iverilog and the Anvil compiler.
#   --help, -h      Show this message and exit.
#
# Requires on PATH: verilator, sby (SymbiYosys), yosys, z3 (or another
# SymbiYosys-supported engine), iverilog, python3, and an Anvil compiler
# binary (see ANVIL below). Each stage checks for its own tools and is
# skipped with a clear message if they are missing, rather than aborting
# the whole run.
#
# Env vars:
#   ANVIL   Path to the Anvil compiler binary (default: "anvil" on PATH).
#           Commit d138cab is the version this repo was tested against --
#           see README.md, "Anvil Compiler Version".

set -uo pipefail

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

ANVIL=${ANVIL:-anvil}
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_DIR="$SCRIPT_DIR/run_all_logs/$TIMESTAMP"
mkdir -p "$LOG_DIR"

RUN_SV_SIM=1
RUN_SV_FORMAL=1
RUN_ANVIL_COMPILE=1
RUN_ANVIL_MC1=1
RUN_EQUIVALENCE=1

# Results, in run order, as "stage_name:STATUS" (STATUS one of
# PASS / FAIL / SKIP). Populated by each stage function.
declare -a RESULTS=()

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------

if [[ -t 1 ]]; then
  C_BOLD=$'\033[1m'; C_GREEN=$'\033[32m'; C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'; C_RESET=$'\033[0m'
else
  C_BOLD=""; C_GREEN=""; C_RED=""; C_YELLOW=""; C_BLUE=""; C_RESET=""
fi

section() { printf "\n%s==> %s%s\n" "$C_BOLD$C_BLUE" "$1" "$C_RESET"; }
ok()      { printf "%s  [OK]%s   %s\n" "$C_GREEN" "$C_RESET" "$1"; }
fail()    { printf "%s  [FAIL]%s %s\n" "$C_RED" "$C_RESET" "$1"; }
warn()    { printf "%s  [WARN]%s %s\n" "$C_YELLOW" "$C_RESET" "$1"; }
skip()    { printf "%s  [SKIP]%s %s\n" "$C_YELLOW" "$C_RESET" "$1"; }

need_tool() {
  # need_tool <tool> <stage-name> -- returns 1 (and prints a SKIP) if
  # <tool> is not on PATH.
  if ! command -v "$1" >/dev/null 2>&1; then
    skip "$2: '$1' not found on PATH"
    return 1
  fi
  return 0
}

record() { RESULTS+=("$1:$2"); }

# ---------------------------------------------------------------------------
# --help
# ---------------------------------------------------------------------------

print_help() {
  sed -n '2,35p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

# ---------------------------------------------------------------------------
# Arg parsing
# ---------------------------------------------------------------------------

for arg in "$@"; do
  case "$arg" in
    --skip-formal) RUN_SV_FORMAL=0 ;;
    --only-anvil)  RUN_SV_SIM=0; RUN_SV_FORMAL=0 ;;  # stages 3/4/5 stay on
    --help|-h)     print_help; exit 0 ;;
    *)
      echo "Unknown option: $arg" >&2
      echo "Run './run_all.sh --help' for usage." >&2
      exit 2
      ;;
  esac
done

# ---------------------------------------------------------------------------
# Stage 1 -- SV Baseline Simulation (Verilator)
# ---------------------------------------------------------------------------

stage_sv_sim() {
  section "Stage 1: SV Baseline Simulation (sv_baseline, Verilator)"

  if ! need_tool verilator "SV Baseline Simulation"; then
    record "SV Baseline Simulation" "SKIP"; return
  fi
  if [[ ! -d sv_baseline ]]; then
    fail "sv_baseline/ not found"
    record "SV Baseline Simulation" "FAIL"; return
  fi

  local log="$LOG_DIR/01_sv_sim.log"
  local stage_ok=1

  (
    cd sv_baseline
    FILES="mips_pkg.sv instruction_fetch.sv instruction_decode.sv register_file.sv \
           forwarding_unit.sv data_memory.sv mips_pipeline_processor.sv \
           mips_sva_vlt.sv tb_mips_pipeline_processor.sv"

    echo "--- fixed-latency memory (LATENCY=1, RANDOMISE=0): the pre-backpressure baseline ---"
    verilator --binary --timing --assert -Wno-fatal -o sim -GDMEM_LATENCY=1 -GDMEM_RANDOMISE=0 $FILES \
      && ./obj_dir/sim

    echo ""
    echo "--- randomised memory (LATENCY=3, RANDOMISE=1): backpressure exercised ---"
    verilator --binary --timing --assert -Wno-fatal -o sim -GDMEM_LATENCY=3 -GDMEM_RANDOMISE=1 $FILES \
      && ./obj_dir/sim
  ) 2>&1 | tee "$log"

  if [[ ${PIPESTATUS[0]} -ne 0 ]]; then stage_ok=0; fi
  if ! grep -q "SCOREBOARD: PASS" "$log"; then stage_ok=0; fi
  if grep -q "SCOREBOARD: FAIL" "$log"; then stage_ok=0; fi

  if [[ $stage_ok -eq 1 ]]; then
    ok "Both configurations report SCOREBOARD: PASS (log: $log)"
    record "SV Baseline Simulation" "PASS"
  else
    fail "See $log"
    record "SV Baseline Simulation" "FAIL"
  fi
}

# ---------------------------------------------------------------------------
# Stage 2 -- SV Formal Verification (SymbiYosys / btormc)
# ---------------------------------------------------------------------------

stage_sv_formal() {
  section "Stage 2: SV Formal Verification (sv_baseline/formal, SymbiYosys/btormc)"

  local missing=0
  need_tool sby "SV Formal Verification" || missing=1
  need_tool yosys "SV Formal Verification" || missing=1
  need_tool python3 "SV Formal Verification" || missing=1
  if [[ $missing -eq 1 ]]; then
    record "SV Formal Verification" "SKIP"; return
  fi
  if [[ ! -d sv_baseline/formal ]]; then
    fail "sv_baseline/formal/ not found"
    record "SV Formal Verification" "FAIL"; return
  fi

  local log="$LOG_DIR/02_sv_formal.log"
  local stage_ok=1

  (
    cd sv_baseline/formal
    echo "--- symbolic-program, free-ready model (BMC depth 14, all properties) ---"
    python3 mk_bp_formal.py .. f_sym.sv --free-imem --free-ready \
      && python3 run_sweep.py 14 f_sym.sv

    echo ""
    echo "--- M25 / M26 mutants against the same formal harness ---"
    python3 mut_formal.py
  ) 2>&1 | tee "$log"

  if [[ ${PIPESTATUS[0]} -ne 0 ]]; then stage_ok=0; fi
  grep -q "PASS at depth 14" "$log" || { warn "did not see 'PASS at depth 14' -- check masked-property list in $log"; }
  grep -qE "M25-bubble-memwb\s+CAUGHT" "$log" || stage_ok=0
  grep -qE "M26-stall-is-not-ready\s+CAUGHT" "$log" || stage_ok=0

  if [[ $stage_ok -eq 1 ]]; then
    ok "M25 and M26 both CAUGHT by the formal harness (log: $log)"
    record "SV Formal Verification" "PASS"
  else
    fail "See $log -- expected both M25-bubble-memwb and M26-stall-is-not-ready to be CAUGHT"
    record "SV Formal Verification" "FAIL"
  fi
}

# ---------------------------------------------------------------------------
# Stage 3 -- Anvil Compilation (port2_static_baseline)
# ---------------------------------------------------------------------------

stage_anvil_compile() {
  section "Stage 3: Anvil Compilation (port2_static_baseline, static @#1-@#1 contracts)"

  local missing=0
  need_tool "$ANVIL" "Anvil Compilation" || missing=1
  need_tool iverilog "Anvil Compilation" || missing=1
  if [[ $missing -eq 1 ]]; then
    record "Anvil Compilation" "SKIP"; return
  fi
  if [[ ! -d port2_static_baseline ]]; then
    fail "port2_static_baseline/ not found"
    record "Anvil Compilation" "FAIL"; return
  fi

  local log="$LOG_DIR/03_anvil_compile.log"
  local stage_ok=1

  (
    cd port2_static_baseline
    echo "--- compiling with every lifetime/borrow check on (no -disable-lt-checks) ---"
    "$ANVIL" top.anv > mips_anvil_pipelined.sv \
      && echo "compiled: $(wc -l < mips_anvil_pipelined.sv) lines of RTL" \
      && iverilog -g2012 -o sim.vvp mips_anvil_pipelined.sv tb_mips_pipelined.sv \
      && ./sim.vvp
  ) 2>&1 | tee "$log"

  if [[ ${PIPESTATUS[0]} -ne 0 ]]; then stage_ok=0; fi

  local final_line
  final_line="$(grep "^FINAL" "$log" || true)"
  if [[ -z "$final_line" ]]; then
    stage_ok=0
  else
    # Expected architectural end state for the 7-instruction program:
    # r1=20 r2=0 r3=0 r4=20 r0=0 dmem5w=20
    echo "$final_line" | grep -qE "r1=20 r2=0 r3=0 r4=20 r5=[0-9]+ r0=0 dmem5w=20" || stage_ok=0
  fi

  if [[ $stage_ok -eq 1 ]]; then
    ok "success: true, end state matches the SV baseline (log: $log)"
    record "Anvil Compilation" "PASS"
  else
    fail "See $log"
    record "Anvil Compilation" "FAIL"
  fi
}

# ---------------------------------------------------------------------------
# Stage 4 -- Anvil M-C1 mutant (writeback fan-out)
# ---------------------------------------------------------------------------

stage_anvil_mc1() {
  section "Stage 4: Anvil M-C1 mutant (writeback.anv fan-out, mutation_testing/M_C1_fanout)"

  local missing=0
  need_tool "$ANVIL" "Anvil M-C1 mutant" || missing=1
  need_tool iverilog "Anvil M-C1 mutant" || missing=1
  if [[ $missing -eq 1 ]]; then
    record "Anvil M-C1 mutant" "SKIP"; return
  fi
  if [[ ! -d port2_static_baseline || ! -f mutation_testing/M_C1_fanout/tb_c1_checker.sv ]]; then
    fail "port2_static_baseline/ or mutation_testing/M_C1_fanout/tb_c1_checker.sv not found"
    record "Anvil M-C1 mutant" "FAIL"; return
  fi

  local log="$LOG_DIR/04_anvil_mc1.log"
  local stage_ok=1
  local WORKDIR
  WORKDIR="$(mktemp -d)"
  trap '[[ -n "${WORKDIR:-}" ]] && rm -rf "$WORKDIR"' RETURN

  cp -r port2_static_baseline "$WORKDIR/baseline"
  cp -r port2_static_baseline "$WORKDIR/mut"
  cp mutation_testing/M_C1_fanout/tb_c1_checker.sv "$WORKDIR/baseline/"
  cp mutation_testing/M_C1_fanout/tb_c1_checker.sv "$WORKDIR/mut/"

  # The mutation: writeback.anv line 24, wb_ex's payload field changed
  # from the muxed write-back value `wd` to the raw pre-mux `*mw_alu`.
  sed -i '24s/write_data = wd;/write_data = *mw_alu;/' "$WORKDIR/mut/writeback.anv"

  (
    echo "--- baseline: expect C1 fired 0 times, scoreboard: PASS ---"
    cd "$WORKDIR/baseline"
    "$ANVIL" top.anv > baseline.sv \
      && iverilog -g2012 -o b.vvp baseline.sv tb_c1_checker.sv \
      && ./b.vvp

    echo ""
    echo "--- mutant: expect C1 VIOLATION, C1 fired 1 times, scoreboard: FAIL ---"
    cd "$WORKDIR/mut"
    "$ANVIL" top.anv > mut.sv \
      && echo "mutant compiled: success (this is the point -- Anvil accepts it)" \
      && iverilog -g2012 -o m.vvp mut.sv tb_c1_checker.sv \
      && ./m.vvp
  ) 2>&1 | tee "$log"

  if [[ ${PIPESTATUS[0]} -ne 0 ]]; then stage_ok=0; fi

  # Split the log at the mutant marker so baseline/mutant checks don't
  # cross-match each other's expected strings.
  local split_line
  split_line="$(grep -n "^--- mutant:" "$log" | head -1 | cut -d: -f1)"
  local baseline_part mutant_part
  if [[ -n "$split_line" ]]; then
    baseline_part="$(head -n "$split_line" "$log")"
    mutant_part="$(tail -n "+$split_line" "$log")"
  else
    baseline_part=""; mutant_part=""
    stage_ok=0
  fi

  echo "$baseline_part" | grep -q "C1 fired 0 times" || stage_ok=0
  echo "$baseline_part" | grep -q "scoreboard: PASS" || stage_ok=0
  echo "$mutant_part"   | grep -q "C1 fired 1 times" || stage_ok=0
  echo "$mutant_part"   | grep -q "scoreboard: FAIL" || stage_ok=0

  if [[ $stage_ok -eq 1 ]]; then
    ok "Anvil accepts the mutant (success: true); C1 fires once and the scoreboard flips PASS->FAIL (log: $log)"
    record "Anvil M-C1 mutant" "PASS"
  else
    fail "See $log -- expected baseline PASS / mutant C1-fires-once + FAIL"
    record "Anvil M-C1 mutant" "FAIL"
  fi
}

# ---------------------------------------------------------------------------
# Stage 5 -- Equivalence Test Suite (8 matched differential programs)
# ---------------------------------------------------------------------------

stage_equivalence() {
  section "Stage 5: Equivalence Test Suite (equivalence/, 8 matched programs)"

  local missing=0
  need_tool "$ANVIL" "Equivalence Test Suite" || missing=1
  need_tool iverilog "Equivalence Test Suite" || missing=1
  need_tool python3 "Equivalence Test Suite" || missing=1
  if [[ $missing -eq 1 ]]; then
    record "Equivalence Test Suite" "SKIP"; return
  fi
  if [[ ! -f equivalence/run_equivalence.py ]]; then
    fail "equivalence/run_equivalence.py not found"
    record "Equivalence Test Suite" "FAIL"; return
  fi

  local log="$LOG_DIR/05_equivalence.log"
  local stage_ok=1

  ANVIL="$ANVIL" python3 equivalence/run_equivalence.py 2>&1 | tee "$log"
  if [[ ${PIPESTATUS[0]} -ne 0 ]]; then stage_ok=0; fi
  grep -q "ALL PROGRAMS MATCH" "$log" || stage_ok=0

  if [[ $stage_ok -eq 1 ]]; then
    ok "All 8 differential programs match on PC trace, register file, and data memory (log: $log)"
    record "Equivalence Test Suite" "PASS"
  else
    fail "See $log -- at least one program mismatched or failed to build/run"
    record "Equivalence Test Suite" "FAIL"
  fi
}

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------

echo "${C_BOLD}run_all.sh${C_RESET} -- logs in: $LOG_DIR"
[[ $RUN_SV_SIM -eq 0 ]]        && echo "  (SV Baseline Simulation skipped)"
[[ $RUN_SV_FORMAL -eq 0 ]]     && echo "  (SV Formal Verification skipped)"

[[ $RUN_SV_SIM -eq 1 ]]        && stage_sv_sim
[[ $RUN_SV_FORMAL -eq 1 ]]     && stage_sv_formal
[[ $RUN_ANVIL_COMPILE -eq 1 ]] && stage_anvil_compile
[[ $RUN_ANVIL_MC1 -eq 1 ]]     && stage_anvil_mc1
[[ $RUN_EQUIVALENCE -eq 1 ]]   && stage_equivalence

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

section "Summary"
overall=0
for entry in "${RESULTS[@]}"; do
  name="${entry%%:*}"
  status="${entry##*:}"
  case "$status" in
    PASS) printf "  %-30s %s%s%s\n" "$name" "$C_GREEN" "PASS" "$C_RESET" ;;
    FAIL) printf "  %-30s %s%s%s\n" "$name" "$C_RED" "FAIL" "$C_RESET"; overall=1 ;;
    SKIP) printf "  %-30s %s%s%s\n" "$name" "$C_YELLOW" "SKIP" "$C_RESET" ;;
  esac
done
echo ""
echo "Full logs: $LOG_DIR"

exit $overall
