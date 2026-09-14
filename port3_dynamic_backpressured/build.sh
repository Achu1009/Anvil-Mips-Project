#!/usr/bin/env bash
# Phase 2 build + regression.  ANVIL points at the compiler binary.
set -e
ANVIL=${ANVIL:-anvil}

# The lifetime checker rejects three of the five stages; see README.md,
# "What Anvil would not let us write".  -disable-lt-checks turns off the
# lifetime pass only; codegen (including the handshake generation) is
# unaffected.
"$ANVIL" -disable-lt-checks top.anv > mips_anvil_bp.sv

# Fixed-latency variant: flip the one knob in data_memory.anv.
tmp=$(mktemp -d); cp *.anv "$tmp/"
sed -i "s|func extra_latency(f) { f\[0+:2\] }|func extra_latency(f) { 2'd0 }|" "$tmp/data_memory.anv"
( cd "$tmp" && "$ANVIL" -disable-lt-checks top.anv ) > mips_anvil_bp_fixed.sv
rm -rf "$tmp"

iverilog -g2012 -o sim_rand.vvp  mips_anvil_bp.sv       tb_mips_bp.sv && ./sim_rand.vvp  | tail -3
iverilog -g2012 -o sim_fixed.vvp mips_anvil_bp_fixed.sv tb_mips_bp.sv && ./sim_fixed.vvp | tail -3
iverilog -g2012 -o trace.vvp     mips_anvil_bp.sv       tb_trace.sv   && ./trace.vvp
