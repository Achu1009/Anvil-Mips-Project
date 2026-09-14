/* verilator lint_off UNOPTFLAT */
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHCONCAT */
module Writeback (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _ep_in_req_ack,
  input logic[0:0] _ep_in_req_valid,
  input logic[70:0] _ep_in_req_0,
  input logic[0:0] _ep_id_upd_ack,
  output logic[0:0] _ep_id_upd_valid,
  output logic[37:0] _ep_id_upd_0,
  output logic[0:0] _ep_id_done_ack,
  input logic[0:0] _ep_id_done_valid,
  input logic[0:0] _ep_id_done_0,
  input logic[0:0] _ep_ex_upd_ack,
  output logic[0:0] _ep_ex_upd_valid,
  output logic[37:0] _ep_ex_upd_0,
  output logic[0:0] _ep_ex_done_ack,
  input logic[0:0] _ep_ex_done_valid,
  input logic[0:0] _ep_ex_done_0
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
  logic[0:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$15;
  logic[4:0] thread_0_wire$14;
  logic[31:0] thread_0_wire$13;
  logic[31:0] thread_0_wire$12;
  logic[70:0] thread_0_wire$11;
  logic[0:0] thread_0_wire$10;
  logic[0:0] thread_0_wire$9;
  logic[37:0] thread_0_wire$8;
  logic[4:0] thread_0_wire$7;
  logic[0:0] thread_0_wire$6;
  logic[31:0] thread_0_wire$5;
  logic[31:0] thread_0_wire$4;
  logic[31:0] thread_0_wire$3;
  logic[0:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = mw_m2r_q;
  localparam logic[0:0] thread_0_wire$1 = 1'b1;
  assign thread_0_wire$2 = thread_0_wire$0 == thread_0_wire$1;
  assign thread_0_wire$3 = mw_mdata_q;
  assign thread_0_wire$4 = mw_alu_q;
  assign thread_0_wire$5 = (thread_0_wire$2) ? thread_0_wire$3 : thread_0_wire$4;
  assign thread_0_wire$6 = mw_rw_q;
  assign thread_0_wire$7 = mw_dest_q;
  assign thread_0_wire$8 = {thread_0_wire$5, thread_0_wire$7, thread_0_wire$6};
  assign thread_0_wire$9 = _ep_id_done_0;
  assign thread_0_wire$10 = _ep_ex_done_0;
  assign thread_0_wire$11 = _ep_in_req_0;
  assign thread_0_wire$12 = thread_0_wire$11[39 +: 32];
  assign thread_0_wire$13 = thread_0_wire$11[7 +: 32];
  assign thread_0_wire$14 = thread_0_wire$11[2 +: 5];
  assign thread_0_wire$15 = thread_0_wire$11[1 +: 1];
  assign thread_0_wire$16 = thread_0_wire$11[0 +: 1];
  for (genvar i = 0; i < 7; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_6_1_q, _thread_0_event_counter_6_1_n;
  logic _thread_0_event_syncstate_5_q, _thread_0_event_syncstate_5_n;
  logic _thread_0_event_syncstate_4_q, _thread_0_event_syncstate_4_n;
  logic _thread_0_event_syncstate_3_q, _thread_0_event_syncstate_3_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[6].event_current = _thread_0_event_counter_6_1_q;
  assign _thread_0_event_counter_6_1_n = EVENTS0[5].event_current;
  assign EVENTS0[5].event_current = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_5_n = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q) && !_ep_in_req_valid;
  assign EVENTS0[4].event_current = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && _ep_ex_done_valid;
    assign _thread_0_event_syncstate_4_n = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && !_ep_ex_done_valid;
  assign EVENTS0[3].event_current = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && _ep_id_done_valid;
    assign _thread_0_event_syncstate_3_n = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && !_ep_id_done_valid;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_ex_upd_ack;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_ex_upd_ack;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_id_upd_ack;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_id_upd_ack;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[6].event_current;
  assign _ep_in_req_ack = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q);
  assign _ep_ex_done_ack = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q);
  assign _ep_id_done_ack = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q);
  assign _ep_id_upd_valid = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_id_upd_0 = thread_0_wire$8;
  assign _ep_ex_upd_valid = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_ex_upd_0 = thread_0_wire$8;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      mw_alu_q <= '0;
      mw_dest_q <= '0;
      mw_m2r_q <= '0;
      mw_mdata_q <= '0;
      mw_rw_q <= '0;
      _thread_0_event_counter_6_1_q <= '0;
      _thread_0_event_syncstate_5_q <= '0;
      _thread_0_event_syncstate_4_q <= '0;
      _thread_0_event_syncstate_3_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[5].event_current) begin
        mw_m2r_q[0 +: 1] <= thread_0_wire$16;
        mw_rw_q[0 +: 1] <= thread_0_wire$15;
        mw_dest_q[0 +: 5] <= thread_0_wire$14;
        mw_mdata_q[0 +: 32] <= thread_0_wire$13;
        mw_alu_q[0 +: 32] <= thread_0_wire$12;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_6_1_q <= _thread_0_event_counter_6_1_n;
      _thread_0_event_syncstate_5_q <= _thread_0_event_syncstate_5_n;
      _thread_0_event_syncstate_4_q <= _thread_0_event_syncstate_4_n;
      _thread_0_event_syncstate_3_q <= _thread_0_event_syncstate_3_n;
      _thread_0_event_syncstate_2_q <= _thread_0_event_syncstate_2_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
module DataMemory (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _ep_req_ack,
  input logic[0:0] _ep_req_valid,
  input logic[40:0] _ep_req_0,
  input logic[0:0] _ep_resp_ack,
  output logic[0:0] _ep_resp_valid,
  output logic[31:0] _ep_resp_0
);
  logic[1:0] dly_q;
  logic[0:0] init_done_q;
  logic[7:0] lfsr_q;
  logic[8191:0] mem_q;
  logic[31:0] rdata_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[31:0] thread_0_wire$49;
  logic[0:0] thread_0_wire$48;
  logic[0:0] thread_0_wire$46;
  logic[0:0] thread_0_wire$45;
  logic[0:0] thread_0_wire$43;
  logic[1:0] thread_0_wire$42;
  logic[7:0] thread_0_wire$41;
  logic[0:0] thread_0_wire$40;
  logic[0:0] thread_0_wire$39;
  logic[0:0] thread_0_wire$38;
  logic[0:0] thread_0_wire$37;
  logic[0:0] thread_0_wire$36;
  logic[0:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$34;
  logic[6:0] thread_0_wire$33;
  logic[1:0] thread_0_wire$32;
  logic[31:0] thread_0_wire$31;
  logic[13:0] thread_0_wire$30;
  logic[13:0] thread_0_wire$28;
  logic[12:0] thread_0_wire$26;
  logic[12:0] thread_0_wire$24;
  logic[7:0] thread_0_wire$22;
  logic[8191:0] thread_0_wire$21;
  logic[13:0] thread_0_wire$20;
  logic[13:0] thread_0_wire$18;
  logic[12:0] thread_0_wire$16;
  logic[12:0] thread_0_wire$14;
  logic[7:0] thread_0_wire$12;
  logic[31:0] thread_0_wire$11;
  logic[0:0] thread_0_wire$10;
  logic[0:0] thread_0_wire$8;
  logic[7:0] thread_0_wire$7;
  logic[40:0] thread_0_wire$6;
  logic[0:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = init_done_q;
  localparam logic[0:0] thread_0_wire$1 = 1'b0;
  assign thread_0_wire$2 = thread_0_wire$0 == thread_0_wire$1;
  localparam logic[31:0] thread_0_wire$3 = 32'd20;
  localparam logic[7:0] thread_0_wire$4 = 8'ha5;
  localparam logic[0:0] thread_0_wire$5 = 1'b1;
  assign thread_0_wire$6 = _ep_req_0;
  assign thread_0_wire$7 = lfsr_q;
  assign thread_0_wire$8 = thread_0_wire$6[0 +: 1];
  localparam logic[0:0] thread_0_wire$9 = 1'b1;
  assign thread_0_wire$10 = thread_0_wire$8 == thread_0_wire$9;
  assign thread_0_wire$11 = thread_0_wire$6[1 +: 32];
  assign thread_0_wire$12 = thread_0_wire$6[33 +: 8];
  localparam logic[4:0] thread_0_wire$13 = 5'd0;
  assign thread_0_wire$14 = {thread_0_wire$13, thread_0_wire$12};
  localparam logic[12:0] thread_0_wire$15 = 13'd32;
  assign thread_0_wire$16 = thread_0_wire$14 * thread_0_wire$15;
  localparam logic[0:0] thread_0_wire$17 = 1'd0;
  assign thread_0_wire$18 = {thread_0_wire$17, thread_0_wire$16};
  localparam logic[13:0] thread_0_wire$19 = 14'd0;
  assign thread_0_wire$20 = thread_0_wire$18 + thread_0_wire$19;
  assign thread_0_wire$21 = mem_q;
  assign thread_0_wire$22 = thread_0_wire$6[33 +: 8];
  localparam logic[4:0] thread_0_wire$23 = 5'd0;
  assign thread_0_wire$24 = {thread_0_wire$23, thread_0_wire$22};
  localparam logic[12:0] thread_0_wire$25 = 13'd32;
  assign thread_0_wire$26 = thread_0_wire$24 * thread_0_wire$25;
  localparam logic[0:0] thread_0_wire$27 = 1'd0;
  assign thread_0_wire$28 = {thread_0_wire$27, thread_0_wire$26};
  localparam logic[13:0] thread_0_wire$29 = 14'd0;
  assign thread_0_wire$30 = thread_0_wire$28 + thread_0_wire$29;
  assign thread_0_wire$31 = thread_0_wire$21[thread_0_wire$30 +: 32];
  assign thread_0_wire$32 = thread_0_wire$7[0 +: 2];
  assign thread_0_wire$33 = thread_0_wire$7[0 +: 7];
  assign thread_0_wire$34 = thread_0_wire$7[7 +: 1];
  assign thread_0_wire$35 = thread_0_wire$7[5 +: 1];
  assign thread_0_wire$36 = thread_0_wire$34 ^ thread_0_wire$35;
  assign thread_0_wire$37 = thread_0_wire$7[4 +: 1];
  assign thread_0_wire$38 = thread_0_wire$36 ^ thread_0_wire$37;
  assign thread_0_wire$39 = thread_0_wire$7[3 +: 1];
  assign thread_0_wire$40 = thread_0_wire$38 ^ thread_0_wire$39;
  assign thread_0_wire$41 = {thread_0_wire$33, thread_0_wire$40};
  assign thread_0_wire$42 = dly_q;
  assign thread_0_wire$43 = thread_0_wire$42[1 +: 1];
  localparam logic[0:0] thread_0_wire$44 = 1'b1;
  assign thread_0_wire$45 = thread_0_wire$43 == thread_0_wire$44;
  assign thread_0_wire$46 = thread_0_wire$42[0 +: 1];
  localparam logic[0:0] thread_0_wire$47 = 1'b1;
  assign thread_0_wire$48 = thread_0_wire$46 == thread_0_wire$47;
  assign thread_0_wire$49 = rdata_q;
  for (genvar i = 0; i < 17; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_15_1_q, _thread_0_event_counter_15_1_n;
  logic _thread_0_event_syncstate_13_q, _thread_0_event_syncstate_13_n;
  logic _thread_0_event_counter_11_1_q, _thread_0_event_counter_11_1_n;
  logic[1:0] _thread_0_event_counter_7_q, _thread_0_event_counter_7_n;
  logic _thread_0_event_counter_4_1_q, _thread_0_event_counter_4_1_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  assign EVENTS0[16].event_current = EVENTS0[15].event_current || EVENTS0[13].event_current;
  assign EVENTS0[15].event_current = _thread_0_event_counter_15_1_q;
  assign _thread_0_event_counter_15_1_n = EVENTS0[14].event_current;
  assign EVENTS0[14].event_current = EVENTS0[0].event_current && thread_0_wire$2;
  assign EVENTS0[13].event_current = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) && _ep_resp_ack;
    assign _thread_0_event_syncstate_13_n = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) && !_ep_resp_ack;
  assign EVENTS0[12].event_current = EVENTS0[11].event_current || EVENTS0[9].event_current;
  assign EVENTS0[11].event_current = _thread_0_event_counter_11_1_q;
  assign _thread_0_event_counter_11_1_n = EVENTS0[10].event_current;
  assign EVENTS0[10].event_current = EVENTS0[8].event_current && thread_0_wire$48;
  assign EVENTS0[9].event_current = EVENTS0[8].event_current && !thread_0_wire$48;
  assign EVENTS0[8].event_current = EVENTS0[7].event_current || EVENTS0[5].event_current;
  assign EVENTS0[7].event_current = _thread_0_event_counter_7_q == 2'd2;
    assign _thread_0_event_counter_7_n = EVENTS0[6].event_current ? 2'd1 : EVENTS0[7].event_current ? '0 : _thread_0_event_counter_7_q ? (_thread_0_event_counter_7_q + 2'd1) : _thread_0_event_counter_7_q;
  assign EVENTS0[6].event_current = EVENTS0[4].event_current && thread_0_wire$45;
  assign EVENTS0[5].event_current = EVENTS0[4].event_current && !thread_0_wire$45;
  assign EVENTS0[4].event_current = _thread_0_event_counter_4_1_q;
  assign _thread_0_event_counter_4_1_n = EVENTS0[2].event_current;
  assign EVENTS0[3].event_current = EVENTS0[2].event_current && thread_0_wire$10;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_req_valid;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_req_valid;
  assign EVENTS0[1].event_current = EVENTS0[0].event_current && !thread_0_wire$2;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[16].event_current;
  assign _ep_req_ack = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_resp_valid = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q);
  assign _ep_resp_0 = thread_0_wire$49;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      dly_q <= '0;
      init_done_q <= '0;
      lfsr_q <= '0;
      mem_q <= '0;
      rdata_q <= '0;
      _thread_0_event_counter_15_1_q <= '0;
      _thread_0_event_syncstate_13_q <= '0;
      _thread_0_event_counter_11_1_q <= '0;
      _thread_0_event_counter_7_q <= '0;
      _thread_0_event_counter_4_1_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
    end else begin
      if (EVENTS0[14].event_current) begin
        init_done_q[0 +: 1] <= thread_0_wire$5;
        lfsr_q[0 +: 8] <= thread_0_wire$4;
        mem_q[0 +: 32] <= thread_0_wire$3;
      end
      if (EVENTS0[3].event_current) begin
        mem_q[thread_0_wire$20 +: 32] <= thread_0_wire$11;
      end
      if (EVENTS0[2].event_current) begin
        lfsr_q[0 +: 8] <= thread_0_wire$41;
        dly_q[0 +: 2] <= thread_0_wire$32;
        rdata_q[0 +: 32] <= thread_0_wire$31;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_15_1_q <= _thread_0_event_counter_15_1_n;
      _thread_0_event_syncstate_13_q <= _thread_0_event_syncstate_13_n;
      _thread_0_event_counter_11_1_q <= _thread_0_event_counter_11_1_n;
      _thread_0_event_counter_7_q <= _thread_0_event_counter_7_n;
      _thread_0_event_counter_4_1_q <= _thread_0_event_counter_4_1_n;
      _thread_0_event_syncstate_2_q <= _thread_0_event_syncstate_2_n;
    end
  end
endmodule
module Memory (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _ep_in_req_ack,
  input logic[0:0] _ep_in_req_valid,
  input logic[72:0] _ep_in_req_0,
  input logic[0:0] _ep_out_req_ack,
  output logic[0:0] _ep_out_req_valid,
  output logic[70:0] _ep_out_req_0,
  input logic[0:0] _ep_dm_req_ack,
  output logic[0:0] _ep_dm_req_valid,
  output logic[40:0] _ep_dm_req_0,
  output logic[0:0] _ep_dm_resp_ack,
  input logic[0:0] _ep_dm_resp_valid,
  input logic[31:0] _ep_dm_resp_0
);
  logic[31:0] em_alu_q;
  logic[4:0] em_dest_q;
  logic[0:0] em_m2r_q;
  logic[0:0] em_mr_q;
  logic[0:0] em_mw_q;
  logic[0:0] em_rw_q;
  logic[31:0] em_wdata_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$24;
  logic[0:0] thread_0_wire$23;
  logic[0:0] thread_0_wire$22;
  logic[0:0] thread_0_wire$21;
  logic[4:0] thread_0_wire$20;
  logic[31:0] thread_0_wire$19;
  logic[31:0] thread_0_wire$18;
  logic[72:0] thread_0_wire$17;
  logic[70:0] thread_0_wire$16;
  logic[4:0] thread_0_wire$15;
  logic[0:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$13;
  logic[31:0] thread_0_wire$12;
  logic[31:0] thread_0_wire$10;
  logic[40:0] thread_0_wire$9;
  logic[31:0] thread_0_wire$8;
  logic[0:0] thread_0_wire$7;
  logic[0:0] thread_0_wire$6;
  logic[0:0] thread_0_wire$4;
  logic[0:0] thread_0_wire$3;
  logic[0:0] thread_0_wire$2;
  logic[7:0] thread_0_wire$1;
  logic[31:0] thread_0_wire$0;
  assign thread_0_wire$0 = em_alu_q;
  assign thread_0_wire$1 = thread_0_wire$0[2 +: 8];
  assign thread_0_wire$2 = em_mr_q;
  assign thread_0_wire$3 = em_mw_q;
  assign thread_0_wire$4 = thread_0_wire$2 | thread_0_wire$3;
  localparam logic[0:0] thread_0_wire$5 = 1'b1;
  assign thread_0_wire$6 = thread_0_wire$4 == thread_0_wire$5;
  assign thread_0_wire$7 = em_mw_q;
  assign thread_0_wire$8 = em_wdata_q;
  assign thread_0_wire$9 = {thread_0_wire$1, thread_0_wire$8, thread_0_wire$7};
  assign thread_0_wire$10 = _ep_dm_resp_0;
  localparam logic[31:0] thread_0_wire$11 = 32'd0;
  assign thread_0_wire$12 = (thread_0_wire$6) ? thread_0_wire$10 : thread_0_wire$11;
  assign thread_0_wire$13 = em_m2r_q;
  assign thread_0_wire$14 = em_rw_q;
  assign thread_0_wire$15 = em_dest_q;
  assign thread_0_wire$16 = {thread_0_wire$0, thread_0_wire$12, thread_0_wire$15, thread_0_wire$14, thread_0_wire$13};
  assign thread_0_wire$17 = _ep_in_req_0;
  assign thread_0_wire$18 = thread_0_wire$17[41 +: 32];
  assign thread_0_wire$19 = thread_0_wire$17[9 +: 32];
  assign thread_0_wire$20 = thread_0_wire$17[4 +: 5];
  assign thread_0_wire$21 = thread_0_wire$17[3 +: 1];
  assign thread_0_wire$22 = thread_0_wire$17[2 +: 1];
  assign thread_0_wire$23 = thread_0_wire$17[1 +: 1];
  assign thread_0_wire$24 = thread_0_wire$17[0 +: 1];
  for (genvar i = 0; i < 11; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic[1:0] _thread_0_event_reg_10_q, _thread_0_event_reg_10_n;
  logic _thread_0_event_counter_9_1_q, _thread_0_event_counter_9_1_n;
  logic _thread_0_event_syncstate_8_q, _thread_0_event_syncstate_8_n;
  logic _thread_0_event_counter_7_1_q, _thread_0_event_counter_7_1_n;
  logic _thread_0_event_syncstate_6_q, _thread_0_event_syncstate_6_n;
  logic _thread_0_event_syncstate_4_q, _thread_0_event_syncstate_4_n;
  logic _thread_0_event_syncstate_3_q, _thread_0_event_syncstate_3_n;
  assign EVENTS0[10].event_current = (EVENTS0[9].event_current & _thread_0_event_reg_10_q[0]) | (EVENTS0[7].event_current & _thread_0_event_reg_10_q[1]) | (EVENTS0[9].event_current & EVENTS0[7].event_current);
    assign _thread_0_event_reg_10_n = _thread_0_event_reg_10_q ^ {EVENTS0[9].event_current, EVENTS0[7].event_current} ^ {EVENTS0[10].event_current, EVENTS0[10].event_current};
  assign EVENTS0[9].event_current = _thread_0_event_counter_9_1_q;
  assign _thread_0_event_counter_9_1_n = EVENTS0[8].event_current;
  assign EVENTS0[8].event_current = (EVENTS0[5].event_current || _thread_0_event_syncstate_8_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_8_n = (EVENTS0[5].event_current || _thread_0_event_syncstate_8_q) && !_ep_out_req_ack;
  assign EVENTS0[7].event_current = _thread_0_event_counter_7_1_q;
  assign _thread_0_event_counter_7_1_n = EVENTS0[6].event_current;
  assign EVENTS0[6].event_current = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_6_n = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q) && !_ep_in_req_valid;
  assign EVENTS0[5].event_current = EVENTS0[4].event_current || EVENTS0[1].event_current;
  assign EVENTS0[4].event_current = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && _ep_dm_resp_valid;
    assign _thread_0_event_syncstate_4_n = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && !_ep_dm_resp_valid;
  assign EVENTS0[3].event_current = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && _ep_dm_req_ack;
    assign _thread_0_event_syncstate_3_n = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && !_ep_dm_req_ack;
  assign EVENTS0[2].event_current = EVENTS0[0].event_current && thread_0_wire$6;
  assign EVENTS0[1].event_current = EVENTS0[0].event_current && !thread_0_wire$6;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[10].event_current;
  assign _ep_in_req_ack = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q);
  assign _ep_dm_resp_ack = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q);
  assign _ep_out_req_valid = (EVENTS0[5].event_current || _thread_0_event_syncstate_8_q);
  assign _ep_out_req_0 = thread_0_wire$16;
  assign _ep_dm_req_valid = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q);
  assign _ep_dm_req_0 = thread_0_wire$9;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      em_alu_q <= '0;
      em_dest_q <= '0;
      em_m2r_q <= '0;
      em_mr_q <= '0;
      em_mw_q <= '0;
      em_rw_q <= '0;
      em_wdata_q <= '0;
      _thread_0_event_reg_10_q <= '0;
      _thread_0_event_counter_9_1_q <= '0;
      _thread_0_event_syncstate_8_q <= '0;
      _thread_0_event_counter_7_1_q <= '0;
      _thread_0_event_syncstate_6_q <= '0;
      _thread_0_event_syncstate_4_q <= '0;
      _thread_0_event_syncstate_3_q <= '0;
    end else begin
      if (EVENTS0[6].event_current) begin
        em_m2r_q[0 +: 1] <= thread_0_wire$24;
        em_rw_q[0 +: 1] <= thread_0_wire$23;
        em_mw_q[0 +: 1] <= thread_0_wire$22;
        em_mr_q[0 +: 1] <= thread_0_wire$21;
        em_dest_q[0 +: 5] <= thread_0_wire$20;
        em_wdata_q[0 +: 32] <= thread_0_wire$19;
        em_alu_q[0 +: 32] <= thread_0_wire$18;
      end
      _init_0 <= 1'b0;
      _thread_0_event_reg_10_q <= _thread_0_event_reg_10_n;
      _thread_0_event_counter_9_1_q <= _thread_0_event_counter_9_1_n;
      _thread_0_event_syncstate_8_q <= _thread_0_event_syncstate_8_n;
      _thread_0_event_counter_7_1_q <= _thread_0_event_counter_7_1_n;
      _thread_0_event_syncstate_6_q <= _thread_0_event_syncstate_6_n;
      _thread_0_event_syncstate_4_q <= _thread_0_event_syncstate_4_n;
      _thread_0_event_syncstate_3_q <= _thread_0_event_syncstate_3_n;
    end
  end
endmodule
module Execute (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _ep_in_req_ack,
  input logic[0:0] _ep_in_req_valid,
  input logic[151:0] _ep_in_req_0,
  input logic[0:0] _ep_out_req_ack,
  output logic[0:0] _ep_out_req_valid,
  output logic[72:0] _ep_out_req_0,
  output logic[0:0] _ep_wb_upd_ack,
  input logic[0:0] _ep_wb_upd_valid,
  input logic[37:0] _ep_wb_upd_0,
  input logic[0:0] _ep_wb_done_ack,
  output logic[0:0] _ep_wb_done_valid,
  output logic[0:0] _ep_wb_done_0,
  input logic[0:0] _ep_br_if_upd_ack,
  output logic[0:0] _ep_br_if_upd_valid,
  output logic[32:0] _ep_br_if_upd_0,
  input logic[0:0] _ep_br_id_upd_ack,
  output logic[0:0] _ep_br_id_upd_valid,
  output logic[32:0] _ep_br_id_upd_0
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
  logic[0:0] thread_0_wire$105;
  logic[0:0] thread_0_wire$104;
  logic[0:0] thread_0_wire$103;
  logic[0:0] thread_0_wire$102;
  logic[4:0] thread_0_wire$101;
  logic[4:0] thread_0_wire$100;
  logic[4:0] thread_0_wire$99;
  logic[31:0] thread_0_wire$98;
  logic[31:0] thread_0_wire$97;
  logic[31:0] thread_0_wire$96;
  logic[31:0] thread_0_wire$95;
  logic[0:0] thread_0_wire$94;
  logic[0:0] thread_0_wire$93;
  logic[0:0] thread_0_wire$92;
  logic[0:0] thread_0_wire$90;
  logic[0:0] thread_0_wire$88;
  logic[0:0] thread_0_wire$87;
  logic[0:0] thread_0_wire$85;
  logic[0:0] thread_0_wire$83;
  logic[0:0] thread_0_wire$82;
  logic[0:0] thread_0_wire$80;
  logic[0:0] thread_0_wire$78;
  logic[0:0] thread_0_wire$77;
  logic[0:0] thread_0_wire$75;
  logic[151:0] thread_0_wire$72;
  logic[72:0] thread_0_wire$71;
  logic[0:0] thread_0_wire$70;
  logic[0:0] thread_0_wire$69;
  logic[0:0] thread_0_wire$68;
  logic[0:0] thread_0_wire$67;
  logic[32:0] thread_0_wire$66;
  logic[0:0] thread_0_wire$65;
  logic[0:0] thread_0_wire$64;
  logic[0:0] thread_0_wire$62;
  logic[31:0] thread_0_wire$61;
  logic[31:0] thread_0_wire$59;
  logic[4:0] thread_0_wire$58;
  logic[4:0] thread_0_wire$57;
  logic[0:0] thread_0_wire$56;
  logic[0:0] thread_0_wire$54;
  logic[31:0] thread_0_wire$53;
  logic[31:0] thread_0_wire$52;
  logic[31:0] thread_0_wire$51;
  logic[0:0] thread_0_wire$50;
  logic[0:0] thread_0_wire$48;
  logic[31:0] thread_0_wire$47;
  logic[31:0] thread_0_wire$46;
  logic[0:0] thread_0_wire$45;
  logic[0:0] thread_0_wire$43;
  logic[31:0] thread_0_wire$42;
  logic[0:0] thread_0_wire$41;
  logic[31:0] thread_0_wire$39;
  logic[31:0] thread_0_wire$38;
  logic[31:0] thread_0_wire$37;
  logic[0:0] thread_0_wire$36;
  logic[0:0] thread_0_wire$34;
  logic[0:0] thread_0_wire$33;
  logic[4:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$31;
  logic[0:0] thread_0_wire$30;
  logic[0:0] thread_0_wire$29;
  logic[0:0] thread_0_wire$28;
  logic[0:0] thread_0_wire$27;
  logic[31:0] thread_0_wire$26;
  logic[0:0] thread_0_wire$25;
  logic[31:0] thread_0_wire$23;
  logic[31:0] thread_0_wire$22;
  logic[31:0] thread_0_wire$21;
  logic[0:0] thread_0_wire$20;
  logic[0:0] thread_0_wire$18;
  logic[0:0] thread_0_wire$17;
  logic[4:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$15;
  logic[0:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$13;
  logic[0:0] thread_0_wire$12;
  logic[0:0] thread_0_wire$11;
  logic[0:0] thread_0_wire$10;
  logic[4:0] thread_0_wire$8;
  logic[0:0] thread_0_wire$7;
  logic[31:0] thread_0_wire$5;
  logic[0:0] thread_0_wire$4;
  logic[4:0] thread_0_wire$3;
  logic[4:0] thread_0_wire$2;
  logic[4:0] thread_0_wire$1;
  logic[37:0] thread_0_wire$0;
  assign thread_0_wire$0 = _ep_wb_upd_0;
  assign thread_0_wire$1 = ix_rs_q;
  assign thread_0_wire$2 = ix_rt_q;
  assign thread_0_wire$3 = fw_rd_q;
  assign thread_0_wire$4 = fw_we_q;
  assign thread_0_wire$5 = fw_data_q;
  localparam logic[4:0] thread_0_wire$6 = 5'd0;
  assign thread_0_wire$7 = thread_0_wire$3 != thread_0_wire$6;
  assign thread_0_wire$8 = thread_0_wire$0[1 +: 5];
  localparam logic[4:0] thread_0_wire$9 = 5'd0;
  assign thread_0_wire$10 = thread_0_wire$8 != thread_0_wire$9;
  assign thread_0_wire$11 = thread_0_wire$4 & thread_0_wire$7;
  assign thread_0_wire$12 = thread_0_wire$3 == thread_0_wire$1;
  assign thread_0_wire$13 = thread_0_wire$11 & thread_0_wire$12;
  assign thread_0_wire$14 = thread_0_wire$0[0 +: 1];
  assign thread_0_wire$15 = thread_0_wire$14 & thread_0_wire$10;
  assign thread_0_wire$16 = thread_0_wire$0[1 +: 5];
  assign thread_0_wire$17 = thread_0_wire$16 == thread_0_wire$1;
  assign thread_0_wire$18 = thread_0_wire$15 & thread_0_wire$17;
  localparam logic[0:0] thread_0_wire$19 = 1'b1;
  assign thread_0_wire$20 = thread_0_wire$18 == thread_0_wire$19;
  assign thread_0_wire$21 = thread_0_wire$0[6 +: 32];
  assign thread_0_wire$22 = ix_rd1_q;
  assign thread_0_wire$23 = (thread_0_wire$20) ? thread_0_wire$21 : thread_0_wire$22;
  localparam logic[0:0] thread_0_wire$24 = 1'b1;
  assign thread_0_wire$25 = thread_0_wire$13 == thread_0_wire$24;
  assign thread_0_wire$26 = (thread_0_wire$25) ? thread_0_wire$5 : thread_0_wire$23;
  assign thread_0_wire$27 = thread_0_wire$4 & thread_0_wire$7;
  assign thread_0_wire$28 = thread_0_wire$3 == thread_0_wire$2;
  assign thread_0_wire$29 = thread_0_wire$27 & thread_0_wire$28;
  assign thread_0_wire$30 = thread_0_wire$0[0 +: 1];
  assign thread_0_wire$31 = thread_0_wire$30 & thread_0_wire$10;
  assign thread_0_wire$32 = thread_0_wire$0[1 +: 5];
  assign thread_0_wire$33 = thread_0_wire$32 == thread_0_wire$2;
  assign thread_0_wire$34 = thread_0_wire$31 & thread_0_wire$33;
  localparam logic[0:0] thread_0_wire$35 = 1'b1;
  assign thread_0_wire$36 = thread_0_wire$34 == thread_0_wire$35;
  assign thread_0_wire$37 = thread_0_wire$0[6 +: 32];
  assign thread_0_wire$38 = ix_rd2_q;
  assign thread_0_wire$39 = (thread_0_wire$36) ? thread_0_wire$37 : thread_0_wire$38;
  localparam logic[0:0] thread_0_wire$40 = 1'b1;
  assign thread_0_wire$41 = thread_0_wire$29 == thread_0_wire$40;
  assign thread_0_wire$42 = (thread_0_wire$41) ? thread_0_wire$5 : thread_0_wire$39;
  assign thread_0_wire$43 = ix_alu_src_q;
  localparam logic[0:0] thread_0_wire$44 = 1'b1;
  assign thread_0_wire$45 = thread_0_wire$43 == thread_0_wire$44;
  assign thread_0_wire$46 = ix_imm_q;
  assign thread_0_wire$47 = (thread_0_wire$45) ? thread_0_wire$46 : thread_0_wire$42;
  assign thread_0_wire$48 = ix_alu_sub_q;
  localparam logic[0:0] thread_0_wire$49 = 1'b1;
  assign thread_0_wire$50 = thread_0_wire$48 == thread_0_wire$49;
  assign thread_0_wire$51 = thread_0_wire$26 - thread_0_wire$47;
  assign thread_0_wire$52 = thread_0_wire$26 + thread_0_wire$47;
  assign thread_0_wire$53 = (thread_0_wire$50) ? thread_0_wire$51 : thread_0_wire$52;
  assign thread_0_wire$54 = ix_reg_dst_q;
  localparam logic[0:0] thread_0_wire$55 = 1'b1;
  assign thread_0_wire$56 = thread_0_wire$54 == thread_0_wire$55;
  assign thread_0_wire$57 = ix_rd_q;
  assign thread_0_wire$58 = (thread_0_wire$56) ? thread_0_wire$57 : thread_0_wire$2;
  assign thread_0_wire$59 = ix_addr21_q;
  localparam logic[31:0] thread_0_wire$60 = 32'd2;
  assign thread_0_wire$61 = thread_0_wire$59 << thread_0_wire$60;
  assign thread_0_wire$62 = ix_branch_zero_q;
  localparam logic[31:0] thread_0_wire$63 = 32'd0;
  assign thread_0_wire$64 = thread_0_wire$26 == thread_0_wire$63;
  assign thread_0_wire$65 = thread_0_wire$62 & thread_0_wire$64;
  assign thread_0_wire$66 = {thread_0_wire$65, thread_0_wire$61};
  assign thread_0_wire$67 = ix_mem_to_reg_q;
  assign thread_0_wire$68 = ix_reg_write_q;
  assign thread_0_wire$69 = ix_mem_write_q;
  assign thread_0_wire$70 = ix_mem_read_q;
  assign thread_0_wire$71 = {thread_0_wire$53, thread_0_wire$42, thread_0_wire$58, thread_0_wire$70, thread_0_wire$69, thread_0_wire$68, thread_0_wire$67};
  assign thread_0_wire$72 = _ep_in_req_0;
  localparam logic[0:0] thread_0_wire$73 = 1'b1;
  localparam logic[0:0] thread_0_wire$74 = 1'b1;
  assign thread_0_wire$75 = thread_0_wire$65 == thread_0_wire$74;
  localparam logic[0:0] thread_0_wire$76 = 1'b0;
  assign thread_0_wire$77 = thread_0_wire$72[3 +: 1];
  assign thread_0_wire$78 = (thread_0_wire$75) ? thread_0_wire$76 : thread_0_wire$77;
  localparam logic[0:0] thread_0_wire$79 = 1'b1;
  assign thread_0_wire$80 = thread_0_wire$65 == thread_0_wire$79;
  localparam logic[0:0] thread_0_wire$81 = 1'b0;
  assign thread_0_wire$82 = thread_0_wire$72[5 +: 1];
  assign thread_0_wire$83 = (thread_0_wire$80) ? thread_0_wire$81 : thread_0_wire$82;
  localparam logic[0:0] thread_0_wire$84 = 1'b1;
  assign thread_0_wire$85 = thread_0_wire$65 == thread_0_wire$84;
  localparam logic[0:0] thread_0_wire$86 = 1'b0;
  assign thread_0_wire$87 = thread_0_wire$72[4 +: 1];
  assign thread_0_wire$88 = (thread_0_wire$85) ? thread_0_wire$86 : thread_0_wire$87;
  localparam logic[0:0] thread_0_wire$89 = 1'b1;
  assign thread_0_wire$90 = thread_0_wire$65 == thread_0_wire$89;
  localparam logic[0:0] thread_0_wire$91 = 1'b0;
  assign thread_0_wire$92 = thread_0_wire$72[1 +: 1];
  assign thread_0_wire$93 = (thread_0_wire$90) ? thread_0_wire$91 : thread_0_wire$92;
  assign thread_0_wire$94 = ix_reg_write_q;
  assign thread_0_wire$95 = thread_0_wire$72[120 +: 32];
  assign thread_0_wire$96 = thread_0_wire$72[88 +: 32];
  assign thread_0_wire$97 = thread_0_wire$72[56 +: 32];
  assign thread_0_wire$98 = thread_0_wire$72[24 +: 32];
  assign thread_0_wire$99 = thread_0_wire$72[19 +: 5];
  assign thread_0_wire$100 = thread_0_wire$72[14 +: 5];
  assign thread_0_wire$101 = thread_0_wire$72[9 +: 5];
  assign thread_0_wire$102 = thread_0_wire$72[8 +: 1];
  assign thread_0_wire$103 = thread_0_wire$72[7 +: 1];
  assign thread_0_wire$104 = thread_0_wire$72[6 +: 1];
  assign thread_0_wire$105 = thread_0_wire$72[2 +: 1];
  for (genvar i = 0; i < 12; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic[1:0] _thread_0_event_reg_11_q, _thread_0_event_reg_11_n;
  logic _thread_0_event_counter_10_1_q, _thread_0_event_counter_10_1_n;
  logic _thread_0_event_syncstate_9_q, _thread_0_event_syncstate_9_n;
  logic[1:0] _thread_0_event_reg_8_q, _thread_0_event_reg_8_n;
  logic _thread_0_event_counter_7_1_q, _thread_0_event_counter_7_1_n;
  logic _thread_0_event_syncstate_6_q, _thread_0_event_syncstate_6_n;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_syncstate_4_q, _thread_0_event_syncstate_4_n;
  logic _thread_0_event_syncstate_3_q, _thread_0_event_syncstate_3_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[11].event_current = (EVENTS0[10].event_current & _thread_0_event_reg_11_q[0]) | (EVENTS0[8].event_current & _thread_0_event_reg_11_q[1]) | (EVENTS0[10].event_current & EVENTS0[8].event_current);
    assign _thread_0_event_reg_11_n = _thread_0_event_reg_11_q ^ {EVENTS0[10].event_current, EVENTS0[8].event_current} ^ {EVENTS0[11].event_current, EVENTS0[11].event_current};
  assign EVENTS0[10].event_current = _thread_0_event_counter_10_1_q;
  assign _thread_0_event_counter_10_1_n = EVENTS0[9].event_current;
  assign EVENTS0[9].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_9_q) && _ep_br_if_upd_ack;
    assign _thread_0_event_syncstate_9_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_9_q) && !_ep_br_if_upd_ack;
  assign EVENTS0[8].event_current = (EVENTS0[7].event_current & _thread_0_event_reg_8_q[0]) | (EVENTS0[5].event_current & _thread_0_event_reg_8_q[1]) | (EVENTS0[7].event_current & EVENTS0[5].event_current);
    assign _thread_0_event_reg_8_n = _thread_0_event_reg_8_q ^ {EVENTS0[7].event_current, EVENTS0[5].event_current} ^ {EVENTS0[8].event_current, EVENTS0[8].event_current};
  assign EVENTS0[7].event_current = _thread_0_event_counter_7_1_q;
  assign _thread_0_event_counter_7_1_n = EVENTS0[6].event_current;
  assign EVENTS0[6].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_6_q) && _ep_br_id_upd_ack;
    assign _thread_0_event_syncstate_6_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_6_q) && !_ep_br_id_upd_ack;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && _ep_wb_done_ack;
    assign _thread_0_event_syncstate_4_n = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && !_ep_wb_done_ack;
  assign EVENTS0[3].event_current = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_3_n = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && !_ep_in_req_valid;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_out_req_ack;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_wb_upd_valid;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_wb_upd_valid;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[11].event_current;
  assign _ep_in_req_ack = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q);
  assign _ep_wb_upd_ack = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_wb_done_valid = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q);
  assign _ep_wb_done_0 = thread_0_wire$73;
  assign _ep_out_req_valid = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_out_req_0 = thread_0_wire$71;
  assign _ep_br_id_upd_valid = (EVENTS0[1].event_current || _thread_0_event_syncstate_6_q);
  assign _ep_br_id_upd_0 = thread_0_wire$66;
  assign _ep_br_if_upd_valid = (EVENTS0[1].event_current || _thread_0_event_syncstate_9_q);
  assign _ep_br_if_upd_0 = thread_0_wire$66;
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
      _thread_0_event_reg_11_q <= '0;
      _thread_0_event_counter_10_1_q <= '0;
      _thread_0_event_syncstate_9_q <= '0;
      _thread_0_event_reg_8_q <= '0;
      _thread_0_event_counter_7_1_q <= '0;
      _thread_0_event_syncstate_6_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_syncstate_4_q <= '0;
      _thread_0_event_syncstate_3_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[3].event_current) begin
        ix_branch_zero_q[0 +: 1] <= thread_0_wire$93;
        ix_mem_to_reg_q[0 +: 1] <= thread_0_wire$105;
        ix_reg_write_q[0 +: 1] <= thread_0_wire$78;
        ix_mem_write_q[0 +: 1] <= thread_0_wire$88;
        ix_mem_read_q[0 +: 1] <= thread_0_wire$83;
        ix_reg_dst_q[0 +: 1] <= thread_0_wire$104;
        ix_alu_src_q[0 +: 1] <= thread_0_wire$103;
        ix_alu_sub_q[0 +: 1] <= thread_0_wire$102;
        ix_rd_q[0 +: 5] <= thread_0_wire$101;
        ix_rt_q[0 +: 5] <= thread_0_wire$100;
        ix_rs_q[0 +: 5] <= thread_0_wire$99;
        ix_addr21_q[0 +: 32] <= thread_0_wire$98;
        ix_imm_q[0 +: 32] <= thread_0_wire$97;
        ix_rd2_q[0 +: 32] <= thread_0_wire$96;
        ix_rd1_q[0 +: 32] <= thread_0_wire$95;
        fw_data_q[0 +: 32] <= thread_0_wire$53;
        fw_we_q[0 +: 1] <= thread_0_wire$94;
        fw_rd_q[0 +: 5] <= thread_0_wire$58;
      end
      _init_0 <= 1'b0;
      _thread_0_event_reg_11_q <= _thread_0_event_reg_11_n;
      _thread_0_event_counter_10_1_q <= _thread_0_event_counter_10_1_n;
      _thread_0_event_syncstate_9_q <= _thread_0_event_syncstate_9_n;
      _thread_0_event_reg_8_q <= _thread_0_event_reg_8_n;
      _thread_0_event_counter_7_1_q <= _thread_0_event_counter_7_1_n;
      _thread_0_event_syncstate_6_q <= _thread_0_event_syncstate_6_n;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_syncstate_4_q <= _thread_0_event_syncstate_4_n;
      _thread_0_event_syncstate_3_q <= _thread_0_event_syncstate_3_n;
      _thread_0_event_syncstate_2_q <= _thread_0_event_syncstate_2_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
module Decode (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _ep_in_req_ack,
  input logic[0:0] _ep_in_req_valid,
  input logic[64:0] _ep_in_req_0,
  input logic[0:0] _ep_out_req_ack,
  output logic[0:0] _ep_out_req_valid,
  output logic[151:0] _ep_out_req_0,
  output logic[0:0] _ep_wb_upd_ack,
  input logic[0:0] _ep_wb_upd_valid,
  input logic[37:0] _ep_wb_upd_0,
  input logic[0:0] _ep_wb_done_ack,
  output logic[0:0] _ep_wb_done_valid,
  output logic[0:0] _ep_wb_done_0,
  output logic[0:0] _ep_branch_upd_ack,
  input logic[0:0] _ep_branch_upd_valid,
  input logic[32:0] _ep_branch_upd_0,
  input logic[0:0] _ep_stall_upd_ack,
  output logic[0:0] _ep_stall_upd_valid,
  output logic[0:0] _ep_stall_upd_0
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
  logic[31:0] thread_0_wire$126;
  logic[31:0] thread_0_wire$125;
  logic[0:0] thread_0_wire$124;
  logic[0:0] thread_0_wire$122;
  logic[0:0] thread_0_wire$121;
  logic[31:0] thread_0_wire$119;
  logic[0:0] thread_0_wire$118;
  logic[0:0] thread_0_wire$116;
  logic[0:0] thread_0_wire$115;
  logic[0:0] thread_0_wire$113;
  logic[31:0] thread_0_wire$111;
  logic[31:0] thread_0_wire$110;
  logic[0:0] thread_0_wire$108;
  logic[0:0] thread_0_wire$106;
  logic[64:0] thread_0_wire$104;
  logic[32:0] thread_0_wire$103;
  logic[151:0] thread_0_wire$102;
  logic[0:0] thread_0_wire$101;
  logic[0:0] thread_0_wire$100;
  logic[0:0] thread_0_wire$99;
  logic[0:0] thread_0_wire$98;
  logic[0:0] thread_0_wire$97;
  logic[0:0] thread_0_wire$96;
  logic[31:0] thread_0_wire$95;
  logic[4:0] thread_0_wire$94;
  logic[0:0] thread_0_wire$93;
  logic[0:0] thread_0_wire$92;
  logic[0:0] thread_0_wire$91;
  logic[0:0] thread_0_wire$90;
  logic[0:0] thread_0_wire$88;
  logic[31:0] thread_0_wire$86;
  logic[31:0] thread_0_wire$84;
  logic[31:0] thread_0_wire$83;
  logic[0:0] thread_0_wire$81;
  logic[31:0] thread_0_wire$79;
  logic[0:0] thread_0_wire$77;
  logic[31:0] thread_0_wire$76;
  logic[31:0] thread_0_wire$75;
  logic[0:0] thread_0_wire$74;
  logic[31:0] thread_0_wire$72;
  logic[31:0] thread_0_wire$71;
  logic[0:0] thread_0_wire$70;
  logic[31:0] thread_0_wire$68;
  logic[10:0] thread_0_wire$67;
  logic[10:0] thread_0_wire$65;
  logic[9:0] thread_0_wire$63;
  logic[9:0] thread_0_wire$61;
  logic[1023:0] thread_0_wire$59;
  logic[31:0] thread_0_wire$58;
  logic[10:0] thread_0_wire$57;
  logic[10:0] thread_0_wire$55;
  logic[9:0] thread_0_wire$53;
  logic[9:0] thread_0_wire$51;
  logic[1023:0] thread_0_wire$49;
  logic[0:0] thread_0_wire$48;
  logic[0:0] thread_0_wire$47;
  logic[4:0] thread_0_wire$46;
  logic[0:0] thread_0_wire$45;
  logic[0:0] thread_0_wire$44;
  logic[0:0] thread_0_wire$43;
  logic[0:0] thread_0_wire$42;
  logic[4:0] thread_0_wire$41;
  logic[0:0] thread_0_wire$40;
  logic[0:0] thread_0_wire$39;
  logic[0:0] thread_0_wire$38;
  logic[4:0] thread_0_wire$36;
  logic[0:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$34;
  logic[0:0] thread_0_wire$33;
  logic[0:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$31;
  logic[0:0] thread_0_wire$30;
  logic[0:0] thread_0_wire$29;
  logic[0:0] thread_0_wire$28;
  logic[0:0] thread_0_wire$27;
  logic[0:0] thread_0_wire$26;
  logic[4:0] thread_0_wire$24;
  logic[0:0] thread_0_wire$23;
  logic[0:0] thread_0_wire$22;
  logic[0:0] thread_0_wire$21;
  logic[0:0] thread_0_wire$20;
  logic[0:0] thread_0_wire$19;
  logic[0:0] thread_0_wire$18;
  logic[0:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$12;
  logic[0:0] thread_0_wire$10;
  logic[4:0] thread_0_wire$8;
  logic[4:0] thread_0_wire$7;
  logic[4:0] thread_0_wire$6;
  logic[5:0] thread_0_wire$5;
  logic[5:0] thread_0_wire$4;
  logic[31:0] thread_0_wire$3;
  logic[0:0] thread_0_wire$2;
  logic[31:0] thread_0_wire$1;
  logic[37:0] thread_0_wire$0;
  assign thread_0_wire$0 = _ep_wb_upd_0;
  assign thread_0_wire$1 = ifid_instr_q;
  assign thread_0_wire$2 = ifid_valid_q;
  assign thread_0_wire$3 = ifid_pc_q;
  assign thread_0_wire$4 = thread_0_wire$1[26 +: 6];
  assign thread_0_wire$5 = thread_0_wire$1[0 +: 6];
  assign thread_0_wire$6 = thread_0_wire$1[21 +: 5];
  assign thread_0_wire$7 = thread_0_wire$1[16 +: 5];
  assign thread_0_wire$8 = thread_0_wire$1[11 +: 5];
  localparam logic[5:0] thread_0_wire$9 = 6'b000000;
  assign thread_0_wire$10 = thread_0_wire$4 == thread_0_wire$9;
  localparam logic[5:0] thread_0_wire$11 = 6'b100011;
  assign thread_0_wire$12 = thread_0_wire$4 == thread_0_wire$11;
  localparam logic[5:0] thread_0_wire$13 = 6'b101011;
  assign thread_0_wire$14 = thread_0_wire$4 == thread_0_wire$13;
  localparam logic[5:0] thread_0_wire$15 = 6'b000010;
  assign thread_0_wire$16 = thread_0_wire$4 == thread_0_wire$15;
  localparam logic[5:0] thread_0_wire$17 = 6'b100010;
  assign thread_0_wire$18 = thread_0_wire$5 == thread_0_wire$17;
  assign thread_0_wire$19 = thread_0_wire$10 & thread_0_wire$18;
  assign thread_0_wire$20 = thread_0_wire$10 | thread_0_wire$12;
  assign thread_0_wire$21 = thread_0_wire$20 | thread_0_wire$14;
  assign thread_0_wire$22 = thread_0_wire$21 | thread_0_wire$16;
  assign thread_0_wire$23 = thread_0_wire$10 | thread_0_wire$14;
  assign thread_0_wire$24 = sh_rt_q;
  localparam logic[4:0] thread_0_wire$25 = 5'd0;
  assign thread_0_wire$26 = thread_0_wire$24 != thread_0_wire$25;
  assign thread_0_wire$27 = thread_0_wire$24 == thread_0_wire$6;
  assign thread_0_wire$28 = thread_0_wire$22 & thread_0_wire$27;
  assign thread_0_wire$29 = thread_0_wire$24 == thread_0_wire$7;
  assign thread_0_wire$30 = thread_0_wire$23 & thread_0_wire$29;
  assign thread_0_wire$31 = sh_mem_read_q;
  assign thread_0_wire$32 = thread_0_wire$31 & thread_0_wire$26;
  assign thread_0_wire$33 = thread_0_wire$32 & thread_0_wire$2;
  assign thread_0_wire$34 = thread_0_wire$28 | thread_0_wire$30;
  assign thread_0_wire$35 = thread_0_wire$33 & thread_0_wire$34;
  assign thread_0_wire$36 = thread_0_wire$0[1 +: 5];
  localparam logic[4:0] thread_0_wire$37 = 5'd0;
  assign thread_0_wire$38 = thread_0_wire$36 != thread_0_wire$37;
  assign thread_0_wire$39 = thread_0_wire$0[0 +: 1];
  assign thread_0_wire$40 = thread_0_wire$39 & thread_0_wire$38;
  assign thread_0_wire$41 = thread_0_wire$0[1 +: 5];
  assign thread_0_wire$42 = thread_0_wire$41 == thread_0_wire$6;
  assign thread_0_wire$43 = thread_0_wire$40 & thread_0_wire$42;
  assign thread_0_wire$44 = thread_0_wire$0[0 +: 1];
  assign thread_0_wire$45 = thread_0_wire$44 & thread_0_wire$38;
  assign thread_0_wire$46 = thread_0_wire$0[1 +: 5];
  assign thread_0_wire$47 = thread_0_wire$46 == thread_0_wire$7;
  assign thread_0_wire$48 = thread_0_wire$45 & thread_0_wire$47;
  assign thread_0_wire$49 = regs_q;
  localparam logic[4:0] thread_0_wire$50 = 5'd0;
  assign thread_0_wire$51 = {thread_0_wire$50, thread_0_wire$6};
  localparam logic[9:0] thread_0_wire$52 = 10'd32;
  assign thread_0_wire$53 = thread_0_wire$51 * thread_0_wire$52;
  localparam logic[0:0] thread_0_wire$54 = 1'd0;
  assign thread_0_wire$55 = {thread_0_wire$54, thread_0_wire$53};
  localparam logic[10:0] thread_0_wire$56 = 11'd0;
  assign thread_0_wire$57 = thread_0_wire$55 + thread_0_wire$56;
  assign thread_0_wire$58 = thread_0_wire$49[thread_0_wire$57 +: 32];
  assign thread_0_wire$59 = regs_q;
  localparam logic[4:0] thread_0_wire$60 = 5'd0;
  assign thread_0_wire$61 = {thread_0_wire$60, thread_0_wire$7};
  localparam logic[9:0] thread_0_wire$62 = 10'd32;
  assign thread_0_wire$63 = thread_0_wire$61 * thread_0_wire$62;
  localparam logic[0:0] thread_0_wire$64 = 1'd0;
  assign thread_0_wire$65 = {thread_0_wire$64, thread_0_wire$63};
  localparam logic[10:0] thread_0_wire$66 = 11'd0;
  assign thread_0_wire$67 = thread_0_wire$65 + thread_0_wire$66;
  assign thread_0_wire$68 = thread_0_wire$59[thread_0_wire$67 +: 32];
  localparam logic[0:0] thread_0_wire$69 = 1'b1;
  assign thread_0_wire$70 = thread_0_wire$43 == thread_0_wire$69;
  assign thread_0_wire$71 = thread_0_wire$0[6 +: 32];
  assign thread_0_wire$72 = (thread_0_wire$70) ? thread_0_wire$71 : thread_0_wire$58;
  localparam logic[0:0] thread_0_wire$73 = 1'b1;
  assign thread_0_wire$74 = thread_0_wire$48 == thread_0_wire$73;
  assign thread_0_wire$75 = thread_0_wire$0[6 +: 32];
  assign thread_0_wire$76 = (thread_0_wire$74) ? thread_0_wire$75 : thread_0_wire$68;
  assign thread_0_wire$77 = thread_0_wire$1[15 +: 1];
  localparam logic[31:0] thread_0_wire$78 = 32'h0000ffff;
  assign thread_0_wire$79 = thread_0_wire$1 & thread_0_wire$78;
  localparam logic[0:0] thread_0_wire$80 = 1'b1;
  assign thread_0_wire$81 = thread_0_wire$77 == thread_0_wire$80;
  localparam logic[31:0] thread_0_wire$82 = 32'hffff0000;
  assign thread_0_wire$83 = thread_0_wire$79 | thread_0_wire$82;
  assign thread_0_wire$84 = (thread_0_wire$81) ? thread_0_wire$83 : thread_0_wire$79;
  localparam logic[31:0] thread_0_wire$85 = 32'h001fffff;
  assign thread_0_wire$86 = thread_0_wire$1 & thread_0_wire$85;
  localparam logic[0:0] thread_0_wire$87 = 1'b1;
  assign thread_0_wire$88 = thread_0_wire$35 == thread_0_wire$87;
  localparam logic[0:0] thread_0_wire$89 = 1'b0;
  assign thread_0_wire$90 = (thread_0_wire$88) ? thread_0_wire$89 : thread_0_wire$2;
  assign thread_0_wire$91 = thread_0_wire$12 & thread_0_wire$90;
  assign thread_0_wire$92 = thread_0_wire$0[0 +: 1];
  assign thread_0_wire$93 = thread_0_wire$92 & thread_0_wire$38;
  assign thread_0_wire$94 = thread_0_wire$0[1 +: 5];
  assign thread_0_wire$95 = thread_0_wire$0[6 +: 32];
  assign thread_0_wire$96 = thread_0_wire$16 & thread_0_wire$90;
  assign thread_0_wire$97 = thread_0_wire$10 | thread_0_wire$12;
  assign thread_0_wire$98 = thread_0_wire$97 & thread_0_wire$90;
  assign thread_0_wire$99 = thread_0_wire$14 & thread_0_wire$90;
  assign thread_0_wire$100 = thread_0_wire$12 & thread_0_wire$90;
  assign thread_0_wire$101 = thread_0_wire$12 | thread_0_wire$14;
  assign thread_0_wire$102 = {thread_0_wire$72, thread_0_wire$76, thread_0_wire$84, thread_0_wire$86, thread_0_wire$6, thread_0_wire$7, thread_0_wire$8, thread_0_wire$19, thread_0_wire$101, thread_0_wire$10, thread_0_wire$100, thread_0_wire$99, thread_0_wire$98, thread_0_wire$12, thread_0_wire$96, thread_0_wire$90};
  assign thread_0_wire$103 = _ep_branch_upd_0;
  assign thread_0_wire$104 = _ep_in_req_0;
  localparam logic[0:0] thread_0_wire$105 = 1'b1;
  assign thread_0_wire$106 = thread_0_wire$103[32 +: 1];
  localparam logic[0:0] thread_0_wire$107 = 1'b1;
  assign thread_0_wire$108 = thread_0_wire$106 == thread_0_wire$107;
  localparam logic[31:0] thread_0_wire$109 = 32'd0;
  assign thread_0_wire$110 = thread_0_wire$104[1 +: 32];
  assign thread_0_wire$111 = (thread_0_wire$108) ? thread_0_wire$109 : thread_0_wire$110;
  localparam logic[0:0] thread_0_wire$112 = 1'b1;
  assign thread_0_wire$113 = thread_0_wire$106 == thread_0_wire$112;
  localparam logic[0:0] thread_0_wire$114 = 1'b0;
  assign thread_0_wire$115 = thread_0_wire$104[0 +: 1];
  assign thread_0_wire$116 = (thread_0_wire$113) ? thread_0_wire$114 : thread_0_wire$115;
  localparam logic[0:0] thread_0_wire$117 = 1'b1;
  assign thread_0_wire$118 = thread_0_wire$35 == thread_0_wire$117;
  assign thread_0_wire$119 = (thread_0_wire$118) ? thread_0_wire$1 : thread_0_wire$111;
  localparam logic[0:0] thread_0_wire$120 = 1'b1;
  assign thread_0_wire$121 = thread_0_wire$35 == thread_0_wire$120;
  assign thread_0_wire$122 = (thread_0_wire$121) ? thread_0_wire$2 : thread_0_wire$116;
  localparam logic[0:0] thread_0_wire$123 = 1'b1;
  assign thread_0_wire$124 = thread_0_wire$35 == thread_0_wire$123;
  assign thread_0_wire$125 = thread_0_wire$104[33 +: 32];
  assign thread_0_wire$126 = (thread_0_wire$124) ? thread_0_wire$3 : thread_0_wire$125;
  localparam logic[0:0] thread_0_wire$127 = 1'b1;
  assign thread_0_wire$128 = thread_0_wire$93 == thread_0_wire$127;
  localparam logic[4:0] thread_0_wire$129 = 5'd0;
  assign thread_0_wire$130 = {thread_0_wire$129, thread_0_wire$94};
  localparam logic[9:0] thread_0_wire$131 = 10'd32;
  assign thread_0_wire$132 = thread_0_wire$130 * thread_0_wire$131;
  localparam logic[0:0] thread_0_wire$133 = 1'd0;
  assign thread_0_wire$134 = {thread_0_wire$133, thread_0_wire$132};
  localparam logic[10:0] thread_0_wire$135 = 11'd0;
  assign thread_0_wire$136 = thread_0_wire$134 + thread_0_wire$135;
  for (genvar i = 0; i < 11; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic[1:0] _thread_0_event_reg_10_q, _thread_0_event_reg_10_n;
  logic _thread_0_event_counter_9_1_q, _thread_0_event_counter_9_1_n;
  logic _thread_0_event_syncstate_8_q, _thread_0_event_syncstate_8_n;
  logic _thread_0_event_counter_7_1_q, _thread_0_event_counter_7_1_n;
  logic _thread_0_event_syncstate_6_q, _thread_0_event_syncstate_6_n;
  logic _thread_0_event_syncstate_4_q, _thread_0_event_syncstate_4_n;
  logic _thread_0_event_syncstate_3_q, _thread_0_event_syncstate_3_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[10].event_current = (EVENTS0[9].event_current & _thread_0_event_reg_10_q[0]) | (EVENTS0[7].event_current & _thread_0_event_reg_10_q[1]) | (EVENTS0[9].event_current & EVENTS0[7].event_current);
    assign _thread_0_event_reg_10_n = _thread_0_event_reg_10_q ^ {EVENTS0[9].event_current, EVENTS0[7].event_current} ^ {EVENTS0[10].event_current, EVENTS0[10].event_current};
  assign EVENTS0[9].event_current = _thread_0_event_counter_9_1_q;
  assign _thread_0_event_counter_9_1_n = EVENTS0[8].event_current;
  assign EVENTS0[8].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_8_q) && _ep_stall_upd_ack;
    assign _thread_0_event_syncstate_8_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_8_q) && !_ep_stall_upd_ack;
  assign EVENTS0[7].event_current = _thread_0_event_counter_7_1_q;
  assign _thread_0_event_counter_7_1_n = EVENTS0[6].event_current;
  assign EVENTS0[6].event_current = (EVENTS0[4].event_current || _thread_0_event_syncstate_6_q) && _ep_wb_done_ack;
    assign _thread_0_event_syncstate_6_n = (EVENTS0[4].event_current || _thread_0_event_syncstate_6_q) && !_ep_wb_done_ack;
  assign EVENTS0[5].event_current = EVENTS0[4].event_current && thread_0_wire$128;
  assign EVENTS0[4].event_current = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_4_n = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q) && !_ep_in_req_valid;
  assign EVENTS0[3].event_current = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && _ep_branch_upd_valid;
    assign _thread_0_event_syncstate_3_n = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && !_ep_branch_upd_valid;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_out_req_ack;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_wb_upd_valid;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_wb_upd_valid;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[10].event_current;
  assign _ep_in_req_ack = (EVENTS0[3].event_current || _thread_0_event_syncstate_4_q);
  assign _ep_wb_upd_ack = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_branch_upd_ack = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q);
  assign _ep_wb_done_valid = (EVENTS0[4].event_current || _thread_0_event_syncstate_6_q);
  assign _ep_wb_done_0 = thread_0_wire$105;
  assign _ep_out_req_valid = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_out_req_0 = thread_0_wire$102;
  assign _ep_stall_upd_valid = (EVENTS0[1].event_current || _thread_0_event_syncstate_8_q);
  assign _ep_stall_upd_0 = thread_0_wire$35;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      ifid_instr_q <= '0;
      ifid_pc_q <= '0;
      ifid_valid_q <= '0;
      regs_q <= '0;
      sh_mem_read_q <= '0;
      sh_rt_q <= '0;
      _thread_0_event_reg_10_q <= '0;
      _thread_0_event_counter_9_1_q <= '0;
      _thread_0_event_syncstate_8_q <= '0;
      _thread_0_event_counter_7_1_q <= '0;
      _thread_0_event_syncstate_6_q <= '0;
      _thread_0_event_syncstate_4_q <= '0;
      _thread_0_event_syncstate_3_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[5].event_current) begin
        regs_q[thread_0_wire$136 +: 32] <= thread_0_wire$95;
      end
      if (EVENTS0[4].event_current) begin
        sh_rt_q[0 +: 5] <= thread_0_wire$7;
        sh_mem_read_q[0 +: 1] <= thread_0_wire$91;
        ifid_pc_q[0 +: 32] <= thread_0_wire$126;
        ifid_valid_q[0 +: 1] <= thread_0_wire$122;
        ifid_instr_q[0 +: 32] <= thread_0_wire$119;
      end
      _init_0 <= 1'b0;
      _thread_0_event_reg_10_q <= _thread_0_event_reg_10_n;
      _thread_0_event_counter_9_1_q <= _thread_0_event_counter_9_1_n;
      _thread_0_event_syncstate_8_q <= _thread_0_event_syncstate_8_n;
      _thread_0_event_counter_7_1_q <= _thread_0_event_counter_7_1_n;
      _thread_0_event_syncstate_6_q <= _thread_0_event_syncstate_6_n;
      _thread_0_event_syncstate_4_q <= _thread_0_event_syncstate_4_n;
      _thread_0_event_syncstate_3_q <= _thread_0_event_syncstate_3_n;
      _thread_0_event_syncstate_2_q <= _thread_0_event_syncstate_2_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
module Fetch (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  input logic[0:0] _ep_out_req_ack,
  output logic[0:0] _ep_out_req_valid,
  output logic[64:0] _ep_out_req_0,
  output logic[0:0] _ep_branch_upd_ack,
  input logic[0:0] _ep_branch_upd_valid,
  input logic[32:0] _ep_branch_upd_0,
  output logic[0:0] _ep_stall_upd_ack,
  input logic[0:0] _ep_stall_upd_valid,
  input logic[0:0] _ep_stall_upd_0
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
  logic[32:0] thread_0_wire$24;
  logic[0:0] thread_0_wire$23;
  logic[64:0] thread_0_wire$22;
  logic[0:0] thread_0_wire$21;
  logic[0:0] thread_0_wire$18;
  logic[31:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$14;
  logic[31:0] thread_0_wire$12;
  logic[13:0] thread_0_wire$11;
  logic[13:0] thread_0_wire$9;
  logic[12:0] thread_0_wire$7;
  logic[12:0] thread_0_wire$5;
  logic[7:0] thread_0_wire$3;
  logic[8191:0] thread_0_wire$2;
  logic[31:0] thread_0_wire$1;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = init_done_q;
  assign thread_0_wire$1 = pc_q;
  assign thread_0_wire$2 = imem_q;
  assign thread_0_wire$3 = thread_0_wire$1[2 +: 8];
  localparam logic[4:0] thread_0_wire$4 = 5'd0;
  assign thread_0_wire$5 = {thread_0_wire$4, thread_0_wire$3};
  localparam logic[12:0] thread_0_wire$6 = 13'd32;
  assign thread_0_wire$7 = thread_0_wire$5 * thread_0_wire$6;
  localparam logic[0:0] thread_0_wire$8 = 1'd0;
  assign thread_0_wire$9 = {thread_0_wire$8, thread_0_wire$7};
  localparam logic[13:0] thread_0_wire$10 = 14'd0;
  assign thread_0_wire$11 = thread_0_wire$9 + thread_0_wire$10;
  assign thread_0_wire$12 = thread_0_wire$2[thread_0_wire$11 +: 32];
  localparam logic[0:0] thread_0_wire$13 = 1'b1;
  assign thread_0_wire$14 = thread_0_wire$0 == thread_0_wire$13;
  localparam logic[31:0] thread_0_wire$15 = 32'd0;
  assign thread_0_wire$16 = (thread_0_wire$14) ? thread_0_wire$12 : thread_0_wire$15;
  localparam logic[0:0] thread_0_wire$17 = 1'b1;
  assign thread_0_wire$18 = thread_0_wire$0 == thread_0_wire$17;
  localparam logic[0:0] thread_0_wire$19 = 1'b1;
  localparam logic[0:0] thread_0_wire$20 = 1'b0;
  assign thread_0_wire$21 = (thread_0_wire$18) ? thread_0_wire$19 : thread_0_wire$20;
  assign thread_0_wire$22 = {thread_0_wire$1, thread_0_wire$16, thread_0_wire$21};
  assign thread_0_wire$23 = _ep_stall_upd_0;
  assign thread_0_wire$24 = _ep_branch_upd_0;
  localparam logic[0:0] thread_0_wire$25 = 1'b1;
  assign thread_0_wire$26 = thread_0_wire$23 == thread_0_wire$25;
  localparam logic[31:0] thread_0_wire$27 = 32'd4;
  assign thread_0_wire$28 = thread_0_wire$1 + thread_0_wire$27;
  assign thread_0_wire$29 = (thread_0_wire$26) ? thread_0_wire$1 : thread_0_wire$28;
  assign thread_0_wire$30 = thread_0_wire$24[32 +: 1];
  localparam logic[0:0] thread_0_wire$31 = 1'b1;
  assign thread_0_wire$32 = thread_0_wire$30 == thread_0_wire$31;
  assign thread_0_wire$33 = thread_0_wire$24[0 +: 32];
  assign thread_0_wire$34 = (thread_0_wire$32) ? thread_0_wire$33 : thread_0_wire$29;
  localparam logic[0:0] thread_0_wire$35 = 1'b0;
  assign thread_0_wire$36 = thread_0_wire$0 == thread_0_wire$35;
  assign thread_0_wire$37 = (thread_0_wire$36) ? thread_0_wire$1 : thread_0_wire$34;
  localparam logic[0:0] thread_0_wire$38 = 1'b0;
  assign thread_0_wire$39 = thread_0_wire$0 == thread_0_wire$38;
  localparam logic[31:0] thread_0_wire$40 = 32'h8c010000;
  localparam logic[31:0] thread_0_wire$41 = 32'h00201020;
  localparam logic[31:0] thread_0_wire$42 = 32'h00411022;
  localparam logic[31:0] thread_0_wire$43 = 32'h08400005;
  localparam logic[31:0] thread_0_wire$44 = 32'h00411820;
  localparam logic[31:0] thread_0_wire$45 = 32'h00412020;
  localparam logic[31:0] thread_0_wire$46 = 32'hac810000;
  localparam logic[0:0] thread_0_wire$47 = 1'b1;
  for (genvar i = 0; i < 6; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_syncstate_3_q, _thread_0_event_syncstate_3_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[3].event_current;
  assign EVENTS0[4].event_current = EVENTS0[3].event_current && thread_0_wire$39;
  assign EVENTS0[3].event_current = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && _ep_branch_upd_valid;
    assign _thread_0_event_syncstate_3_n = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q) && !_ep_branch_upd_valid;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_stall_upd_valid;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_stall_upd_valid;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_out_req_ack;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[5].event_current;
  assign _ep_stall_upd_ack = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_branch_upd_ack = (EVENTS0[2].event_current || _thread_0_event_syncstate_3_q);
  assign _ep_out_req_valid = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_out_req_0 = thread_0_wire$22;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      imem_q <= '0;
      init_done_q <= '0;
      pc_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_syncstate_3_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[4].event_current) begin
        imem_q[192 +: 32] <= thread_0_wire$46;
        imem_q[160 +: 32] <= thread_0_wire$45;
        imem_q[128 +: 32] <= thread_0_wire$44;
        imem_q[96 +: 32] <= thread_0_wire$43;
        imem_q[64 +: 32] <= thread_0_wire$42;
        imem_q[32 +: 32] <= thread_0_wire$41;
        imem_q[0 +: 32] <= thread_0_wire$40;
      end
      if (EVENTS0[3].event_current) begin
        pc_q[0 +: 32] <= thread_0_wire$37;
        init_done_q[0 +: 1] <= thread_0_wire$47;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_syncstate_3_q <= _thread_0_event_syncstate_3_n;
      _thread_0_event_syncstate_2_q <= _thread_0_event_syncstate_2_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
module MipsPipelineBP (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni
);
  logic[0:0] _if_id_le_req_ack;
  logic[0:0] _if_id_le_req_valid;
  logic[64:0] _if_id_le_req_0;
  logic[0:0] _id_ex_le_req_ack;
  logic[0:0] _id_ex_le_req_valid;
  logic[151:0] _id_ex_le_req_0;
  logic[0:0] _ex_mem_le_req_ack;
  logic[0:0] _ex_mem_le_req_valid;
  logic[72:0] _ex_mem_le_req_0;
  logic[0:0] _mem_wb_le_req_ack;
  logic[0:0] _mem_wb_le_req_valid;
  logic[70:0] _mem_wb_le_req_0;
  logic[0:0] _wb_id_le_upd_ack;
  logic[0:0] _wb_id_le_upd_valid;
  logic[37:0] _wb_id_le_upd_0;
  logic[0:0] _wb_id_le_done_ack;
  logic[0:0] _wb_id_le_done_valid;
  logic[0:0] _wb_id_le_done_0;
  logic[0:0] _wb_ex_le_upd_ack;
  logic[0:0] _wb_ex_le_upd_valid;
  logic[37:0] _wb_ex_le_upd_0;
  logic[0:0] _wb_ex_le_done_ack;
  logic[0:0] _wb_ex_le_done_valid;
  logic[0:0] _wb_ex_le_done_0;
  logic[0:0] _br_if_le_upd_ack;
  logic[0:0] _br_if_le_upd_valid;
  logic[32:0] _br_if_le_upd_0;
  logic[0:0] _br_id_le_upd_ack;
  logic[0:0] _br_id_le_upd_valid;
  logic[32:0] _br_id_le_upd_0;
  logic[0:0] _stall_le_upd_ack;
  logic[0:0] _stall_le_upd_valid;
  logic[0:0] _stall_le_upd_0;
  logic[0:0] _dmem_le_req_ack;
  logic[0:0] _dmem_le_req_valid;
  logic[40:0] _dmem_le_req_0;
  logic[0:0] _dmem_le_resp_ack;
  logic[0:0] _dmem_le_resp_valid;
  logic[31:0] _dmem_le_resp_0;
  Fetch _spawn_0 (
    .clk_i,
    .rst_ni
    ,._ep_out_req_valid (_if_id_le_req_valid)
    ,._ep_out_req_ack (_if_id_le_req_ack)
    ,._ep_out_req_0 (_if_id_le_req_0)
    ,._ep_branch_upd_valid (_br_if_le_upd_valid)
    ,._ep_branch_upd_ack (_br_if_le_upd_ack)
    ,._ep_branch_upd_0 (_br_if_le_upd_0)
    ,._ep_stall_upd_valid (_stall_le_upd_valid)
    ,._ep_stall_upd_ack (_stall_le_upd_ack)
    ,._ep_stall_upd_0 (_stall_le_upd_0)
  );
  Decode _spawn_1 (
    .clk_i,
    .rst_ni
    ,._ep_in_req_valid (_if_id_le_req_valid)
    ,._ep_in_req_ack (_if_id_le_req_ack)
    ,._ep_in_req_0 (_if_id_le_req_0)
    ,._ep_out_req_valid (_id_ex_le_req_valid)
    ,._ep_out_req_ack (_id_ex_le_req_ack)
    ,._ep_out_req_0 (_id_ex_le_req_0)
    ,._ep_wb_done_valid (_wb_id_le_done_valid)
    ,._ep_wb_done_ack (_wb_id_le_done_ack)
    ,._ep_wb_done_0 (_wb_id_le_done_0)
    ,._ep_wb_upd_valid (_wb_id_le_upd_valid)
    ,._ep_wb_upd_ack (_wb_id_le_upd_ack)
    ,._ep_wb_upd_0 (_wb_id_le_upd_0)
    ,._ep_branch_upd_valid (_br_id_le_upd_valid)
    ,._ep_branch_upd_ack (_br_id_le_upd_ack)
    ,._ep_branch_upd_0 (_br_id_le_upd_0)
    ,._ep_stall_upd_valid (_stall_le_upd_valid)
    ,._ep_stall_upd_ack (_stall_le_upd_ack)
    ,._ep_stall_upd_0 (_stall_le_upd_0)
  );
  Execute _spawn_2 (
    .clk_i,
    .rst_ni
    ,._ep_in_req_valid (_id_ex_le_req_valid)
    ,._ep_in_req_ack (_id_ex_le_req_ack)
    ,._ep_in_req_0 (_id_ex_le_req_0)
    ,._ep_out_req_valid (_ex_mem_le_req_valid)
    ,._ep_out_req_ack (_ex_mem_le_req_ack)
    ,._ep_out_req_0 (_ex_mem_le_req_0)
    ,._ep_wb_done_valid (_wb_ex_le_done_valid)
    ,._ep_wb_done_ack (_wb_ex_le_done_ack)
    ,._ep_wb_done_0 (_wb_ex_le_done_0)
    ,._ep_wb_upd_valid (_wb_ex_le_upd_valid)
    ,._ep_wb_upd_ack (_wb_ex_le_upd_ack)
    ,._ep_wb_upd_0 (_wb_ex_le_upd_0)
    ,._ep_br_if_upd_valid (_br_if_le_upd_valid)
    ,._ep_br_if_upd_ack (_br_if_le_upd_ack)
    ,._ep_br_if_upd_0 (_br_if_le_upd_0)
    ,._ep_br_id_upd_valid (_br_id_le_upd_valid)
    ,._ep_br_id_upd_ack (_br_id_le_upd_ack)
    ,._ep_br_id_upd_0 (_br_id_le_upd_0)
  );
  Memory _spawn_3 (
    .clk_i,
    .rst_ni
    ,._ep_in_req_valid (_ex_mem_le_req_valid)
    ,._ep_in_req_ack (_ex_mem_le_req_ack)
    ,._ep_in_req_0 (_ex_mem_le_req_0)
    ,._ep_out_req_valid (_mem_wb_le_req_valid)
    ,._ep_out_req_ack (_mem_wb_le_req_ack)
    ,._ep_out_req_0 (_mem_wb_le_req_0)
    ,._ep_dm_resp_valid (_dmem_le_resp_valid)
    ,._ep_dm_resp_ack (_dmem_le_resp_ack)
    ,._ep_dm_resp_0 (_dmem_le_resp_0)
    ,._ep_dm_req_valid (_dmem_le_req_valid)
    ,._ep_dm_req_ack (_dmem_le_req_ack)
    ,._ep_dm_req_0 (_dmem_le_req_0)
  );
  Writeback _spawn_4 (
    .clk_i,
    .rst_ni
    ,._ep_in_req_valid (_mem_wb_le_req_valid)
    ,._ep_in_req_ack (_mem_wb_le_req_ack)
    ,._ep_in_req_0 (_mem_wb_le_req_0)
    ,._ep_id_done_valid (_wb_id_le_done_valid)
    ,._ep_id_done_ack (_wb_id_le_done_ack)
    ,._ep_id_done_0 (_wb_id_le_done_0)
    ,._ep_id_upd_valid (_wb_id_le_upd_valid)
    ,._ep_id_upd_ack (_wb_id_le_upd_ack)
    ,._ep_id_upd_0 (_wb_id_le_upd_0)
    ,._ep_ex_done_valid (_wb_ex_le_done_valid)
    ,._ep_ex_done_ack (_wb_ex_le_done_ack)
    ,._ep_ex_done_0 (_wb_ex_le_done_0)
    ,._ep_ex_upd_valid (_wb_ex_le_upd_valid)
    ,._ep_ex_upd_ack (_wb_ex_le_upd_ack)
    ,._ep_ex_upd_0 (_wb_ex_le_upd_0)
  );
  DataMemory _spawn_5 (
    .clk_i,
    .rst_ni
    ,._ep_resp_valid (_dmem_le_resp_valid)
    ,._ep_resp_ack (_dmem_le_resp_ack)
    ,._ep_resp_0 (_dmem_le_resp_0)
    ,._ep_req_valid (_dmem_le_req_valid)
    ,._ep_req_ack (_dmem_le_req_ack)
    ,._ep_req_0 (_dmem_le_req_0)
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
