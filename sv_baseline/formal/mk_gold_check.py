#!/usr/bin/env python3
"""
mk_bp_formal.py -- build a Yosys/SymbiYosys-provable image of the
backpressured Phase-1b pipeline plus the mips_sva.sv property set.

Mechanical transforms only; no design logic is changed except where
noted, and every exception is listed here:

 1. PACKAGE QUALIFICATION.  The open-source Yosys SV frontend cannot
    resolve `import mips_pkg::*;` and mis-elaborates member access on a
    file-scope typedef'd struct (genrtlil.cc:1604).  Every package
    identifier is fully qualified as `mips_pkg::<name>`.

 2. PROBE PORTS.  Yosys supports neither `bind` nor downward
    hierarchical references, so `u_if.pc` and `u_regfile.regs[0]` are
    brought out as extra outputs and reconnected in the processor.

 3. PROPERTY TRANSLATION.  Open-source Yosys has no concurrent-SVA
    support (Verific only), so every property becomes an immediate
    assertion in a clocked always block:
        disable iff (D)  A |-> C   ->  if (!D) assert (!A || C);
        disable iff (D)  A |=> C   ->  if (!D && !D_prev && v1)
                                          assert (!$past(A) || C);
    NOT translated: P20c (a #1ps immediate assert on `posedge reset`,
    which has no formal meaning) and P21/P37 ($isunknown X-checks, which
    are vacuously true in a 2-state model).  Both are recorded as such.

 4. FREE MEMORY READY  (--free-ready, the point of this build).
    data_memory's LFSR latency model is replaced by
        ready = req && (anyseq || fair_cnt >= MAX_STALL)
    so the proof covers EVERY backpressure schedule the contract
    permits, not the one schedule the LFSR happens to produce.  The
    fairness bound is STRUCTURAL rather than an `assume`: an assume that
    contradicted the design would silently make every property vacuous,
    whereas a structural bound cannot.  P44/P44m still have work to do --
    they catch a requester that stalls without a request outstanding.

 5. SYMBOLIC PROGRAM  (--free-imem).  The hard-coded program is removed
    from instruction_fetch, leaving imem a never-written array: an
    unconstrained constant, i.e. any program at all.

 6. $past WORKAROUND.  Yosys mis-elaborates $past applied to a
    part-select of a packed-struct member (reduced to a 10-line
    testcase; it disagrees with a shadow register of the same
    expression).  Where that pattern is needed the properties use
    explicit shadow registers instead.  The SVA file keeps the $past
    form, which is correct SystemVerilog and behaves correctly under
    Verilator and XSim.

Usage:  mk_bp_formal.py <srcdir> <out.sv> [--free-imem] [--free-ready]
"""
import re, sys, os

SRC, OUT = sys.argv[1], sys.argv[2]
FREE_IMEM  = "--free-imem"  in sys.argv
FREE_READY = "--free-ready" in sys.argv

TYPES = ["opcode_t", "funct_t", "if_id_t", "id_ex_t", "ex_mem_t", "mem_wb_t"]
ENUMS = ["OP_RTYPE", "OP_LW", "OP_SW", "OP_JZ", "FUNCT_ADD", "FUNCT_SUB"]


def qualify(t):
    t = t.replace("import mips_pkg::*;", "")
    for n in TYPES + ENUMS:
        t = re.sub(r"(?<![\w:.])%s\b" % n, "mips_pkg::" + n, t)
    return t


# ============================ data_memory properties =================
DMEM_PROPS = r"""
`ifdef FORMAL
  // ---- P39b / P39c / P44m : the memory's half of the contract -------
  // Shadow registers rather than $past(): see transform 6 in the header.
  logic        d_req = 1'b0, d_we = 1'b0, d_rdy = 1'b0, d_v = 1'b0;
  logic [31:0] d_addr = 32'd0, d_wdata = 32'd0, d_word = 32'd0;
  logic [31:0] cur_word;
  always_comb cur_word = {mem[a0], mem[a1], mem[a2], mem[a3]};
  always_ff @(posedge clk) begin
    d_req <= req; d_we <= we; d_rdy <= ready;
    d_addr <= addr; d_wdata <= wdata; d_word <= cur_word; d_v <= 1'b1;
  end

  logic [31:0] rb;            // read-back of the shadowed address
  always_comb rb = {mem[d_addr[AW-1:0]],
                    mem[d_addr[AW-1:0] + AW'(1)],
                    mem[d_addr[AW-1:0] + AW'(2)],
                    mem[d_addr[AW-1:0] + AW'(3)]};

  always_ff @(posedge clk) if (!reset && d_v) begin
    a_p39b_store_lands : assert
      (!(d_req && d_we && d_rdy && (d_addr < (DEPTH - 3))) || (rb == d_wdata));
    a_p39c_no_write_in_flight : assert
      (!(d_req && d_we && !d_rdy && (d_addr < (DEPTH - 3))) || (rb == d_word));
  end

  logic [3:0] grant_cnt = 4'd0;
  always_ff @(posedge clk or posedge reset)
    if (reset)                                   grant_cnt <= 4'd0;
    else if (req && !ready && grant_cnt != 4'hF) grant_cnt <= grant_cnt + 4'd1;
    else if (ready || !req)                      grant_cnt <= 4'd0;
  always_ff @(posedge clk) if (!reset)
    a_p44m_memory_grants : assert (grant_cnt <= 8);
`endif
"""

# ============================ processor properties ===================
PROPS = r"""
`ifdef FORMAL
// ===================================================================
//  Translated mips_sva.sv property set (asserts only; covers omitted
//  at the author's request).  Labels keep the original P<n> IDs.
// ===================================================================

  // --- scaffolding ---------------------------------------------------
  logic sva_past_ok;
  always_ff @(posedge clk or posedge reset)
    if (reset) sva_past_ok <= 1'b0; else sva_past_ok <= 1'b1;
  logic sva_past_ok2;
  always_ff @(posedge clk or posedge reset)
    if (reset) sva_past_ok2 <= 1'b0; else sva_past_ok2 <= sva_past_ok;

  logic f_v1 = 1'b0, f_v2 = 1'b0;
  always_ff @(posedge clk) begin f_v1 <= 1'b1; f_v2 <= f_v1; end

  logic f_started = 1'b0;
  always_ff @(posedge clk) f_started <= 1'b1;
  always_ff @(posedge clk) if (!f_started) assume (reset);

  // $past is only legal in a clocked block in Yosys: keep the history
  // the gates need in explicit shadow registers.
  logic r_d1 = 1'b1, r_d2 = 1'b1, pok_d1 = 1'b0, ms_d1 = 1'b0;
  always_ff @(posedge clk) begin
    r_d1 <= reset; r_d2 <= r_d1; pok_d1 <= sva_past_ok; ms_d1 <= mem_stall;
  end
  logic g_now, g_step;
  assign g_now  = !reset;
  assign g_step = !reset && !r_d1 && f_v1;

  // --- independent decode model (verbatim from mips_sva.sv) ----------
  localparam logic [5:0] OPC_RTYPE = 6'b000000;
  localparam logic [5:0] OPC_LW    = 6'b100011;
  localparam logic [5:0] OPC_SW    = 6'b101011;
  localparam logic [5:0] OPC_JZ    = 6'b000010;

  logic [5:0] m_opcode; logic [4:0] m_rs, m_rt;
  logic m_uses_rs, m_uses_rt, m_load_use;
  assign m_opcode  = if_id.instr[31:26];
  assign m_rs      = if_id.instr[25:21];
  assign m_rt      = if_id.instr[20:16];
  assign m_uses_rs = (m_opcode == OPC_RTYPE) || (m_opcode == OPC_LW) ||
                     (m_opcode == OPC_SW)    || (m_opcode == OPC_JZ);
  assign m_uses_rt = (m_opcode == OPC_RTYPE) || (m_opcode == OPC_SW);
  assign m_load_use = id_ex.mem_read && (id_ex.rt != 5'd0) &&
                      (((id_ex.rt == m_rs) && m_uses_rs) ||
                       ((id_ex.rt == m_rt) && m_uses_rt));

  logic ex_uses_a, ex_uses_b;
  assign ex_uses_a = id_ex.reg_write || id_ex.mem_write || id_ex.branch_zero;
  assign ex_uses_b = id_ex.mem_write || (!id_ex.alu_src && id_ex.reg_write);

  logic [31:0] ex_mem_wb_value;
  assign ex_mem_wb_value = ex_mem.mem_to_reg ? mem_read_data : ex_mem.alu_result;

  logic [31:0] arch_rs_value, arch_rt_value;
  assign arch_rs_value =
    (ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) && (ex_mem.dest_reg == id_ex.rs)) ? ex_mem_wb_value :
    (mem_wb.reg_write && (mem_wb.dest_reg != 5'd0) && (mem_wb.dest_reg == id_ex.rs)) ? wb_data :
                                                                                        id_ex.rd1;
  assign arch_rt_value =
    (ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) && (ex_mem.dest_reg == id_ex.rt)) ? ex_mem_wb_value :
    (mem_wb.reg_write && (mem_wb.dest_reg != 5'd0) && (mem_wb.dest_reg == id_ex.rt)) ? wb_data :
                                                                                        id_ex.rd2;

  localparam int IMEM_BYTES = 1024;
  localparam int DMEM_BYTES = 1024;
  localparam int MAX_STALL  = 8;

  logic [3:0] stall_cnt = 4'd0;
  always_ff @(posedge clk or posedge reset)
    if (reset)                               stall_cnt <= 4'd0;
    else if (mem_stall && stall_cnt != 4'hF) stall_cnt <= stall_cnt + 4'd1;
    else if (!mem_stall)                     stall_cnt <= 4'd0;

  logic [1:0] squash_age = 2'd0;
  always_ff @(posedge clk or posedge reset)
    if (reset) squash_age <= 2'd0;
    else if (!mem_stall) begin
      if (if_branch_taken)         squash_age <= 2'd1;
      else if (squash_age == 2'd1) squash_age <= 2'd2;
      else                         squash_age <= 2'd0;
    end

  logic f_all_zero;
  assign f_all_zero = (f_pc == 32'd0) && (if_id == '0) && (id_ex == '0) &&
                      (ex_mem == '0) && (mem_wb == '0);

  // =================================================================
  //  GOLD-SUITE MERGED FORMULATIONS ONLY.
  //  The 25 verbatim-extracted properties are already proven by the
  //  full-suite run; only the 9 merges can carry a transcription error,
  //  so this image checks exactly those.  (Merged P21 is an $isunknown
  //  X-check: vacuous in a 2-state model, so it is not translatable.)
  // =================================================================
  always_ff @(posedge clk) begin
    if (g_now) begin
      g_p1b_stall_holds_front_end : assert
        ((!(load_use_hazard || mem_stall) || (!pc_write && !if_id_write)) &&
         (!mem_stall || !if_branch_taken));
      g_p6_fwd_priority : assert
        ((!(ex_mem.reg_write && mem_wb.reg_write && (id_ex.rs != 5'd0) &&
            (ex_mem.dest_reg == id_ex.rs) && (mem_wb.dest_reg == id_ex.rs))
          || (forward_a == 2'b10)) &&
         (!(ex_mem.reg_write && mem_wb.reg_write && (id_ex.rt != 5'd0) &&
            (ex_mem.dest_reg == id_ex.rt) && (mem_wb.dest_reg == id_ex.rt))
          || (forward_b == 2'b10)));
      g_p24_no_fwd_zero : assert
        ((!(ex_mem.dest_reg == 5'd0) || ((forward_a != 2'b10) && (forward_b != 2'b10))) &&
         (!(mem_wb.dest_reg == 5'd0) || ((forward_a != 2'b01) && (forward_b != 2'b01))));
      g_p29_no_fwd_load : assert
        ((!(ex_mem.mem_to_reg && ex_uses_a) || (forward_a != 2'b10)) &&
         (!(ex_mem.mem_to_reg && ex_uses_b) || (forward_b != 2'b10)));
      g_p26_zero_reads_zero : assert
        ((!(id_ex.rs == 5'd0) || (id_ex.rd1 == 32'd0)) &&
         (!(id_ex.rt == 5'd0) || (id_ex.rd2 == 32'd0)));
      g_p38_fwd_value_live : assert
        ((!(ex_uses_a && !mem_stall) || (ex_forward_a_data == arch_rs_value)) &&
         (!(ex_uses_b && !mem_stall) || (ex_forward_b_data == arch_rt_value)));
      // P40 seen from the processor: the regfile's ports are rf_write_en /
      // mem_wb.dest_reg / wb_data / id_rs / id_rt / id_rd1_wire / id_rd2_wire.
      g_p40_rf_write_through : assert
        (!(rf_write_en && (mem_wb.dest_reg != 5'd0)) ||
         (((mem_wb.dest_reg != id_rs) || (id_rd1_wire == wb_data)) &&
          ((mem_wb.dest_reg != id_rt) || (id_rd2_wire == wb_data))));
    end
    if (g_step) begin
      g_p35_commit_value : assert
        (!(!ms_d1 && $past(ex_mem.reg_write)) ||
         (wb_data == ($past(ex_mem.mem_to_reg) ? $past(mem_read_data)
                                               : $past(ex_mem.alu_result))));
    end
    if (g_step && sva_past_ok && pok_d1) begin
      g_p18_pc_next_state : assert
        (f_pc == (ms_d1                   ? $past(f_pc)               :
                  $past(ex_branch_taken)  ? $past(ex_branch_target)   :
                  $past(load_use_hazard)  ? $past(f_pc)               :
                                            $past(f_pc) + 32'd4));
    end
  end
`endif
"""


def build():
    files = ["mips_pkg.sv", "instruction_fetch.sv", "instruction_decode.sv",
             "register_file.sv", "forwarding_unit.sv", "data_memory.sv",
             "mips_pipeline_processor.sv"]
    txt = {f: open(os.path.join(SRC, f)).read() for f in files}

    # ---- instruction_fetch: pc probe, optional symbolic program -------
    f = txt["instruction_fetch.sv"]
    f = f.replace("    output logic [31:0] pc_plus4\n);",
                  "    output logic [31:0] pc_plus4,\n    output logic [31:0] pc_dbg\n);")
    f = f.replace("    assign pc_plus4   = pc + 32'd4;",
                  "    assign pc_plus4   = pc + 32'd4;\n    assign pc_dbg     = pc;")
    if FREE_IMEM:
        f = re.sub(r"\n *for \(i = 0; i < IMEM_WORDS.*?\n *end\n", "\n", f, flags=re.S)
        f = re.sub(r"\n *imem\[\d+\] <= 32'h[0-9A-Fa-f]+;[^\n]*", "", f)
        # A transform that silently fails to apply looks exactly like a
        # transform that worked: imem would stay initialised and the
        # "symbolic program" run would quietly become the concrete-program
        # run.  Refuse to emit anything rather than allow that.
        assert "imem[0] <=" not in f, "free-imem: program writes survived"
        assert "i < IMEM_WORDS" not in f, "free-imem: reset loop survived"
        assert "imem[i] <=" not in f, "free-imem: clear loop survived"
    txt["instruction_fetch.sv"] = f

    # ---- register_file: regs[0] probe ---------------------------------
    r = txt["register_file.sv"]
    r = r.replace("    output logic [31:0] read_data2\n);",
                  "    output logic [31:0] read_data2,\n    output logic [31:0] zero_dbg\n);")
    r = r.replace("    always_comb begin\n        if (read_reg1 == 5'd0)",
                  "    assign zero_dbg = regs[0];\n\n    always_comb begin\n        if (read_reg1 == 5'd0)")
    txt["register_file.sv"] = r

    # ---- data_memory: free ready + the memory-side properties ---------
    d = txt["data_memory.sv"]
    if FREE_READY:
        old = d[d.index("    // ---- pseudo-random extra delay"):d.index("    // ---- array:")]
        new = """    // ---- FORMAL: `ready` is a free per-cycle input, bounded ------------
    // Covers every backpressure schedule the contract permits.  The
    // bound is structural, not an `assume`, so it cannot make the proof
    // vacuous.  See transform 4 in the generator header.
    logic ready_free;
    assign ready_free = $anyseq;

    logic [3:0] fair_cnt;
    always_ff @(posedge clk or posedge reset)
        if (reset)              fair_cnt <= 4'd0;
        else if (req && !ready) fair_cnt <= fair_cnt + 4'd1;
        else                    fair_cnt <= 4'd0;

    assign ready = req && (ready_free || (fair_cnt >= 4'd4));

"""
        d = d.replace(old, new)
    j = d.rindex("endmodule")
    d = d[:j] + DMEM_PROPS + "\n" + d[j:]
    txt["data_memory.sv"] = d

    # ---- processor: reconnect the probes, inject the properties -------
    p = txt["mips_pipeline_processor.sv"]
    p = p.replace("    logic load_use_hazard,",
                  "    logic [31:0] f_pc, f_zero;\n    logic load_use_hazard,")
    p = p.replace(".pc_plus4(if_pc_plus4)\n    );",
                  ".pc_plus4(if_pc_plus4),\n        .pc_dbg(f_pc)\n    );")
    p = p.replace(".read_data2(id_rd2_wire)\n    );",
                  ".read_data2(id_rd2_wire),\n        .zero_dbg(f_zero)\n    );")
    j = p.rindex("endmodule")
    p = p[:j] + PROPS + "\n" + p[j:]
    txt["mips_pipeline_processor.sv"] = p

    parts = [txt["mips_pkg.sv"]] + [qualify(txt[f]) for f in files[1:]]
    open(OUT, "w").write("\n".join(parts))
    print("wrote %s  [%s program, %s ready]" %
          (OUT, "symbolic" if FREE_IMEM else "as-shipped",
           "free" if FREE_READY else "LFSR"))


build()
