/* verilator lint_off UNOPTFLAT */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHCONCAT */
module Writeback (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  input logic[70:0] _ep_in_req_0,
  output logic[37:0] _ep_id_req_0,
  output logic[37:0] _ep_ex_req_0
);
  logic[31:0] mw_alu_q;
  logic[4:0] mw_dest_q;
  logic[0:0] mw_m2r_q;
  logic[31:0] mw_mdata_q;
  logic[0:0] mw_rw_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$15;
  logic[0:0] thread_0_wire$14;
  logic[4:0] thread_0_wire$13;
  logic[31:0] thread_0_wire$12;
  logic[31:0] thread_0_wire$11;
  logic[37:0] thread_0_wire$10;
  logic[37:0] thread_0_wire$9;
  logic[0:0] thread_0_wire$8;
  logic[4:0] thread_0_wire$7;
  logic[31:0] thread_0_wire$6;
  logic[31:0] thread_0_wire$5;
  logic[31:0] thread_0_wire$4;
  logic[0:0] thread_0_wire$3;
  logic[0:0] thread_0_wire$1;
  logic[70:0] thread_0_wire$0;
  assign thread_0_wire$0 = _ep_in_req_0;
  assign thread_0_wire$1 = mw_m2r_q;
  localparam logic[0:0] thread_0_wire$2 = 1'b1;
  assign thread_0_wire$3 = thread_0_wire$1 == thread_0_wire$2;
  assign thread_0_wire$4 = mw_mdata_q;
  assign thread_0_wire$5 = mw_alu_q;
  assign thread_0_wire$6 = (thread_0_wire$3) ? thread_0_wire$4 : thread_0_wire$5;
  assign thread_0_wire$7 = mw_dest_q;
  assign thread_0_wire$8 = mw_rw_q;
  assign thread_0_wire$9 = {thread_0_wire$6, thread_0_wire$7, thread_0_wire$8};
  assign thread_0_wire$10 = {thread_0_wire$6, thread_0_wire$7, thread_0_wire$8};
  assign thread_0_wire$11 = thread_0_wire$0[39 +: 32];
  assign thread_0_wire$12 = thread_0_wire$0[7 +: 32];
  assign thread_0_wire$13 = thread_0_wire$0[2 +: 5];
  assign thread_0_wire$14 = thread_0_wire$0[1 +: 1];
  assign thread_0_wire$15 = thread_0_wire$0[0 +: 1];
  for (genvar i = 0; i < 2; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_1_1_q, _thread_0_event_counter_1_1_n;
  assign EVENTS0[1].event_current = _thread_0_event_counter_1_1_q;
  assign _thread_0_event_counter_1_1_n = EVENTS0[0].event_current;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[1].event_current;
  assign _ep_id_req_0 = thread_0_wire$9;
  assign _ep_ex_req_0 = thread_0_wire$10;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      mw_alu_q <= '0;
      mw_dest_q <= '0;
      mw_m2r_q <= '0;
      mw_mdata_q <= '0;
      mw_rw_q <= '0;
      _thread_0_event_counter_1_1_q <= '0;
    end else begin
      if (EVENTS0[0].event_current) begin
        mw_m2r_q[0 +: 1] <= thread_0_wire$15;
        mw_rw_q[0 +: 1] <= thread_0_wire$14;
        mw_dest_q[0 +: 5] <= thread_0_wire$13;
        mw_mdata_q[0 +: 32] <= thread_0_wire$12;
        mw_alu_q[0 +: 32] <= thread_0_wire$11;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_1_1_q <= _thread_0_event_counter_1_1_n;
    end
  end
endmodule
module Memory (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  input logic[72:0] _ep_in_req_0,
  output logic[70:0] _ep_out_req_0
);
  logic[8191:0] dmem_q;
  logic[31:0] em_alu_q;
  logic[4:0] em_dest_q;
  logic[0:0] em_m2r_q;
  logic[0:0] em_mw_q;
  logic[0:0] em_rw_q;
  logic[31:0] em_wdata_q;
  logic[0:0] init_done_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$48;
  logic[0:0] thread_0_wire$47;
  logic[0:0] thread_0_wire$46;
  logic[4:0] thread_0_wire$45;
  logic[31:0] thread_0_wire$44;
  logic[31:0] thread_0_wire$43;
  logic[13:0] thread_0_wire$41;
  logic[13:0] thread_0_wire$39;
  logic[12:0] thread_0_wire$37;
  logic[12:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$33;
  logic[31:0] thread_0_wire$31;
  logic[31:0] thread_0_wire$30;
  logic[0:0] thread_0_wire$28;
  logic[7:0] thread_0_wire$26;
  logic[0:0] thread_0_wire$24;
  logic[0:0] thread_0_wire$22;
  logic[0:0] thread_0_wire$20;
  logic[0:0] thread_0_wire$18;
  logic[70:0] thread_0_wire$17;
  logic[4:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$15;
  logic[0:0] thread_0_wire$14;
  logic[31:0] thread_0_wire$13;
  logic[13:0] thread_0_wire$12;
  logic[13:0] thread_0_wire$10;
  logic[12:0] thread_0_wire$8;
  logic[12:0] thread_0_wire$6;
  logic[8191:0] thread_0_wire$4;
  logic[7:0] thread_0_wire$3;
  logic[31:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$1;
  logic[72:0] thread_0_wire$0;
  assign thread_0_wire$0 = _ep_in_req_0;
  assign thread_0_wire$1 = init_done_q;
  assign thread_0_wire$2 = em_alu_q;
  assign thread_0_wire$3 = thread_0_wire$2[2 +: 8];
  assign thread_0_wire$4 = dmem_q;
  localparam logic[4:0] thread_0_wire$5 = 5'd0;
  assign thread_0_wire$6 = {thread_0_wire$5, thread_0_wire$3};
  localparam logic[12:0] thread_0_wire$7 = 13'd32;
  assign thread_0_wire$8 = thread_0_wire$6 * thread_0_wire$7;
  localparam logic[0:0] thread_0_wire$9 = 1'd0;
  assign thread_0_wire$10 = {thread_0_wire$9, thread_0_wire$8};
  localparam logic[13:0] thread_0_wire$11 = 14'd0;
  assign thread_0_wire$12 = thread_0_wire$10 + thread_0_wire$11;
  assign thread_0_wire$13 = thread_0_wire$4[thread_0_wire$12 +: 32];
  assign thread_0_wire$14 = em_m2r_q;
  assign thread_0_wire$15 = em_rw_q;
  assign thread_0_wire$16 = em_dest_q;
  assign thread_0_wire$17 = {thread_0_wire$2, thread_0_wire$13, thread_0_wire$16, thread_0_wire$15, thread_0_wire$14};
  assign thread_0_wire$18 = em_mw_q;
  localparam logic[0:0] thread_0_wire$19 = 1'b0;
  assign thread_0_wire$20 = thread_0_wire$1 == thread_0_wire$19;
  localparam logic[0:0] thread_0_wire$21 = 1'b1;
  assign thread_0_wire$22 = (thread_0_wire$20) ? thread_0_wire$21 : thread_0_wire$18;
  localparam logic[0:0] thread_0_wire$23 = 1'b0;
  assign thread_0_wire$24 = thread_0_wire$1 == thread_0_wire$23;
  localparam logic[7:0] thread_0_wire$25 = 8'd0;
  assign thread_0_wire$26 = (thread_0_wire$24) ? thread_0_wire$25 : thread_0_wire$3;
  localparam logic[0:0] thread_0_wire$27 = 1'b0;
  assign thread_0_wire$28 = thread_0_wire$1 == thread_0_wire$27;
  localparam logic[31:0] thread_0_wire$29 = 32'd20;
  assign thread_0_wire$30 = em_wdata_q;
  assign thread_0_wire$31 = (thread_0_wire$28) ? thread_0_wire$29 : thread_0_wire$30;
  localparam logic[0:0] thread_0_wire$32 = 1'b1;
  assign thread_0_wire$33 = thread_0_wire$22 == thread_0_wire$32;
  localparam logic[4:0] thread_0_wire$34 = 5'd0;
  assign thread_0_wire$35 = {thread_0_wire$34, thread_0_wire$26};
  localparam logic[12:0] thread_0_wire$36 = 13'd32;
  assign thread_0_wire$37 = thread_0_wire$35 * thread_0_wire$36;
  localparam logic[0:0] thread_0_wire$38 = 1'd0;
  assign thread_0_wire$39 = {thread_0_wire$38, thread_0_wire$37};
  localparam logic[13:0] thread_0_wire$40 = 14'd0;
  assign thread_0_wire$41 = thread_0_wire$39 + thread_0_wire$40;
  localparam logic[0:0] thread_0_wire$42 = 1'b1;
  assign thread_0_wire$43 = thread_0_wire$0[41 +: 32];
  assign thread_0_wire$44 = thread_0_wire$0[9 +: 32];
  assign thread_0_wire$45 = thread_0_wire$0[4 +: 5];
  assign thread_0_wire$46 = thread_0_wire$0[2 +: 1];
  assign thread_0_wire$47 = thread_0_wire$0[1 +: 1];
  assign thread_0_wire$48 = thread_0_wire$0[0 +: 1];
  for (genvar i = 0; i < 3; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_2_1_q, _thread_0_event_counter_2_1_n;
  assign EVENTS0[2].event_current = _thread_0_event_counter_2_1_q;
  assign _thread_0_event_counter_2_1_n = EVENTS0[0].event_current;
  assign EVENTS0[1].event_current = EVENTS0[0].event_current && thread_0_wire$33;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[2].event_current;
  assign _ep_out_req_0 = thread_0_wire$17;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      dmem_q <= '0;
      em_alu_q <= '0;
      em_dest_q <= '0;
      em_m2r_q <= '0;
      em_mw_q <= '0;
      em_rw_q <= '0;
      em_wdata_q <= '0;
      init_done_q <= '0;
      _thread_0_event_counter_2_1_q <= '0;
    end else begin
      if (EVENTS0[1].event_current) begin
        dmem_q[thread_0_wire$41 +: 32] <= thread_0_wire$31;
      end
      if (EVENTS0[0].event_current) begin
        em_m2r_q[0 +: 1] <= thread_0_wire$48;
        em_rw_q[0 +: 1] <= thread_0_wire$47;
        em_mw_q[0 +: 1] <= thread_0_wire$46;
        em_dest_q[0 +: 5] <= thread_0_wire$45;
        em_wdata_q[0 +: 32] <= thread_0_wire$44;
        em_alu_q[0 +: 32] <= thread_0_wire$43;
        init_done_q[0 +: 1] <= thread_0_wire$42;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_2_1_q <= _thread_0_event_counter_2_1_n;
    end
  end
endmodule
module Execute (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  input logic[151:0] _ep_in_req_0,
  output logic[72:0] _ep_out_req_0,
  input logic[37:0] _ep_wb_req_0,
  output logic[32:0] _ep_br_if_req_0,
  output logic[32:0] _ep_br_id_req_0
);
  logic[31:0] fw_data_q;
  logic[4:0] fw_rd_q;
  logic[0:0] fw_we_q;
  logic[31:0] ix_addr21_q;
  logic[0:0] ix_alu_src_q;
  logic[0:0] ix_alu_sub_q;
  logic[0:0] ix_branch_zero_q;
  logic[31:0] ix_imm_q;
  logic[0:0] ix_mem_read_q;
  logic[0:0] ix_mem_to_reg_q;
  logic[0:0] ix_mem_write_q;
  logic[4:0] ix_rd_q;
  logic[31:0] ix_rd1_q;
  logic[31:0] ix_rd2_q;
  logic[0:0] ix_reg_dst_q;
  logic[0:0] ix_reg_write_q;
  logic[4:0] ix_rs_q;
  logic[4:0] ix_rt_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$89;
  logic[0:0] thread_0_wire$88;
  logic[0:0] thread_0_wire$87;
  logic[0:0] thread_0_wire$86;
  logic[0:0] thread_0_wire$85;
  logic[0:0] thread_0_wire$84;
  logic[0:0] thread_0_wire$83;
  logic[0:0] thread_0_wire$82;
  logic[4:0] thread_0_wire$81;
  logic[4:0] thread_0_wire$80;
  logic[4:0] thread_0_wire$79;
  logic[31:0] thread_0_wire$78;
  logic[31:0] thread_0_wire$77;
  logic[31:0] thread_0_wire$76;
  logic[31:0] thread_0_wire$75;
  logic[0:0] thread_0_wire$74;
  logic[32:0] thread_0_wire$73;
  logic[32:0] thread_0_wire$72;
  logic[72:0] thread_0_wire$71;
  logic[0:0] thread_0_wire$70;
  logic[0:0] thread_0_wire$69;
  logic[0:0] thread_0_wire$68;
  logic[0:0] thread_0_wire$67;
  logic[0:0] thread_0_wire$66;
  logic[0:0] thread_0_wire$65;
  logic[0:0] thread_0_wire$63;
  logic[31:0] thread_0_wire$62;
  logic[31:0] thread_0_wire$60;
  logic[4:0] thread_0_wire$59;
  logic[4:0] thread_0_wire$58;
  logic[0:0] thread_0_wire$57;
  logic[0:0] thread_0_wire$55;
  logic[31:0] thread_0_wire$54;
  logic[31:0] thread_0_wire$53;
  logic[31:0] thread_0_wire$52;
  logic[0:0] thread_0_wire$51;
  logic[0:0] thread_0_wire$49;
  logic[31:0] thread_0_wire$48;
  logic[31:0] thread_0_wire$47;
  logic[0:0] thread_0_wire$46;
  logic[0:0] thread_0_wire$44;
  logic[31:0] thread_0_wire$43;
  logic[0:0] thread_0_wire$42;
  logic[31:0] thread_0_wire$40;
  logic[31:0] thread_0_wire$39;
  logic[31:0] thread_0_wire$38;
  logic[0:0] thread_0_wire$37;
  logic[0:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$34;
  logic[4:0] thread_0_wire$33;
  logic[0:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$31;
  logic[0:0] thread_0_wire$30;
  logic[0:0] thread_0_wire$29;
  logic[0:0] thread_0_wire$28;
  logic[31:0] thread_0_wire$27;
  logic[0:0] thread_0_wire$26;
  logic[31:0] thread_0_wire$24;
  logic[31:0] thread_0_wire$23;
  logic[31:0] thread_0_wire$22;
  logic[0:0] thread_0_wire$21;
  logic[0:0] thread_0_wire$19;
  logic[0:0] thread_0_wire$18;
  logic[4:0] thread_0_wire$17;
  logic[0:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$15;
  logic[0:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$13;
  logic[0:0] thread_0_wire$12;
  logic[0:0] thread_0_wire$11;
  logic[4:0] thread_0_wire$9;
  logic[0:0] thread_0_wire$8;
  logic[31:0] thread_0_wire$6;
  logic[0:0] thread_0_wire$5;
  logic[4:0] thread_0_wire$4;
  logic[4:0] thread_0_wire$3;
  logic[4:0] thread_0_wire$2;
  logic[37:0] thread_0_wire$1;
  logic[151:0] thread_0_wire$0;
  assign thread_0_wire$0 = _ep_in_req_0;
  assign thread_0_wire$1 = _ep_wb_req_0;
  assign thread_0_wire$2 = ix_rs_q;
  assign thread_0_wire$3 = ix_rt_q;
  assign thread_0_wire$4 = fw_rd_q;
  assign thread_0_wire$5 = fw_we_q;
  assign thread_0_wire$6 = fw_data_q;
  localparam logic[4:0] thread_0_wire$7 = 5'd0;
  assign thread_0_wire$8 = thread_0_wire$4 != thread_0_wire$7;
  assign thread_0_wire$9 = thread_0_wire$1[1 +: 5];
  localparam logic[4:0] thread_0_wire$10 = 5'd0;
  assign thread_0_wire$11 = thread_0_wire$9 != thread_0_wire$10;
  assign thread_0_wire$12 = thread_0_wire$5 & thread_0_wire$8;
  assign thread_0_wire$13 = thread_0_wire$4 == thread_0_wire$2;
  assign thread_0_wire$14 = thread_0_wire$12 & thread_0_wire$13;
  assign thread_0_wire$15 = thread_0_wire$1[0 +: 1];
  assign thread_0_wire$16 = thread_0_wire$15 & thread_0_wire$11;
  assign thread_0_wire$17 = thread_0_wire$1[1 +: 5];
  assign thread_0_wire$18 = thread_0_wire$17 == thread_0_wire$2;
  assign thread_0_wire$19 = thread_0_wire$16 & thread_0_wire$18;
  localparam logic[0:0] thread_0_wire$20 = 1'b1;
  assign thread_0_wire$21 = thread_0_wire$19 == thread_0_wire$20;
  assign thread_0_wire$22 = thread_0_wire$1[6 +: 32];
  assign thread_0_wire$23 = ix_rd1_q;
  assign thread_0_wire$24 = (thread_0_wire$21) ? thread_0_wire$22 : thread_0_wire$23;
  localparam logic[0:0] thread_0_wire$25 = 1'b1;
  assign thread_0_wire$26 = thread_0_wire$14 == thread_0_wire$25;
  assign thread_0_wire$27 = (thread_0_wire$26) ? thread_0_wire$6 : thread_0_wire$24;
  assign thread_0_wire$28 = thread_0_wire$5 & thread_0_wire$8;
  assign thread_0_wire$29 = thread_0_wire$4 == thread_0_wire$3;
  assign thread_0_wire$30 = thread_0_wire$28 & thread_0_wire$29;
  assign thread_0_wire$31 = thread_0_wire$1[0 +: 1];
  assign thread_0_wire$32 = thread_0_wire$31 & thread_0_wire$11;
  assign thread_0_wire$33 = thread_0_wire$1[1 +: 5];
  assign thread_0_wire$34 = thread_0_wire$33 == thread_0_wire$3;
  assign thread_0_wire$35 = thread_0_wire$32 & thread_0_wire$34;
  localparam logic[0:0] thread_0_wire$36 = 1'b1;
  assign thread_0_wire$37 = thread_0_wire$35 == thread_0_wire$36;
  assign thread_0_wire$38 = thread_0_wire$1[6 +: 32];
  assign thread_0_wire$39 = ix_rd2_q;
  assign thread_0_wire$40 = (thread_0_wire$37) ? thread_0_wire$38 : thread_0_wire$39;
  localparam logic[0:0] thread_0_wire$41 = 1'b1;
  assign thread_0_wire$42 = thread_0_wire$30 == thread_0_wire$41;
  assign thread_0_wire$43 = (thread_0_wire$42) ? thread_0_wire$6 : thread_0_wire$40;
  assign thread_0_wire$44 = ix_alu_src_q;
  localparam logic[0:0] thread_0_wire$45 = 1'b1;
  assign thread_0_wire$46 = thread_0_wire$44 == thread_0_wire$45;
  assign thread_0_wire$47 = ix_imm_q;
  assign thread_0_wire$48 = (thread_0_wire$46) ? thread_0_wire$47 : thread_0_wire$43;
  assign thread_0_wire$49 = ix_alu_sub_q;
  localparam logic[0:0] thread_0_wire$50 = 1'b1;
  assign thread_0_wire$51 = thread_0_wire$49 == thread_0_wire$50;
  assign thread_0_wire$52 = thread_0_wire$27 - thread_0_wire$48;
  assign thread_0_wire$53 = thread_0_wire$27 + thread_0_wire$48;
  assign thread_0_wire$54 = (thread_0_wire$51) ? thread_0_wire$52 : thread_0_wire$53;
  assign thread_0_wire$55 = ix_reg_dst_q;
  localparam logic[0:0] thread_0_wire$56 = 1'b1;
  assign thread_0_wire$57 = thread_0_wire$55 == thread_0_wire$56;
  assign thread_0_wire$58 = ix_rd_q;
  assign thread_0_wire$59 = (thread_0_wire$57) ? thread_0_wire$58 : thread_0_wire$3;
  assign thread_0_wire$60 = ix_addr21_q;
  localparam logic[31:0] thread_0_wire$61 = 32'd2;
  assign thread_0_wire$62 = thread_0_wire$60 << thread_0_wire$61;
  assign thread_0_wire$63 = ix_branch_zero_q;
  localparam logic[31:0] thread_0_wire$64 = 32'd0;
  assign thread_0_wire$65 = thread_0_wire$27 == thread_0_wire$64;
  assign thread_0_wire$66 = thread_0_wire$63 & thread_0_wire$65;
  assign thread_0_wire$67 = ix_mem_to_reg_q;
  assign thread_0_wire$68 = ix_reg_write_q;
  assign thread_0_wire$69 = ix_mem_write_q;
  assign thread_0_wire$70 = ix_mem_read_q;
  assign thread_0_wire$71 = {thread_0_wire$54, thread_0_wire$43, thread_0_wire$59, thread_0_wire$70, thread_0_wire$69, thread_0_wire$68, thread_0_wire$67};
  assign thread_0_wire$72 = {thread_0_wire$66, thread_0_wire$62};
  assign thread_0_wire$73 = {thread_0_wire$66, thread_0_wire$62};
  assign thread_0_wire$74 = ix_reg_write_q;
  assign thread_0_wire$75 = thread_0_wire$0[120 +: 32];
  assign thread_0_wire$76 = thread_0_wire$0[88 +: 32];
  assign thread_0_wire$77 = thread_0_wire$0[56 +: 32];
  assign thread_0_wire$78 = thread_0_wire$0[24 +: 32];
  assign thread_0_wire$79 = thread_0_wire$0[19 +: 5];
  assign thread_0_wire$80 = thread_0_wire$0[14 +: 5];
  assign thread_0_wire$81 = thread_0_wire$0[9 +: 5];
  assign thread_0_wire$82 = thread_0_wire$0[8 +: 1];
  assign thread_0_wire$83 = thread_0_wire$0[7 +: 1];
  assign thread_0_wire$84 = thread_0_wire$0[6 +: 1];
  assign thread_0_wire$85 = thread_0_wire$0[5 +: 1];
  assign thread_0_wire$86 = thread_0_wire$0[4 +: 1];
  assign thread_0_wire$87 = thread_0_wire$0[3 +: 1];
  assign thread_0_wire$88 = thread_0_wire$0[2 +: 1];
  assign thread_0_wire$89 = thread_0_wire$0[1 +: 1];
  for (genvar i = 0; i < 2; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_1_1_q, _thread_0_event_counter_1_1_n;
  assign EVENTS0[1].event_current = _thread_0_event_counter_1_1_q;
  assign _thread_0_event_counter_1_1_n = EVENTS0[0].event_current;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[1].event_current;
  assign _ep_br_id_req_0 = thread_0_wire$73;
  assign _ep_out_req_0 = thread_0_wire$71;
  assign _ep_br_if_req_0 = thread_0_wire$72;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      fw_data_q <= '0;
      fw_rd_q <= '0;
      fw_we_q <= '0;
      ix_addr21_q <= '0;
      ix_alu_src_q <= '0;
      ix_alu_sub_q <= '0;
      ix_branch_zero_q <= '0;
      ix_imm_q <= '0;
      ix_mem_read_q <= '0;
      ix_mem_to_reg_q <= '0;
      ix_mem_write_q <= '0;
      ix_rd_q <= '0;
      ix_rd1_q <= '0;
      ix_rd2_q <= '0;
      ix_reg_dst_q <= '0;
      ix_reg_write_q <= '0;
      ix_rs_q <= '0;
      ix_rt_q <= '0;
      _thread_0_event_counter_1_1_q <= '0;
    end else begin
      if (EVENTS0[0].event_current) begin
        ix_branch_zero_q[0 +: 1] <= thread_0_wire$89;
        ix_mem_to_reg_q[0 +: 1] <= thread_0_wire$88;
        ix_reg_write_q[0 +: 1] <= thread_0_wire$87;
        ix_mem_write_q[0 +: 1] <= thread_0_wire$86;
        ix_mem_read_q[0 +: 1] <= thread_0_wire$85;
        ix_reg_dst_q[0 +: 1] <= thread_0_wire$84;
        ix_alu_src_q[0 +: 1] <= thread_0_wire$83;
        ix_alu_sub_q[0 +: 1] <= thread_0_wire$82;
        ix_rd_q[0 +: 5] <= thread_0_wire$81;
        ix_rt_q[0 +: 5] <= thread_0_wire$80;
        ix_rs_q[0 +: 5] <= thread_0_wire$79;
        ix_addr21_q[0 +: 32] <= thread_0_wire$78;
        ix_imm_q[0 +: 32] <= thread_0_wire$77;
        ix_rd2_q[0 +: 32] <= thread_0_wire$76;
        ix_rd1_q[0 +: 32] <= thread_0_wire$75;
        fw_data_q[0 +: 32] <= thread_0_wire$54;
        fw_we_q[0 +: 1] <= thread_0_wire$74;
        fw_rd_q[0 +: 5] <= thread_0_wire$59;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_1_1_q <= _thread_0_event_counter_1_1_n;
    end
  end
endmodule
module Decode (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  input logic[64:0] _ep_in_req_0,
  output logic[151:0] _ep_out_req_0,
  input logic[37:0] _ep_wb_req_0,
  input logic[32:0] _ep_branch_req_0,
  output logic[0:0] _ep_stall_req_0
);
  logic[31:0] ifid_instr_q;
  logic[31:0] ifid_pc_q;
  logic[0:0] ifid_valid_q;
  logic[1023:0] regs_q;
  logic[0:0] sh_mem_read_q;
  logic[4:0] sh_rt_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[10:0] thread_0_wire$136;
  logic[10:0] thread_0_wire$134;
  logic[9:0] thread_0_wire$132;
  logic[9:0] thread_0_wire$130;
  logic[0:0] thread_0_wire$128;
  logic[0:0] thread_0_wire$126;
  logic[31:0] thread_0_wire$125;
  logic[31:0] thread_0_wire$124;
  logic[0:0] thread_0_wire$123;
  logic[0:0] thread_0_wire$121;
  logic[0:0] thread_0_wire$120;
  logic[31:0] thread_0_wire$118;
  logic[0:0] thread_0_wire$117;
  logic[0:0] thread_0_wire$115;
  logic[0:0] thread_0_wire$114;
  logic[0:0] thread_0_wire$112;
  logic[31:0] thread_0_wire$110;
  logic[31:0] thread_0_wire$109;
  logic[0:0] thread_0_wire$107;
  logic[31:0] thread_0_wire$105;
  logic[4:0] thread_0_wire$104;
  logic[0:0] thread_0_wire$103;
  logic[0:0] thread_0_wire$102;
  logic[151:0] thread_0_wire$101;
  logic[0:0] thread_0_wire$100;
  logic[0:0] thread_0_wire$99;
  logic[0:0] thread_0_wire$98;
  logic[0:0] thread_0_wire$97;
  logic[0:0] thread_0_wire$96;
  logic[0:0] thread_0_wire$95;
  logic[0:0] thread_0_wire$94;
  logic[0:0] thread_0_wire$92;
  logic[0:0] thread_0_wire$90;
  logic[0:0] thread_0_wire$89;
  logic[31:0] thread_0_wire$88;
  logic[31:0] thread_0_wire$86;
  logic[31:0] thread_0_wire$85;
  logic[0:0] thread_0_wire$83;
  logic[31:0] thread_0_wire$81;
  logic[0:0] thread_0_wire$79;
  logic[31:0] thread_0_wire$78;
  logic[31:0] thread_0_wire$77;
  logic[0:0] thread_0_wire$76;
  logic[31:0] thread_0_wire$74;
  logic[31:0] thread_0_wire$73;
  logic[0:0] thread_0_wire$72;
  logic[31:0] thread_0_wire$70;
  logic[10:0] thread_0_wire$69;
  logic[10:0] thread_0_wire$67;
  logic[9:0] thread_0_wire$65;
  logic[9:0] thread_0_wire$63;
  logic[1023:0] thread_0_wire$61;
  logic[31:0] thread_0_wire$60;
  logic[10:0] thread_0_wire$59;
  logic[10:0] thread_0_wire$57;
  logic[9:0] thread_0_wire$55;
  logic[9:0] thread_0_wire$53;
  logic[1023:0] thread_0_wire$51;
  logic[0:0] thread_0_wire$50;
  logic[0:0] thread_0_wire$49;
  logic[4:0] thread_0_wire$48;
  logic[0:0] thread_0_wire$47;
  logic[0:0] thread_0_wire$46;
  logic[0:0] thread_0_wire$45;
  logic[0:0] thread_0_wire$44;
  logic[4:0] thread_0_wire$43;
  logic[0:0] thread_0_wire$42;
  logic[0:0] thread_0_wire$41;
  logic[0:0] thread_0_wire$40;
  logic[4:0] thread_0_wire$38;
  logic[0:0] thread_0_wire$37;
  logic[0:0] thread_0_wire$36;
  logic[0:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$34;
  logic[0:0] thread_0_wire$33;
  logic[0:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$31;
  logic[0:0] thread_0_wire$30;
  logic[0:0] thread_0_wire$29;
  logic[0:0] thread_0_wire$28;
  logic[4:0] thread_0_wire$26;
  logic[0:0] thread_0_wire$25;
  logic[0:0] thread_0_wire$24;
  logic[0:0] thread_0_wire$23;
  logic[0:0] thread_0_wire$22;
  logic[0:0] thread_0_wire$21;
  logic[0:0] thread_0_wire$20;
  logic[0:0] thread_0_wire$18;
  logic[0:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$12;
  logic[4:0] thread_0_wire$10;
  logic[4:0] thread_0_wire$9;
  logic[4:0] thread_0_wire$8;
  logic[5:0] thread_0_wire$7;
  logic[5:0] thread_0_wire$6;
  logic[31:0] thread_0_wire$5;
  logic[0:0] thread_0_wire$4;
  logic[31:0] thread_0_wire$3;
  logic[32:0] thread_0_wire$2;
  logic[37:0] thread_0_wire$1;
  logic[64:0] thread_0_wire$0;
  assign thread_0_wire$0 = _ep_in_req_0;
  assign thread_0_wire$1 = _ep_wb_req_0;
  assign thread_0_wire$2 = _ep_branch_req_0;
  assign thread_0_wire$3 = ifid_instr_q;
  assign thread_0_wire$4 = ifid_valid_q;
  assign thread_0_wire$5 = ifid_pc_q;
  assign thread_0_wire$6 = thread_0_wire$3[26 +: 6];
  assign thread_0_wire$7 = thread_0_wire$3[0 +: 6];
  assign thread_0_wire$8 = thread_0_wire$3[21 +: 5];
  assign thread_0_wire$9 = thread_0_wire$3[16 +: 5];
  assign thread_0_wire$10 = thread_0_wire$3[11 +: 5];
  localparam logic[5:0] thread_0_wire$11 = 6'b000000;
  assign thread_0_wire$12 = thread_0_wire$6 == thread_0_wire$11;
  localparam logic[5:0] thread_0_wire$13 = 6'b100011;
  assign thread_0_wire$14 = thread_0_wire$6 == thread_0_wire$13;
  localparam logic[5:0] thread_0_wire$15 = 6'b101011;
  assign thread_0_wire$16 = thread_0_wire$6 == thread_0_wire$15;
  localparam logic[5:0] thread_0_wire$17 = 6'b000010;
  assign thread_0_wire$18 = thread_0_wire$6 == thread_0_wire$17;
  localparam logic[5:0] thread_0_wire$19 = 6'b100010;
  assign thread_0_wire$20 = thread_0_wire$7 == thread_0_wire$19;
  assign thread_0_wire$21 = thread_0_wire$12 & thread_0_wire$20;
  assign thread_0_wire$22 = thread_0_wire$12 | thread_0_wire$14;
  assign thread_0_wire$23 = thread_0_wire$22 | thread_0_wire$16;
  assign thread_0_wire$24 = thread_0_wire$23 | thread_0_wire$18;
  assign thread_0_wire$25 = thread_0_wire$12 | thread_0_wire$16;
  assign thread_0_wire$26 = sh_rt_q;
  localparam logic[4:0] thread_0_wire$27 = 5'd0;
  assign thread_0_wire$28 = thread_0_wire$26 != thread_0_wire$27;
  assign thread_0_wire$29 = thread_0_wire$26 == thread_0_wire$8;
  assign thread_0_wire$30 = thread_0_wire$24 & thread_0_wire$29;
  assign thread_0_wire$31 = thread_0_wire$26 == thread_0_wire$9;
  assign thread_0_wire$32 = thread_0_wire$25 & thread_0_wire$31;
  assign thread_0_wire$33 = sh_mem_read_q;
  assign thread_0_wire$34 = thread_0_wire$33 & thread_0_wire$28;
  assign thread_0_wire$35 = thread_0_wire$34 & thread_0_wire$4;
  assign thread_0_wire$36 = thread_0_wire$30 | thread_0_wire$32;
  assign thread_0_wire$37 = thread_0_wire$35 & thread_0_wire$36;
  assign thread_0_wire$38 = thread_0_wire$1[1 +: 5];
  localparam logic[4:0] thread_0_wire$39 = 5'd0;
  assign thread_0_wire$40 = thread_0_wire$38 != thread_0_wire$39;
  assign thread_0_wire$41 = thread_0_wire$1[0 +: 1];
  assign thread_0_wire$42 = thread_0_wire$41 & thread_0_wire$40;
  assign thread_0_wire$43 = thread_0_wire$1[1 +: 5];
  assign thread_0_wire$44 = thread_0_wire$43 == thread_0_wire$8;
  assign thread_0_wire$45 = thread_0_wire$42 & thread_0_wire$44;
  assign thread_0_wire$46 = thread_0_wire$1[0 +: 1];
  assign thread_0_wire$47 = thread_0_wire$46 & thread_0_wire$40;
  assign thread_0_wire$48 = thread_0_wire$1[1 +: 5];
  assign thread_0_wire$49 = thread_0_wire$48 == thread_0_wire$9;
  assign thread_0_wire$50 = thread_0_wire$47 & thread_0_wire$49;
  assign thread_0_wire$51 = regs_q;
  localparam logic[4:0] thread_0_wire$52 = 5'd0;
  assign thread_0_wire$53 = {thread_0_wire$52, thread_0_wire$8};
  localparam logic[9:0] thread_0_wire$54 = 10'd32;
  assign thread_0_wire$55 = thread_0_wire$53 * thread_0_wire$54;
  localparam logic[0:0] thread_0_wire$56 = 1'd0;
  assign thread_0_wire$57 = {thread_0_wire$56, thread_0_wire$55};
  localparam logic[10:0] thread_0_wire$58 = 11'd0;
  assign thread_0_wire$59 = thread_0_wire$57 + thread_0_wire$58;
  assign thread_0_wire$60 = thread_0_wire$51[thread_0_wire$59 +: 32];
  assign thread_0_wire$61 = regs_q;
  localparam logic[4:0] thread_0_wire$62 = 5'd0;
  assign thread_0_wire$63 = {thread_0_wire$62, thread_0_wire$9};
  localparam logic[9:0] thread_0_wire$64 = 10'd32;
  assign thread_0_wire$65 = thread_0_wire$63 * thread_0_wire$64;
  localparam logic[0:0] thread_0_wire$66 = 1'd0;
  assign thread_0_wire$67 = {thread_0_wire$66, thread_0_wire$65};
  localparam logic[10:0] thread_0_wire$68 = 11'd0;
  assign thread_0_wire$69 = thread_0_wire$67 + thread_0_wire$68;
  assign thread_0_wire$70 = thread_0_wire$61[thread_0_wire$69 +: 32];
  localparam logic[0:0] thread_0_wire$71 = 1'b1;
  assign thread_0_wire$72 = thread_0_wire$45 == thread_0_wire$71;
  assign thread_0_wire$73 = thread_0_wire$1[6 +: 32];
  assign thread_0_wire$74 = (thread_0_wire$72) ? thread_0_wire$73 : thread_0_wire$60;
  localparam logic[0:0] thread_0_wire$75 = 1'b1;
  assign thread_0_wire$76 = thread_0_wire$50 == thread_0_wire$75;
  assign thread_0_wire$77 = thread_0_wire$1[6 +: 32];
  assign thread_0_wire$78 = (thread_0_wire$76) ? thread_0_wire$77 : thread_0_wire$70;
  assign thread_0_wire$79 = thread_0_wire$3[15 +: 1];
  localparam logic[31:0] thread_0_wire$80 = 32'h0000ffff;
  assign thread_0_wire$81 = thread_0_wire$3 & thread_0_wire$80;
  localparam logic[0:0] thread_0_wire$82 = 1'b1;
  assign thread_0_wire$83 = thread_0_wire$79 == thread_0_wire$82;
  localparam logic[31:0] thread_0_wire$84 = 32'hffff0000;
  assign thread_0_wire$85 = thread_0_wire$81 | thread_0_wire$84;
  assign thread_0_wire$86 = (thread_0_wire$83) ? thread_0_wire$85 : thread_0_wire$81;
  localparam logic[31:0] thread_0_wire$87 = 32'h001fffff;
  assign thread_0_wire$88 = thread_0_wire$3 & thread_0_wire$87;
  assign thread_0_wire$89 = thread_0_wire$2[32 +: 1];
  assign thread_0_wire$90 = thread_0_wire$37 | thread_0_wire$89;
  localparam logic[0:0] thread_0_wire$91 = 1'b1;
  assign thread_0_wire$92 = thread_0_wire$90 == thread_0_wire$91;
  localparam logic[0:0] thread_0_wire$93 = 1'b0;
  assign thread_0_wire$94 = (thread_0_wire$92) ? thread_0_wire$93 : thread_0_wire$4;
  assign thread_0_wire$95 = thread_0_wire$18 & thread_0_wire$94;
  assign thread_0_wire$96 = thread_0_wire$12 | thread_0_wire$14;
  assign thread_0_wire$97 = thread_0_wire$96 & thread_0_wire$94;
  assign thread_0_wire$98 = thread_0_wire$16 & thread_0_wire$94;
  assign thread_0_wire$99 = thread_0_wire$14 & thread_0_wire$94;
  assign thread_0_wire$100 = thread_0_wire$14 | thread_0_wire$16;
  assign thread_0_wire$101 = {thread_0_wire$74, thread_0_wire$78, thread_0_wire$86, thread_0_wire$88, thread_0_wire$8, thread_0_wire$9, thread_0_wire$10, thread_0_wire$21, thread_0_wire$100, thread_0_wire$12, thread_0_wire$99, thread_0_wire$98, thread_0_wire$97, thread_0_wire$14, thread_0_wire$95, thread_0_wire$94};
  assign thread_0_wire$102 = thread_0_wire$1[0 +: 1];
  assign thread_0_wire$103 = thread_0_wire$102 & thread_0_wire$40;
  assign thread_0_wire$104 = thread_0_wire$1[1 +: 5];
  assign thread_0_wire$105 = thread_0_wire$1[6 +: 32];
  localparam logic[0:0] thread_0_wire$106 = 1'b1;
  assign thread_0_wire$107 = thread_0_wire$89 == thread_0_wire$106;
  localparam logic[31:0] thread_0_wire$108 = 32'd0;
  assign thread_0_wire$109 = thread_0_wire$0[1 +: 32];
  assign thread_0_wire$110 = (thread_0_wire$107) ? thread_0_wire$108 : thread_0_wire$109;
  localparam logic[0:0] thread_0_wire$111 = 1'b1;
  assign thread_0_wire$112 = thread_0_wire$89 == thread_0_wire$111;
  localparam logic[0:0] thread_0_wire$113 = 1'b0;
  assign thread_0_wire$114 = thread_0_wire$0[0 +: 1];
  assign thread_0_wire$115 = (thread_0_wire$112) ? thread_0_wire$113 : thread_0_wire$114;
  localparam logic[0:0] thread_0_wire$116 = 1'b1;
  assign thread_0_wire$117 = thread_0_wire$37 == thread_0_wire$116;
  assign thread_0_wire$118 = (thread_0_wire$117) ? thread_0_wire$3 : thread_0_wire$110;
  localparam logic[0:0] thread_0_wire$119 = 1'b1;
  assign thread_0_wire$120 = thread_0_wire$37 == thread_0_wire$119;
  assign thread_0_wire$121 = (thread_0_wire$120) ? thread_0_wire$4 : thread_0_wire$115;
  localparam logic[0:0] thread_0_wire$122 = 1'b1;
  assign thread_0_wire$123 = thread_0_wire$37 == thread_0_wire$122;
  assign thread_0_wire$124 = thread_0_wire$0[33 +: 32];
  assign thread_0_wire$125 = (thread_0_wire$123) ? thread_0_wire$5 : thread_0_wire$124;
  assign thread_0_wire$126 = thread_0_wire$14 & thread_0_wire$94;
  localparam logic[0:0] thread_0_wire$127 = 1'b1;
  assign thread_0_wire$128 = thread_0_wire$103 == thread_0_wire$127;
  localparam logic[4:0] thread_0_wire$129 = 5'd0;
  assign thread_0_wire$130 = {thread_0_wire$129, thread_0_wire$104};
  localparam logic[9:0] thread_0_wire$131 = 10'd32;
  assign thread_0_wire$132 = thread_0_wire$130 * thread_0_wire$131;
  localparam logic[0:0] thread_0_wire$133 = 1'd0;
  assign thread_0_wire$134 = {thread_0_wire$133, thread_0_wire$132};
  localparam logic[10:0] thread_0_wire$135 = 11'd0;
  assign thread_0_wire$136 = thread_0_wire$134 + thread_0_wire$135;
  for (genvar i = 0; i < 3; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_2_1_q, _thread_0_event_counter_2_1_n;
  assign EVENTS0[2].event_current = _thread_0_event_counter_2_1_q;
  assign _thread_0_event_counter_2_1_n = EVENTS0[0].event_current;
  assign EVENTS0[1].event_current = EVENTS0[0].event_current && thread_0_wire$128;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[2].event_current;
  assign _ep_out_req_0 = thread_0_wire$101;
  assign _ep_stall_req_0 = thread_0_wire$37;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      ifid_instr_q <= '0;
      ifid_pc_q <= '0;
      ifid_valid_q <= '0;
      regs_q <= '0;
      sh_mem_read_q <= '0;
      sh_rt_q <= '0;
      _thread_0_event_counter_2_1_q <= '0;
    end else begin
      if (EVENTS0[1].event_current) begin
        regs_q[thread_0_wire$136 +: 32] <= thread_0_wire$105;
      end
      if (EVENTS0[0].event_current) begin
        sh_rt_q[0 +: 5] <= thread_0_wire$9;
        sh_mem_read_q[0 +: 1] <= thread_0_wire$126;
        ifid_pc_q[0 +: 32] <= thread_0_wire$125;
        ifid_valid_q[0 +: 1] <= thread_0_wire$121;
        ifid_instr_q[0 +: 32] <= thread_0_wire$118;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_2_1_q <= _thread_0_event_counter_2_1_n;
    end
  end
endmodule
module Fetch (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[64:0] _ep_out_req_0,
  input logic[32:0] _ep_branch_req_0,
  input logic[0:0] _ep_stall_req_0
);
  logic[8191:0] imem_q;
  logic[0:0] init_done_q;
  logic[31:0] pc_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$39;
  logic[31:0] thread_0_wire$37;
  logic[0:0] thread_0_wire$36;
  logic[31:0] thread_0_wire$34;
  logic[31:0] thread_0_wire$33;
  logic[0:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$30;
  logic[31:0] thread_0_wire$29;
  logic[31:0] thread_0_wire$28;
  logic[0:0] thread_0_wire$26;
  logic[64:0] thread_0_wire$24;
  logic[0:0] thread_0_wire$23;
  logic[0:0] thread_0_wire$20;
  logic[31:0] thread_0_wire$18;
  logic[0:0] thread_0_wire$16;
  logic[31:0] thread_0_wire$14;
  logic[13:0] thread_0_wire$13;
  logic[13:0] thread_0_wire$11;
  logic[12:0] thread_0_wire$9;
  logic[12:0] thread_0_wire$7;
  logic[7:0] thread_0_wire$5;
  logic[8191:0] thread_0_wire$4;
  logic[31:0] thread_0_wire$3;
  logic[0:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$1;
  logic[32:0] thread_0_wire$0;
  assign thread_0_wire$0 = _ep_branch_req_0;
  assign thread_0_wire$1 = _ep_stall_req_0;
  assign thread_0_wire$2 = init_done_q;
  assign thread_0_wire$3 = pc_q;
  assign thread_0_wire$4 = imem_q;
  assign thread_0_wire$5 = thread_0_wire$3[2 +: 8];
  localparam logic[4:0] thread_0_wire$6 = 5'd0;
  assign thread_0_wire$7 = {thread_0_wire$6, thread_0_wire$5};
  localparam logic[12:0] thread_0_wire$8 = 13'd32;
  assign thread_0_wire$9 = thread_0_wire$7 * thread_0_wire$8;
  localparam logic[0:0] thread_0_wire$10 = 1'd0;
  assign thread_0_wire$11 = {thread_0_wire$10, thread_0_wire$9};
  localparam logic[13:0] thread_0_wire$12 = 14'd0;
  assign thread_0_wire$13 = thread_0_wire$11 + thread_0_wire$12;
  assign thread_0_wire$14 = thread_0_wire$4[thread_0_wire$13 +: 32];
  localparam logic[0:0] thread_0_wire$15 = 1'b1;
  assign thread_0_wire$16 = thread_0_wire$2 == thread_0_wire$15;
  localparam logic[31:0] thread_0_wire$17 = 32'd0;
  assign thread_0_wire$18 = (thread_0_wire$16) ? thread_0_wire$14 : thread_0_wire$17;
  localparam logic[0:0] thread_0_wire$19 = 1'b1;
  assign thread_0_wire$20 = thread_0_wire$2 == thread_0_wire$19;
  localparam logic[0:0] thread_0_wire$21 = 1'b1;
  localparam logic[0:0] thread_0_wire$22 = 1'b0;
  assign thread_0_wire$23 = (thread_0_wire$20) ? thread_0_wire$21 : thread_0_wire$22;
  assign thread_0_wire$24 = {thread_0_wire$3, thread_0_wire$18, thread_0_wire$23};
  localparam logic[0:0] thread_0_wire$25 = 1'b1;
  assign thread_0_wire$26 = thread_0_wire$1 == thread_0_wire$25;
  localparam logic[31:0] thread_0_wire$27 = 32'd4;
  assign thread_0_wire$28 = thread_0_wire$3 + thread_0_wire$27;
  assign thread_0_wire$29 = (thread_0_wire$26) ? thread_0_wire$3 : thread_0_wire$28;
  assign thread_0_wire$30 = thread_0_wire$0[32 +: 1];
  localparam logic[0:0] thread_0_wire$31 = 1'b1;
  assign thread_0_wire$32 = thread_0_wire$30 == thread_0_wire$31;
  assign thread_0_wire$33 = thread_0_wire$0[0 +: 32];
  assign thread_0_wire$34 = (thread_0_wire$32) ? thread_0_wire$33 : thread_0_wire$29;
  localparam logic[0:0] thread_0_wire$35 = 1'b0;
  assign thread_0_wire$36 = thread_0_wire$2 == thread_0_wire$35;
  assign thread_0_wire$37 = (thread_0_wire$36) ? thread_0_wire$3 : thread_0_wire$34;
  localparam logic[0:0] thread_0_wire$38 = 1'b0;
  assign thread_0_wire$39 = thread_0_wire$2 == thread_0_wire$38;
  localparam logic[31:0] thread_0_wire$40 = 32'h8c010000;
  localparam logic[31:0] thread_0_wire$41 = 32'h00201020;
  localparam logic[31:0] thread_0_wire$42 = 32'h00411022;
  localparam logic[31:0] thread_0_wire$43 = 32'h08400005;
  localparam logic[31:0] thread_0_wire$44 = 32'h00411820;
  localparam logic[31:0] thread_0_wire$45 = 32'h00412020;
  localparam logic[31:0] thread_0_wire$46 = 32'hac810000;
  localparam logic[0:0] thread_0_wire$47 = 1'b1;
  for (genvar i = 0; i < 3; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_2_1_q, _thread_0_event_counter_2_1_n;
  assign EVENTS0[2].event_current = _thread_0_event_counter_2_1_q;
  assign _thread_0_event_counter_2_1_n = EVENTS0[0].event_current;
  assign EVENTS0[1].event_current = EVENTS0[0].event_current && thread_0_wire$39;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[2].event_current;
  assign _ep_out_req_0 = thread_0_wire$24;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      imem_q <= '0;
      init_done_q <= '0;
      pc_q <= '0;
      _thread_0_event_counter_2_1_q <= '0;
    end else begin
      if (EVENTS0[1].event_current) begin
        imem_q[192 +: 32] <= thread_0_wire$46;
        imem_q[160 +: 32] <= thread_0_wire$45;
        imem_q[128 +: 32] <= thread_0_wire$44;
        imem_q[96 +: 32] <= thread_0_wire$43;
        imem_q[64 +: 32] <= thread_0_wire$42;
        imem_q[32 +: 32] <= thread_0_wire$41;
        imem_q[0 +: 32] <= thread_0_wire$40;
      end
      if (EVENTS0[0].event_current) begin
        pc_q[0 +: 32] <= thread_0_wire$37;
        init_done_q[0 +: 1] <= thread_0_wire$47;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_2_1_q <= _thread_0_event_counter_2_1_n;
    end
  end
endmodule
module MipsPipeline (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni
);
  logic[64:0] _if_id_le_req_0;
  logic[151:0] _id_ex_le_req_0;
  logic[72:0] _ex_mem_le_req_0;
  logic[70:0] _mem_wb_le_req_0;
  logic[37:0] _wb_id_le_req_0;
  logic[37:0] _wb_ex_le_req_0;
  logic[32:0] _br_if_le_req_0;
  logic[32:0] _br_id_le_req_0;
  logic[0:0] _stall_le_req_0;
  Fetch _spawn_0 (
    .clk_i,
    .rst_ni
    ,._ep_out_req_0 (_if_id_le_req_0)
    ,._ep_branch_req_0 (_br_if_le_req_0)
    ,._ep_stall_req_0 (_stall_le_req_0)
  );
  Decode _spawn_1 (
    .clk_i,
    .rst_ni
    ,._ep_in_req_0 (_if_id_le_req_0)
    ,._ep_out_req_0 (_id_ex_le_req_0)
    ,._ep_wb_req_0 (_wb_id_le_req_0)
    ,._ep_branch_req_0 (_br_id_le_req_0)
    ,._ep_stall_req_0 (_stall_le_req_0)
  );
  Execute _spawn_2 (
    .clk_i,
    .rst_ni
    ,._ep_in_req_0 (_id_ex_le_req_0)
    ,._ep_out_req_0 (_ex_mem_le_req_0)
    ,._ep_wb_req_0 (_wb_ex_le_req_0)
    ,._ep_br_if_req_0 (_br_if_le_req_0)
    ,._ep_br_id_req_0 (_br_id_le_req_0)
  );
  Memory _spawn_3 (
    .clk_i,
    .rst_ni
    ,._ep_in_req_0 (_ex_mem_le_req_0)
    ,._ep_out_req_0 (_mem_wb_le_req_0)
  );
  Writeback _spawn_4 (
    .clk_i,
    .rst_ni
    ,._ep_in_req_0 (_mem_wb_le_req_0)
    ,._ep_id_req_0 (_wb_id_le_req_0)
    ,._ep_ex_req_0 (_wb_ex_le_req_0)
  );
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  for (genvar i = 0; i < 2; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_1_1_q, _thread_0_event_counter_1_1_n;
  assign EVENTS0[1].event_current = _thread_0_event_counter_1_1_q;
  assign _thread_0_event_counter_1_1_n = EVENTS0[0].event_current;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[1].event_current;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      _thread_0_event_counter_1_1_q <= '0;
    end else begin
      _init_0 <= 1'b0;
      _thread_0_event_counter_1_1_q <= _thread_0_event_counter_1_1_n;
    end
  end
endmodule
