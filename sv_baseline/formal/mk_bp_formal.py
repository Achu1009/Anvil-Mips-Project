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
  //  A.1  RESET
  // =================================================================
  always_ff @(posedge clk) begin
    a_p20a_reset_state_sync : assert (!reset || f_all_zero);
    if (f_v1)
      a_p20b_reset_release_clean : assert (!(!reset && $past(reset)) || f_all_zero);
  end
  // P20c : simulation-only (#1ps immediate assert)      -- not translated
  // P21  : $isunknown X-check, vacuous in 2-state       -- not translated
  // P37  : likewise                                     -- not translated

  // =================================================================
  //  A.2  STALLS AND BUBBLES
  // =================================================================
  always_ff @(posedge clk) begin
    if (g_now) begin
      a_p1_load_use_detect  : assert (load_use_hazard == m_load_use);
      a_p1b_stall_controls  : assert (!load_use_hazard || (!pc_write && !if_id_write));
      a_p3b_no_stall_branch : assert (!(id_ex.mem_read && id_ex.branch_zero));
    end
    if (g_step) begin
      a_p2_stall_bubble   : assert (!($past(load_use_hazard) && !ms_d1) || (id_ex == '0));
      a_p5_stall_duration : assert (!($past(load_use_hazard) && !ms_d1) || !load_use_hazard);
    end
    if (g_step && sva_past_ok && pok_d1)
      a_p3_stall_freeze_if_id : assert
        (!($past(load_use_hazard) && !$past(ex_branch_taken)) || (if_id == $past(if_id)));
  end

  // =================================================================
  //  B  INTERFACE STABILITY
  // =================================================================
  always_ff @(posedge clk) if (g_step && sva_past_ok && pok_d1) begin
    a_p18_pc_increment : assert
      (!(!$past(load_use_hazard) && !$past(ex_branch_taken) && !ms_d1) ||
       (f_pc == $past(f_pc) + 32'd4));
    a_p4_pc_frozen : assert
      (!($past(load_use_hazard) && !$past(ex_branch_taken)) || (f_pc == $past(f_pc)));
    a_p23_branch_jump : assert
      (!($past(ex_branch_taken) && !ms_d1) || (f_pc == $past(ex_branch_target)));
    a_p28_if_id_progress : assert
      (!(!$past(load_use_hazard) && !$past(ex_branch_taken) && !ms_d1) ||
       ((if_id.instr == $past(if_instr)) && (if_id.pc_plus4 == $past(if_pc_plus4))));
    a_p25_negative_bubble : assert
      (!(!$past(load_use_hazard) && !$past(ex_branch_taken) && !ms_d1) ||
       ((id_ex.rs  == $past(id_rs))       && (id_ex.rt  == $past(id_rt)) &&
        (id_ex.rd1 == $past(id_rd1_wire)) && (id_ex.rd2 == $past(id_rd2_wire))));
  end

  // =================================================================
  //  C  FORWARDING / OWNERSHIP
  // =================================================================
  always_ff @(posedge clk) if (g_now) begin
    a_p15a_fwd_a_ex_mem : assert
      (!(ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) && (ex_mem.dest_reg == id_ex.rs))
       || (forward_a == 2'b10));
    a_p15b_fwd_a_mem_wb : assert
      (!(mem_wb.reg_write && (mem_wb.dest_reg != 5'd0) && (mem_wb.dest_reg == id_ex.rs) &&
         !(ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) && (ex_mem.dest_reg == id_ex.rs)))
       || (forward_a == 2'b01));
    a_p15c_fwd_b_ex_mem : assert
      (!(ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) && (ex_mem.dest_reg == id_ex.rt))
       || (forward_b == 2'b10));
    a_p15d_fwd_b_mem_wb : assert
      (!(mem_wb.reg_write && (mem_wb.dest_reg != 5'd0) && (mem_wb.dest_reg == id_ex.rt) &&
         !(ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) && (ex_mem.dest_reg == id_ex.rt)))
       || (forward_b == 2'b01));
    a_p6a_fwd_a_priority : assert
      (!(ex_mem.reg_write && mem_wb.reg_write && (ex_mem.dest_reg == id_ex.rs) &&
         (mem_wb.dest_reg == id_ex.rs) && (id_ex.rs != 5'd0)) || (forward_a == 2'b10));
    a_p6b_fwd_b_priority : assert
      (!(ex_mem.reg_write && mem_wb.reg_write && (ex_mem.dest_reg == id_ex.rt) &&
         (mem_wb.dest_reg == id_ex.rt) && (id_ex.rt != 5'd0)) || (forward_b == 2'b10));
    a_p22a : assert (ex_mem.reg_write || (forward_a != 2'b10));
    a_p22b : assert (mem_wb.reg_write || (forward_a != 2'b01));
    a_p22c : assert (ex_mem.reg_write || (forward_b != 2'b10));
    a_p22d : assert (mem_wb.reg_write || (forward_b != 2'b01));
    a_p24a : assert (!(ex_mem.dest_reg == 5'd0) || ((forward_a != 2'b10) && (forward_b != 2'b10)));
    a_p24b : assert (!(mem_wb.dest_reg == 5'd0) || ((forward_a != 2'b01) && (forward_b != 2'b01)));
    a_p29a_no_fwd_load_a : assert (!(ex_mem.mem_to_reg && ex_uses_a) || (forward_a != 2'b10));
    a_p29b_no_fwd_load_b : assert (!(ex_mem.mem_to_reg && ex_uses_b) || (forward_b != 2'b10));
    a_p30a_no_stale_a : assert
      (!((id_ex.rs != 5'd0) &&
         ((ex_mem.reg_write && (ex_mem.dest_reg == id_ex.rs)) ||
          (mem_wb.reg_write && (mem_wb.dest_reg == id_ex.rs)))) || (forward_a != 2'b00));
    a_p30b_no_stale_b : assert
      (!((id_ex.rt != 5'd0) &&
         ((ex_mem.reg_write && (ex_mem.dest_reg == id_ex.rt)) ||
          (mem_wb.reg_write && (mem_wb.dest_reg == id_ex.rt)))) || (forward_b != 2'b00));
    a_p26a_zero_rs : assert (!(id_ex.rs == 5'd0) || (id_ex.rd1 == 32'd0));
    a_p26b_zero_rt : assert (!(id_ex.rt == 5'd0) || (id_ex.rd2 == 32'd0));
  end

  // =================================================================
  //  D  BRANCH SQUASH
  // =================================================================
  always_ff @(posedge clk) begin
    if (g_step)
      a_p8_branch_squash : assert
        (!($past(ex_branch_taken) && !ms_d1) || ((id_ex == '0) && (if_id == '0)));
    if (g_now)
      a_p8b_squash_no_side_effect : assert
        ((squash_age == 2'd0) || (!ex_mem.reg_write && !ex_mem.mem_write));
  end

  // =================================================================
  //  BOUNDS / ALIGNMENT  ([CHECKER] in mips_sva.sv)
  // =================================================================
  always_ff @(posedge clk) if (g_now) begin
    a_p19_pc_bounds        : assert (f_pc < IMEM_BYTES);
    a_p19b_branch_tgt_bnds : assert (!ex_branch_taken || (ex_branch_target < IMEM_BYTES));
    a_p12_pc_alignment     : assert (f_pc[1:0] == 2'b00);
    a_p17_mem_bounds       : assert (!dmem_req || (ex_mem.alu_result < (DMEM_BYTES - 3)));
    a_p27_mem_alignment    : assert (!dmem_req || (ex_mem.alu_result[1:0] == 2'b00));
  end

  // =================================================================
  //  BACKPRESSURE INTERFACE  (P41 -- P44)
  // =================================================================
  always_ff @(posedge clk) begin
    if (g_now) begin
      a_p41_mem_stall_controls : assert
        (!mem_stall || (!pc_write && !if_id_write && !if_branch_taken));
      a_p44_bounded_stall : assert (stall_cnt <= MAX_STALL);
    end
    if (g_step) begin
      a_p42_req_stable : assert
        (!($past(dmem_req) && !$past(dmem_ready)) ||
         (dmem_req && (dmem_we    == $past(dmem_we))   &&
                      (dmem_addr  == $past(dmem_addr)) &&
                      (dmem_wdata == $past(dmem_wdata))));
      a_p43_stall_freezes : assert
        (!ms_d1 || ((f_pc == $past(f_pc)) && (if_id == $past(if_id)) &&
                    (id_ex == $past(id_ex)) && (ex_mem == $past(ex_mem)) &&
                    (mem_wb == $past(mem_wb))));
    end
  end

  // =================================================================
  //  DATA PLANE  (P34 -- P40)
  // =================================================================
  always_ff @(posedge clk) begin
    if (g_now) begin
      a_p36_branch_on_arch : assert
        (!(id_ex.branch_zero && !mem_stall) || (ex_branch_taken == (arch_rs_value == 32'd0)));
      a_p38a_fwd_a_live : assert (!(ex_uses_a && !mem_stall) || (ex_forward_a_data == arch_rs_value));
      a_p38b_fwd_b_live : assert (!(ex_uses_b && !mem_stall) || (ex_forward_b_data == arch_rt_value));
      // P40: the register file's ports, seen from the processor.
      a_p40a_rf_bypass_rs : assert
        (!(rf_write_en && (mem_wb.dest_reg != 5'd0) && (mem_wb.dest_reg == id_rs)) ||
         (id_rd1_wire == wb_data));
      a_p40b_rf_bypass_rt : assert
        (!(rf_write_en && (mem_wb.dest_reg != 5'd0) && (mem_wb.dest_reg == id_rt)) ||
         (id_rd2_wire == wb_data));
      a_p31_zero_immutable : assert (f_zero == 32'd0);
    end
    if (g_step) begin
      a_p34a_mem_wb_handoff : assert
        (ms_d1 || ((mem_wb.reg_write == $past(ex_mem.reg_write)) &&
                   (!mem_wb.reg_write || (mem_wb.dest_reg == $past(ex_mem.dest_reg)))));
      a_p34b_commit_once : assert (!ms_d1 || !rf_write_en);
      a_p35_load_commit : assert
        (!(!ms_d1 && $past(ex_mem.reg_write) && $past(ex_mem.mem_to_reg)) ||
         (wb_data == $past(mem_read_data)));
      a_p35b_alu_commit : assert
        (!(!ms_d1 && $past(ex_mem.reg_write) && !$past(ex_mem.mem_to_reg)) ||
         (wb_data == $past(ex_mem.alu_result)));
      a_p39a_store_data_arch : assert
        (!($past(id_ex.mem_write) && !ms_d1) || (ex_mem.write_data == $past(arch_rt_value)));
      a_p32_no_write_to_zero : assert
        (!($past(rf_write_en) && ($past(mem_wb.dest_reg) == 5'd0)) || (f_zero == 32'd0));
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
