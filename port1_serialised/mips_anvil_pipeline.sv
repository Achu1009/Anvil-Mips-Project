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
  input logic[0:0] _ep_in_res_ack,
  output logic[0:0] _ep_in_res_valid,
  output logic[0:0] _ep_in_res_0,
  input logic[0:0] _ep_wb_out_req_ack,
  output logic[0:0] _ep_wb_out_req_valid,
  output logic[37:0] _ep_wb_out_req_0,
  output logic[0:0] _ep_wb_out_res_ack,
  input logic[0:0] _ep_wb_out_res_valid,
  input logic[0:0] _ep_wb_out_res_0
);
  logic[4:0] prev_dest_reg_q;
  logic[0:0] prev_reg_write_q;
  logic[31:0] prev_write_data_q;
  logic[4:0] temp_dest_reg_q;
  logic[0:0] temp_reg_write_q;
  logic[31:0] temp_write_data_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$17;
  logic[4:0] thread_0_wire$16;
  logic[31:0] thread_0_wire$15;
  logic[0:0] thread_0_wire$14;
  logic[31:0] thread_0_wire$12;
  logic[0:0] thread_0_wire$11;
  logic[0:0] thread_0_wire$9;
  logic[4:0] thread_0_wire$8;
  logic[31:0] thread_0_wire$7;
  logic[31:0] thread_0_wire$6;
  logic[0:0] thread_0_wire$5;
  logic[70:0] thread_0_wire$4;
  logic[37:0] thread_0_wire$3;
  logic[31:0] thread_0_wire$2;
  logic[4:0] thread_0_wire$1;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = prev_reg_write_q;
  assign thread_0_wire$1 = prev_dest_reg_q;
  assign thread_0_wire$2 = prev_write_data_q;
  assign thread_0_wire$3 = {thread_0_wire$2, thread_0_wire$1, thread_0_wire$0};
  assign thread_0_wire$4 = _ep_in_req_0;
  assign thread_0_wire$5 = thread_0_wire$4[0 +: 1];
  assign thread_0_wire$6 = thread_0_wire$4[7 +: 32];
  assign thread_0_wire$7 = thread_0_wire$4[39 +: 32];
  assign thread_0_wire$8 = thread_0_wire$4[2 +: 5];
  assign thread_0_wire$9 = thread_0_wire$4[1 +: 1];
  localparam logic[0:0] thread_0_wire$10 = 1'b1;
  assign thread_0_wire$11 = thread_0_wire$5 == thread_0_wire$10;
  assign thread_0_wire$12 = (thread_0_wire$11) ? thread_0_wire$6 : thread_0_wire$7;
  localparam logic[0:0] thread_0_wire$13 = 1'b1;
  assign thread_0_wire$14 = _ep_wb_out_res_0;
  assign thread_0_wire$15 = temp_write_data_q;
  assign thread_0_wire$16 = temp_dest_reg_q;
  assign thread_0_wire$17 = temp_reg_write_q;
  for (genvar i = 0; i < 12; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_11_1_q, _thread_0_event_counter_11_1_n;
  logic _thread_0_event_counter_10_1_q, _thread_0_event_counter_10_1_n;
  logic _thread_0_event_counter_9_1_q, _thread_0_event_counter_9_1_n;
  logic _thread_0_event_counter_8_1_q, _thread_0_event_counter_8_1_n;
  logic _thread_0_event_syncstate_7_q, _thread_0_event_syncstate_7_n;
  logic _thread_0_event_syncstate_6_q, _thread_0_event_syncstate_6_n;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_counter_4_1_q, _thread_0_event_counter_4_1_n;
  logic _thread_0_event_counter_3_1_q, _thread_0_event_counter_3_1_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[11].event_current = _thread_0_event_counter_11_1_q;
  assign _thread_0_event_counter_11_1_n = EVENTS0[10].event_current;
  assign EVENTS0[10].event_current = _thread_0_event_counter_10_1_q;
  assign _thread_0_event_counter_10_1_n = EVENTS0[9].event_current;
  assign EVENTS0[9].event_current = _thread_0_event_counter_9_1_q;
  assign _thread_0_event_counter_9_1_n = EVENTS0[8].event_current;
  assign EVENTS0[8].event_current = _thread_0_event_counter_8_1_q;
  assign _thread_0_event_counter_8_1_n = EVENTS0[7].event_current;
  assign EVENTS0[7].event_current = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && _ep_wb_out_res_valid;
    assign _thread_0_event_syncstate_7_n = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && !_ep_wb_out_res_valid;
  assign EVENTS0[6].event_current = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_6_n = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q) && !_ep_in_res_ack;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = _thread_0_event_counter_4_1_q;
  assign _thread_0_event_counter_4_1_n = EVENTS0[3].event_current;
  assign EVENTS0[3].event_current = _thread_0_event_counter_3_1_q;
  assign _thread_0_event_counter_3_1_n = EVENTS0[2].event_current;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_in_req_valid;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_wb_out_req_ack;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_wb_out_req_ack;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[11].event_current;
  assign _ep_wb_out_res_ack = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q);
  assign _ep_in_req_ack = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_in_res_valid = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q);
  assign _ep_in_res_0 = thread_0_wire$13;
  assign _ep_wb_out_req_valid = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_wb_out_req_0 = thread_0_wire$3;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      prev_dest_reg_q <= '0;
      prev_reg_write_q <= '0;
      prev_write_data_q <= '0;
      temp_dest_reg_q <= '0;
      temp_reg_write_q <= '0;
      temp_write_data_q <= '0;
      _thread_0_event_counter_11_1_q <= '0;
      _thread_0_event_counter_10_1_q <= '0;
      _thread_0_event_counter_9_1_q <= '0;
      _thread_0_event_counter_8_1_q <= '0;
      _thread_0_event_syncstate_7_q <= '0;
      _thread_0_event_syncstate_6_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_counter_4_1_q <= '0;
      _thread_0_event_counter_3_1_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[9].event_current) begin
        prev_reg_write_q[0 +: 1] <= thread_0_wire$17;
      end
      if (EVENTS0[8].event_current) begin
        prev_dest_reg_q[0 +: 5] <= thread_0_wire$16;
      end
      if (EVENTS0[7].event_current) begin
        prev_write_data_q[0 +: 32] <= thread_0_wire$15;
      end
      if (EVENTS0[4].event_current) begin
        temp_reg_write_q[0 +: 1] <= thread_0_wire$9;
      end
      if (EVENTS0[3].event_current) begin
        temp_dest_reg_q[0 +: 5] <= thread_0_wire$8;
      end
      if (EVENTS0[2].event_current) begin
        temp_write_data_q[0 +: 32] <= thread_0_wire$12;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_11_1_q <= _thread_0_event_counter_11_1_n;
      _thread_0_event_counter_10_1_q <= _thread_0_event_counter_10_1_n;
      _thread_0_event_counter_9_1_q <= _thread_0_event_counter_9_1_n;
      _thread_0_event_counter_8_1_q <= _thread_0_event_counter_8_1_n;
      _thread_0_event_syncstate_7_q <= _thread_0_event_syncstate_7_n;
      _thread_0_event_syncstate_6_q <= _thread_0_event_syncstate_6_n;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_counter_4_1_q <= _thread_0_event_counter_4_1_n;
      _thread_0_event_counter_3_1_q <= _thread_0_event_counter_3_1_n;
      _thread_0_event_syncstate_2_q <= _thread_0_event_syncstate_2_n;
      _thread_0_event_syncstate_1_q <= _thread_0_event_syncstate_1_n;
    end
  end
endmodule
module Memory (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _ep_in_req_ack,
  input logic[0:0] _ep_in_req_valid,
  input logic[72:0] _ep_in_req_0,
  input logic[0:0] _ep_in_res_ack,
  output logic[0:0] _ep_in_res_valid,
  output logic[0:0] _ep_in_res_0,
  input logic[0:0] _ep_out_req_ack,
  output logic[0:0] _ep_out_req_valid,
  output logic[70:0] _ep_out_req_0,
  output logic[0:0] _ep_out_res_ack,
  input logic[0:0] _ep_out_res_valid,
  input logic[0:0] _ep_out_res_0
);
  logic[8191:0] dmem_q;
  logic[0:0] init_done_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$48;
  logic[70:0] thread_0_wire$47;
  logic[31:0] thread_0_wire$46;
  logic[13:0] thread_0_wire$45;
  logic[13:0] thread_0_wire$43;
  logic[12:0] thread_0_wire$41;
  logic[12:0] thread_0_wire$39;
  logic[8191:0] thread_0_wire$37;
  logic[0:0] thread_0_wire$35;
  logic[70:0] thread_0_wire$34;
  logic[31:0] thread_0_wire$33;
  logic[13:0] thread_0_wire$32;
  logic[13:0] thread_0_wire$30;
  logic[12:0] thread_0_wire$28;
  logic[12:0] thread_0_wire$26;
  logic[8191:0] thread_0_wire$24;
  logic[13:0] thread_0_wire$23;
  logic[13:0] thread_0_wire$21;
  logic[12:0] thread_0_wire$19;
  logic[12:0] thread_0_wire$17;
  logic[0:0] thread_0_wire$15;
  logic[7:0] thread_0_wire$13;
  logic[31:0] thread_0_wire$12;
  logic[0:0] thread_0_wire$11;
  logic[0:0] thread_0_wire$10;
  logic[0:0] thread_0_wire$9;
  logic[0:0] thread_0_wire$8;
  logic[4:0] thread_0_wire$7;
  logic[31:0] thread_0_wire$6;
  logic[72:0] thread_0_wire$5;
  logic[0:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = init_done_q;
  localparam logic[0:0] thread_0_wire$1 = 1'b0;
  assign thread_0_wire$2 = thread_0_wire$0 == thread_0_wire$1;
  localparam logic[31:0] thread_0_wire$3 = 32'd20;
  localparam logic[0:0] thread_0_wire$4 = 1'b1;
  assign thread_0_wire$5 = _ep_in_req_0;
  assign thread_0_wire$6 = thread_0_wire$5[41 +: 32];
  assign thread_0_wire$7 = thread_0_wire$5[4 +: 5];
  assign thread_0_wire$8 = thread_0_wire$5[1 +: 1];
  assign thread_0_wire$9 = thread_0_wire$5[0 +: 1];
  assign thread_0_wire$10 = thread_0_wire$5[2 +: 1];
  assign thread_0_wire$11 = thread_0_wire$5[3 +: 1];
  assign thread_0_wire$12 = thread_0_wire$5[9 +: 32];
  assign thread_0_wire$13 = thread_0_wire$6[2 +: 8];
  localparam logic[0:0] thread_0_wire$14 = 1'b1;
  assign thread_0_wire$15 = thread_0_wire$10 == thread_0_wire$14;
  localparam logic[4:0] thread_0_wire$16 = 5'd0;
  assign thread_0_wire$17 = {thread_0_wire$16, thread_0_wire$13};
  localparam logic[12:0] thread_0_wire$18 = 13'd32;
  assign thread_0_wire$19 = thread_0_wire$17 * thread_0_wire$18;
  localparam logic[0:0] thread_0_wire$20 = 1'd0;
  assign thread_0_wire$21 = {thread_0_wire$20, thread_0_wire$19};
  localparam logic[13:0] thread_0_wire$22 = 14'd0;
  assign thread_0_wire$23 = thread_0_wire$21 + thread_0_wire$22;
  assign thread_0_wire$24 = dmem_q;
  localparam logic[4:0] thread_0_wire$25 = 5'd0;
  assign thread_0_wire$26 = {thread_0_wire$25, thread_0_wire$13};
  localparam logic[12:0] thread_0_wire$27 = 13'd32;
  assign thread_0_wire$28 = thread_0_wire$26 * thread_0_wire$27;
  localparam logic[0:0] thread_0_wire$29 = 1'd0;
  assign thread_0_wire$30 = {thread_0_wire$29, thread_0_wire$28};
  localparam logic[13:0] thread_0_wire$31 = 14'd0;
  assign thread_0_wire$32 = thread_0_wire$30 + thread_0_wire$31;
  assign thread_0_wire$33 = thread_0_wire$24[thread_0_wire$32 +: 32];
  assign thread_0_wire$34 = {thread_0_wire$6, thread_0_wire$33, thread_0_wire$7, thread_0_wire$8, thread_0_wire$9};
  assign thread_0_wire$35 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$36 = 1'b1;
  assign thread_0_wire$37 = dmem_q;
  localparam logic[4:0] thread_0_wire$38 = 5'd0;
  assign thread_0_wire$39 = {thread_0_wire$38, thread_0_wire$13};
  localparam logic[12:0] thread_0_wire$40 = 13'd32;
  assign thread_0_wire$41 = thread_0_wire$39 * thread_0_wire$40;
  localparam logic[0:0] thread_0_wire$42 = 1'd0;
  assign thread_0_wire$43 = {thread_0_wire$42, thread_0_wire$41};
  localparam logic[13:0] thread_0_wire$44 = 14'd0;
  assign thread_0_wire$45 = thread_0_wire$43 + thread_0_wire$44;
  assign thread_0_wire$46 = thread_0_wire$37[thread_0_wire$45 +: 32];
  assign thread_0_wire$47 = {thread_0_wire$6, thread_0_wire$46, thread_0_wire$7, thread_0_wire$8, thread_0_wire$9};
  assign thread_0_wire$48 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$49 = 1'b1;
  for (genvar i = 0; i < 17; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_16_1_q, _thread_0_event_counter_16_1_n;
  logic _thread_0_event_syncstate_14_q, _thread_0_event_syncstate_14_n;
  logic _thread_0_event_syncstate_13_q, _thread_0_event_syncstate_13_n;
  logic _thread_0_event_syncstate_12_q, _thread_0_event_syncstate_12_n;
  logic _thread_0_event_counter_11_1_q, _thread_0_event_counter_11_1_n;
  logic _thread_0_event_syncstate_9_q, _thread_0_event_syncstate_9_n;
  logic _thread_0_event_syncstate_8_q, _thread_0_event_syncstate_8_n;
  logic _thread_0_event_syncstate_7_q, _thread_0_event_syncstate_7_n;
  logic _thread_0_event_syncstate_5_q, _thread_0_event_syncstate_5_n;
  logic _thread_0_event_counter_3_1_q, _thread_0_event_counter_3_1_n;
  logic _thread_0_event_counter_2_1_q, _thread_0_event_counter_2_1_n;
  assign EVENTS0[16].event_current = _thread_0_event_counter_16_1_q;
  assign _thread_0_event_counter_16_1_n = EVENTS0[15].event_current;
  assign EVENTS0[15].event_current = EVENTS0[14].event_current || EVENTS0[9].event_current || EVENTS0[3].event_current;
  assign EVENTS0[14].event_current = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_14_n = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) && !_ep_in_res_ack;
  assign EVENTS0[13].event_current = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_13_n = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) && !_ep_out_res_valid;
  assign EVENTS0[12].event_current = (EVENTS0[11].event_current || _thread_0_event_syncstate_12_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_12_n = (EVENTS0[11].event_current || _thread_0_event_syncstate_12_q) && !_ep_out_req_ack;
  assign EVENTS0[11].event_current = _thread_0_event_counter_11_1_q;
  assign _thread_0_event_counter_11_1_n = EVENTS0[10].event_current;
  assign EVENTS0[10].event_current = EVENTS0[5].event_current && thread_0_wire$15;
  assign EVENTS0[9].event_current = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_9_n = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) && !_ep_in_res_ack;
  assign EVENTS0[8].event_current = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_8_n = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && !_ep_out_res_valid;
  assign EVENTS0[7].event_current = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_7_n = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && !_ep_out_req_ack;
  assign EVENTS0[6].event_current = EVENTS0[5].event_current && !thread_0_wire$15;
  assign EVENTS0[5].event_current = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_5_n = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q) && !_ep_in_req_valid;
  assign EVENTS0[4].event_current = EVENTS0[0].event_current && !thread_0_wire$2;
  assign EVENTS0[3].event_current = _thread_0_event_counter_3_1_q;
  assign _thread_0_event_counter_3_1_n = EVENTS0[2].event_current;
  assign EVENTS0[2].event_current = _thread_0_event_counter_2_1_q;
  assign _thread_0_event_counter_2_1_n = EVENTS0[1].event_current;
  assign EVENTS0[1].event_current = EVENTS0[0].event_current && thread_0_wire$2;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[16].event_current;
  assign _ep_in_req_ack = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q);
  assign _ep_out_res_ack = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) || (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q);
  assign _ep_in_res_valid = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) || (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q);
  assign _ep_out_req_valid = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) || (EVENTS0[11].event_current || _thread_0_event_syncstate_12_q);
  logic[0:0] _ep_out_req_valid_selector_q, _ep_out_req_valid_selector_n;
  assign _ep_out_req_0 = (_ep_out_req_valid_selector_n == 1'd0) ? thread_0_wire$47 : (_ep_out_req_valid_selector_n == 1'd1) ? thread_0_wire$34 : '0;
  logic[0:0] _ep_in_res_valid_selector_q, _ep_in_res_valid_selector_n;
  assign _ep_in_res_0 = (_ep_in_res_valid_selector_n == 1'd0) ? thread_0_wire$49 : (_ep_in_res_valid_selector_n == 1'd1) ? thread_0_wire$36 : '0;
  always_comb begin: _thread_0_selector
    _ep_out_req_valid_selector_n = _ep_out_req_valid_selector_q;
    if ((EVENTS0[6].event_current || _thread_0_event_syncstate_7_q)) _ep_out_req_valid_selector_n = 1'd0;
    if ((EVENTS0[11].event_current || _thread_0_event_syncstate_12_q)) _ep_out_req_valid_selector_n = 1'd1;
    _ep_in_res_valid_selector_n = _ep_in_res_valid_selector_q;
    if ((EVENTS0[8].event_current || _thread_0_event_syncstate_9_q)) _ep_in_res_valid_selector_n = 1'd0;
    if ((EVENTS0[13].event_current || _thread_0_event_syncstate_14_q)) _ep_in_res_valid_selector_n = 1'd1;
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_selector_trans
    if (~rst_ni) begin
      _ep_out_req_valid_selector_q <= '0;
      _ep_in_res_valid_selector_q <= '0;
    end else begin
      _ep_out_req_valid_selector_q <= _ep_out_req_valid_selector_n;
      _ep_in_res_valid_selector_q <= _ep_in_res_valid_selector_n;
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      dmem_q <= '0;
      init_done_q <= '0;
      _thread_0_event_counter_16_1_q <= '0;
      _thread_0_event_syncstate_14_q <= '0;
      _thread_0_event_syncstate_13_q <= '0;
      _thread_0_event_syncstate_12_q <= '0;
      _thread_0_event_counter_11_1_q <= '0;
      _thread_0_event_syncstate_9_q <= '0;
      _thread_0_event_syncstate_8_q <= '0;
      _thread_0_event_syncstate_7_q <= '0;
      _thread_0_event_syncstate_5_q <= '0;
      _thread_0_event_counter_3_1_q <= '0;
      _thread_0_event_counter_2_1_q <= '0;
    end else begin
      if (EVENTS0[10].event_current) begin
        dmem_q[thread_0_wire$23 +: 32] <= thread_0_wire$12;
      end
      if (EVENTS0[2].event_current) begin
        init_done_q[0 +: 1] <= thread_0_wire$4;
      end
      if (EVENTS0[1].event_current) begin
        dmem_q[0 +: 32] <= thread_0_wire$3;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_16_1_q <= _thread_0_event_counter_16_1_n;
      _thread_0_event_syncstate_14_q <= _thread_0_event_syncstate_14_n;
      _thread_0_event_syncstate_13_q <= _thread_0_event_syncstate_13_n;
      _thread_0_event_syncstate_12_q <= _thread_0_event_syncstate_12_n;
      _thread_0_event_counter_11_1_q <= _thread_0_event_counter_11_1_n;
      _thread_0_event_syncstate_9_q <= _thread_0_event_syncstate_9_n;
      _thread_0_event_syncstate_8_q <= _thread_0_event_syncstate_8_n;
      _thread_0_event_syncstate_7_q <= _thread_0_event_syncstate_7_n;
      _thread_0_event_syncstate_5_q <= _thread_0_event_syncstate_5_n;
      _thread_0_event_counter_3_1_q <= _thread_0_event_counter_3_1_n;
      _thread_0_event_counter_2_1_q <= _thread_0_event_counter_2_1_n;
    end
  end
endmodule
module Execute (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni,
  output logic[0:0] _ep_in_req_ack,
  input logic[0:0] _ep_in_req_valid,
  input logic[185:0] _ep_in_req_0,
  input logic[0:0] _ep_in_res_ack,
  output logic[0:0] _ep_in_res_valid,
  output logic[0:0] _ep_in_res_0,
  input logic[0:0] _ep_out_req_ack,
  output logic[0:0] _ep_out_req_valid,
  output logic[72:0] _ep_out_req_0,
  output logic[0:0] _ep_out_res_ack,
  input logic[0:0] _ep_out_res_valid,
  input logic[0:0] _ep_out_res_0,
  input logic[0:0] _ep_branch_req_ack,
  output logic[0:0] _ep_branch_req_valid,
  output logic[32:0] _ep_branch_req_0,
  output logic[0:0] _ep_branch_res_ack,
  input logic[0:0] _ep_branch_res_valid,
  input logic[0:0] _ep_branch_res_0
);
  logic[0:0] prev_b_taken_q;
  logic[31:0] prev_b_target_q;
  logic[0:0] temp_b_taken_q;
  logic[31:0] temp_b_target_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[31:0] thread_0_wire$40;
  logic[0:0] thread_0_wire$39;
  logic[0:0] thread_0_wire$38;
  logic[0:0] thread_0_wire$36;
  logic[72:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$34;
  logic[0:0] thread_0_wire$33;
  logic[31:0] thread_0_wire$31;
  logic[31:0] thread_0_wire$30;
  logic[31:0] thread_0_wire$29;
  logic[0:0] thread_0_wire$28;
  logic[4:0] thread_0_wire$26;
  logic[0:0] thread_0_wire$25;
  logic[31:0] thread_0_wire$23;
  logic[0:0] thread_0_wire$22;
  logic[31:0] thread_0_wire$20;
  logic[31:0] thread_0_wire$19;
  logic[0:0] thread_0_wire$18;
  logic[3:0] thread_0_wire$17;
  logic[0:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$15;
  logic[0:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$13;
  logic[0:0] thread_0_wire$12;
  logic[31:0] thread_0_wire$11;
  logic[4:0] thread_0_wire$10;
  logic[4:0] thread_0_wire$9;
  logic[0:0] thread_0_wire$8;
  logic[0:0] thread_0_wire$7;
  logic[31:0] thread_0_wire$6;
  logic[31:0] thread_0_wire$5;
  logic[31:0] thread_0_wire$4;
  logic[185:0] thread_0_wire$3;
  logic[32:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$1;
  logic[31:0] thread_0_wire$0;
  assign thread_0_wire$0 = prev_b_target_q;
  assign thread_0_wire$1 = prev_b_taken_q;
  assign thread_0_wire$2 = {thread_0_wire$1, thread_0_wire$0};
  assign thread_0_wire$3 = _ep_in_req_0;
  assign thread_0_wire$4 = thread_0_wire$3[122 +: 32];
  assign thread_0_wire$5 = thread_0_wire$3[90 +: 32];
  assign thread_0_wire$6 = thread_0_wire$3[58 +: 32];
  assign thread_0_wire$7 = thread_0_wire$3[6 +: 1];
  assign thread_0_wire$8 = thread_0_wire$3[5 +: 1];
  assign thread_0_wire$9 = thread_0_wire$3[11 +: 5];
  assign thread_0_wire$10 = thread_0_wire$3[16 +: 5];
  assign thread_0_wire$11 = thread_0_wire$3[26 +: 32];
  assign thread_0_wire$12 = thread_0_wire$3[4 +: 1];
  assign thread_0_wire$13 = thread_0_wire$3[3 +: 1];
  assign thread_0_wire$14 = thread_0_wire$3[2 +: 1];
  assign thread_0_wire$15 = thread_0_wire$3[1 +: 1];
  assign thread_0_wire$16 = thread_0_wire$3[0 +: 1];
  assign thread_0_wire$17 = thread_0_wire$3[7 +: 4];
  assign thread_0_wire$18 = thread_0_wire$17[0 +: 1];
  assign thread_0_wire$19 = thread_0_wire$11 + thread_0_wire$11;
  assign thread_0_wire$20 = thread_0_wire$19 + thread_0_wire$19;
  localparam logic[0:0] thread_0_wire$21 = 1'b1;
  assign thread_0_wire$22 = thread_0_wire$7 == thread_0_wire$21;
  assign thread_0_wire$23 = (thread_0_wire$22) ? thread_0_wire$6 : thread_0_wire$5;
  localparam logic[0:0] thread_0_wire$24 = 1'b1;
  assign thread_0_wire$25 = thread_0_wire$8 == thread_0_wire$24;
  assign thread_0_wire$26 = (thread_0_wire$25) ? thread_0_wire$9 : thread_0_wire$10;
  localparam logic[0:0] thread_0_wire$27 = 1'b1;
  assign thread_0_wire$28 = thread_0_wire$18 == thread_0_wire$27;
  assign thread_0_wire$29 = thread_0_wire$4 - thread_0_wire$23;
  assign thread_0_wire$30 = thread_0_wire$4 + thread_0_wire$23;
  assign thread_0_wire$31 = (thread_0_wire$28) ? thread_0_wire$29 : thread_0_wire$30;
  localparam logic[31:0] thread_0_wire$32 = 32'd0;
  assign thread_0_wire$33 = thread_0_wire$4 == thread_0_wire$32;
  assign thread_0_wire$34 = thread_0_wire$16 & thread_0_wire$33;
  assign thread_0_wire$35 = {thread_0_wire$31, thread_0_wire$5, thread_0_wire$26, thread_0_wire$12, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15};
  assign thread_0_wire$36 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$37 = 1'b1;
  assign thread_0_wire$38 = _ep_branch_res_0;
  assign thread_0_wire$39 = temp_b_taken_q;
  assign thread_0_wire$40 = temp_b_target_q;
  for (genvar i = 0; i < 12; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_11_1_q, _thread_0_event_counter_11_1_n;
  logic _thread_0_event_counter_10_1_q, _thread_0_event_counter_10_1_n;
  logic _thread_0_event_counter_9_1_q, _thread_0_event_counter_9_1_n;
  logic _thread_0_event_syncstate_8_q, _thread_0_event_syncstate_8_n;
  logic _thread_0_event_syncstate_7_q, _thread_0_event_syncstate_7_n;
  logic _thread_0_event_syncstate_6_q, _thread_0_event_syncstate_6_n;
  logic _thread_0_event_syncstate_5_q, _thread_0_event_syncstate_5_n;
  logic _thread_0_event_counter_4_1_q, _thread_0_event_counter_4_1_n;
  logic _thread_0_event_counter_3_1_q, _thread_0_event_counter_3_1_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[11].event_current = _thread_0_event_counter_11_1_q;
  assign _thread_0_event_counter_11_1_n = EVENTS0[10].event_current;
  assign EVENTS0[10].event_current = _thread_0_event_counter_10_1_q;
  assign _thread_0_event_counter_10_1_n = EVENTS0[9].event_current;
  assign EVENTS0[9].event_current = _thread_0_event_counter_9_1_q;
  assign _thread_0_event_counter_9_1_n = EVENTS0[8].event_current;
  assign EVENTS0[8].event_current = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_8_n = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && !_ep_branch_res_valid;
  assign EVENTS0[7].event_current = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_7_n = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && !_ep_in_res_ack;
  assign EVENTS0[6].event_current = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_6_n = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q) && !_ep_out_res_valid;
  assign EVENTS0[5].event_current = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_5_n = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q) && !_ep_out_req_ack;
  assign EVENTS0[4].event_current = _thread_0_event_counter_4_1_q;
  assign _thread_0_event_counter_4_1_n = EVENTS0[3].event_current;
  assign EVENTS0[3].event_current = _thread_0_event_counter_3_1_q;
  assign _thread_0_event_counter_3_1_n = EVENTS0[2].event_current;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_in_req_valid;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_branch_req_ack;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_branch_req_ack;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[11].event_current;
  assign _ep_in_req_ack = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_out_res_ack = (EVENTS0[5].event_current || _thread_0_event_syncstate_6_q);
  assign _ep_branch_res_ack = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q);
  assign _ep_in_res_valid = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q);
  assign _ep_in_res_0 = thread_0_wire$37;
  assign _ep_out_req_valid = (EVENTS0[4].event_current || _thread_0_event_syncstate_5_q);
  assign _ep_out_req_0 = thread_0_wire$35;
  assign _ep_branch_req_valid = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_branch_req_0 = thread_0_wire$2;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      prev_b_taken_q <= '0;
      prev_b_target_q <= '0;
      temp_b_taken_q <= '0;
      temp_b_target_q <= '0;
      _thread_0_event_counter_11_1_q <= '0;
      _thread_0_event_counter_10_1_q <= '0;
      _thread_0_event_counter_9_1_q <= '0;
      _thread_0_event_syncstate_8_q <= '0;
      _thread_0_event_syncstate_7_q <= '0;
      _thread_0_event_syncstate_6_q <= '0;
      _thread_0_event_syncstate_5_q <= '0;
      _thread_0_event_counter_4_1_q <= '0;
      _thread_0_event_counter_3_1_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[9].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$40;
      end
      if (EVENTS0[8].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$39;
      end
      if (EVENTS0[3].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$20;
      end
      if (EVENTS0[2].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$34;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_11_1_q <= _thread_0_event_counter_11_1_n;
      _thread_0_event_counter_10_1_q <= _thread_0_event_counter_10_1_n;
      _thread_0_event_counter_9_1_q <= _thread_0_event_counter_9_1_n;
      _thread_0_event_syncstate_8_q <= _thread_0_event_syncstate_8_n;
      _thread_0_event_syncstate_7_q <= _thread_0_event_syncstate_7_n;
      _thread_0_event_syncstate_6_q <= _thread_0_event_syncstate_6_n;
      _thread_0_event_syncstate_5_q <= _thread_0_event_syncstate_5_n;
      _thread_0_event_counter_4_1_q <= _thread_0_event_counter_4_1_n;
      _thread_0_event_counter_3_1_q <= _thread_0_event_counter_3_1_n;
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
  input logic[63:0] _ep_in_req_0,
  input logic[0:0] _ep_in_res_ack,
  output logic[0:0] _ep_in_res_valid,
  output logic[0:0] _ep_in_res_0,
  input logic[0:0] _ep_out_req_ack,
  output logic[0:0] _ep_out_req_valid,
  output logic[185:0] _ep_out_req_0,
  output logic[0:0] _ep_out_res_ack,
  input logic[0:0] _ep_out_res_valid,
  input logic[0:0] _ep_out_res_0,
  output logic[0:0] _ep_wb_req_ack,
  input logic[0:0] _ep_wb_req_valid,
  input logic[37:0] _ep_wb_req_0,
  input logic[0:0] _ep_wb_res_ack,
  output logic[0:0] _ep_wb_res_valid,
  output logic[0:0] _ep_wb_res_0
);
  logic[1023:0] regs_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[0:0] thread_0_wire$75;
  logic[185:0] thread_0_wire$74;
  logic[31:0] thread_0_wire$73;
  logic[10:0] thread_0_wire$72;
  logic[10:0] thread_0_wire$70;
  logic[9:0] thread_0_wire$68;
  logic[9:0] thread_0_wire$66;
  logic[1023:0] thread_0_wire$64;
  logic[31:0] thread_0_wire$63;
  logic[10:0] thread_0_wire$62;
  logic[10:0] thread_0_wire$60;
  logic[9:0] thread_0_wire$58;
  logic[9:0] thread_0_wire$56;
  logic[1023:0] thread_0_wire$54;
  logic[10:0] thread_0_wire$52;
  logic[10:0] thread_0_wire$50;
  logic[9:0] thread_0_wire$48;
  logic[9:0] thread_0_wire$46;
  logic[0:0] thread_0_wire$44;
  logic[31:0] thread_0_wire$42;
  logic[0:0] thread_0_wire$41;
  logic[31:0] thread_0_wire$39;
  logic[31:0] thread_0_wire$38;
  logic[0:0] thread_0_wire$36;
  logic[31:0] thread_0_wire$34;
  logic[0:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$31;
  logic[0:0] thread_0_wire$30;
  logic[3:0] thread_0_wire$29;
  logic[0:0] thread_0_wire$26;
  logic[0:0] thread_0_wire$24;
  logic[0:0] thread_0_wire$23;
  logic[0:0] thread_0_wire$21;
  logic[0:0] thread_0_wire$19;
  logic[0:0] thread_0_wire$17;
  logic[0:0] thread_0_wire$15;
  logic[4:0] thread_0_wire$13;
  logic[4:0] thread_0_wire$12;
  logic[4:0] thread_0_wire$11;
  logic[5:0] thread_0_wire$10;
  logic[5:0] thread_0_wire$9;
  logic[31:0] thread_0_wire$8;
  logic[31:0] thread_0_wire$6;
  logic[31:0] thread_0_wire$5;
  logic[31:0] thread_0_wire$4;
  logic[4:0] thread_0_wire$3;
  logic[0:0] thread_0_wire$2;
  logic[63:0] thread_0_wire$1;
  logic[37:0] thread_0_wire$0;
  assign thread_0_wire$0 = _ep_wb_req_0;
  assign thread_0_wire$1 = _ep_in_req_0;
  assign thread_0_wire$2 = thread_0_wire$0[0 +: 1];
  assign thread_0_wire$3 = thread_0_wire$0[1 +: 5];
  assign thread_0_wire$4 = thread_0_wire$0[6 +: 32];
  assign thread_0_wire$5 = thread_0_wire$1[0 +: 32];
  assign thread_0_wire$6 = thread_0_wire$1[32 +: 32];
  localparam logic[31:0] thread_0_wire$7 = 32'h001fffff;
  assign thread_0_wire$8 = thread_0_wire$5 & thread_0_wire$7;
  assign thread_0_wire$9 = thread_0_wire$5[26 +: 6];
  assign thread_0_wire$10 = thread_0_wire$5[0 +: 6];
  assign thread_0_wire$11 = thread_0_wire$5[11 +: 5];
  assign thread_0_wire$12 = thread_0_wire$5[16 +: 5];
  assign thread_0_wire$13 = thread_0_wire$5[21 +: 5];
  localparam logic[5:0] thread_0_wire$14 = 6'b000000;
  assign thread_0_wire$15 = thread_0_wire$9 == thread_0_wire$14;
  localparam logic[5:0] thread_0_wire$16 = 6'b100011;
  assign thread_0_wire$17 = thread_0_wire$9 == thread_0_wire$16;
  localparam logic[5:0] thread_0_wire$18 = 6'b101011;
  assign thread_0_wire$19 = thread_0_wire$9 == thread_0_wire$18;
  localparam logic[5:0] thread_0_wire$20 = 6'b000010;
  assign thread_0_wire$21 = thread_0_wire$9 == thread_0_wire$20;
  localparam logic[5:0] thread_0_wire$22 = 6'b100010;
  assign thread_0_wire$23 = thread_0_wire$10 == thread_0_wire$22;
  assign thread_0_wire$24 = thread_0_wire$15 & thread_0_wire$23;
  localparam logic[0:0] thread_0_wire$25 = 1'b1;
  assign thread_0_wire$26 = thread_0_wire$24 == thread_0_wire$25;
  localparam logic[3:0] thread_0_wire$27 = 4'd1;
  localparam logic[3:0] thread_0_wire$28 = 4'd0;
  assign thread_0_wire$29 = (thread_0_wire$26) ? thread_0_wire$27 : thread_0_wire$28;
  assign thread_0_wire$30 = thread_0_wire$17 | thread_0_wire$19;
  assign thread_0_wire$31 = thread_0_wire$15 | thread_0_wire$17;
  assign thread_0_wire$32 = thread_0_wire$5[15 +: 1];
  localparam logic[31:0] thread_0_wire$33 = 32'h0000ffff;
  assign thread_0_wire$34 = thread_0_wire$5 & thread_0_wire$33;
  localparam logic[0:0] thread_0_wire$35 = 1'b1;
  assign thread_0_wire$36 = thread_0_wire$32 == thread_0_wire$35;
  localparam logic[31:0] thread_0_wire$37 = 32'hffff0000;
  assign thread_0_wire$38 = thread_0_wire$34 | thread_0_wire$37;
  assign thread_0_wire$39 = (thread_0_wire$36) ? thread_0_wire$38 : thread_0_wire$34;
  localparam logic[0:0] thread_0_wire$40 = 1'b1;
  assign thread_0_wire$41 = thread_0_wire$21 == thread_0_wire$40;
  assign thread_0_wire$42 = (thread_0_wire$41) ? thread_0_wire$8 : thread_0_wire$39;
  localparam logic[0:0] thread_0_wire$43 = 1'b1;
  assign thread_0_wire$44 = thread_0_wire$2 == thread_0_wire$43;
  localparam logic[4:0] thread_0_wire$45 = 5'd0;
  assign thread_0_wire$46 = {thread_0_wire$45, thread_0_wire$3};
  localparam logic[9:0] thread_0_wire$47 = 10'd32;
  assign thread_0_wire$48 = thread_0_wire$46 * thread_0_wire$47;
  localparam logic[0:0] thread_0_wire$49 = 1'd0;
  assign thread_0_wire$50 = {thread_0_wire$49, thread_0_wire$48};
  localparam logic[10:0] thread_0_wire$51 = 11'd0;
  assign thread_0_wire$52 = thread_0_wire$50 + thread_0_wire$51;
  localparam logic[31:0] thread_0_wire$53 = 32'd0;
  assign thread_0_wire$54 = regs_q;
  localparam logic[4:0] thread_0_wire$55 = 5'd0;
  assign thread_0_wire$56 = {thread_0_wire$55, thread_0_wire$12};
  localparam logic[9:0] thread_0_wire$57 = 10'd32;
  assign thread_0_wire$58 = thread_0_wire$56 * thread_0_wire$57;
  localparam logic[0:0] thread_0_wire$59 = 1'd0;
  assign thread_0_wire$60 = {thread_0_wire$59, thread_0_wire$58};
  localparam logic[10:0] thread_0_wire$61 = 11'd0;
  assign thread_0_wire$62 = thread_0_wire$60 + thread_0_wire$61;
  assign thread_0_wire$63 = thread_0_wire$54[thread_0_wire$62 +: 32];
  assign thread_0_wire$64 = regs_q;
  localparam logic[4:0] thread_0_wire$65 = 5'd0;
  assign thread_0_wire$66 = {thread_0_wire$65, thread_0_wire$13};
  localparam logic[9:0] thread_0_wire$67 = 10'd32;
  assign thread_0_wire$68 = thread_0_wire$66 * thread_0_wire$67;
  localparam logic[0:0] thread_0_wire$69 = 1'd0;
  assign thread_0_wire$70 = {thread_0_wire$69, thread_0_wire$68};
  localparam logic[10:0] thread_0_wire$71 = 11'd0;
  assign thread_0_wire$72 = thread_0_wire$70 + thread_0_wire$71;
  assign thread_0_wire$73 = thread_0_wire$64[thread_0_wire$72 +: 32];
  assign thread_0_wire$74 = {thread_0_wire$6, thread_0_wire$73, thread_0_wire$63, thread_0_wire$42, thread_0_wire$8, thread_0_wire$13, thread_0_wire$12, thread_0_wire$11, thread_0_wire$29, thread_0_wire$30, thread_0_wire$15, thread_0_wire$17, thread_0_wire$19, thread_0_wire$31, thread_0_wire$17, thread_0_wire$21};
  assign thread_0_wire$75 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$76 = 1'b1;
  localparam logic[0:0] thread_0_wire$77 = 1'b1;
  for (genvar i = 0; i < 13; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_12_1_q, _thread_0_event_counter_12_1_n;
  logic _thread_0_event_syncstate_11_q, _thread_0_event_syncstate_11_n;
  logic _thread_0_event_syncstate_10_q, _thread_0_event_syncstate_10_n;
  logic _thread_0_event_syncstate_9_q, _thread_0_event_syncstate_9_n;
  logic _thread_0_event_syncstate_8_q, _thread_0_event_syncstate_8_n;
  logic _thread_0_event_counter_6_1_q, _thread_0_event_counter_6_1_n;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[12].event_current = _thread_0_event_counter_12_1_q;
  assign _thread_0_event_counter_12_1_n = EVENTS0[11].event_current;
  assign EVENTS0[11].event_current = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_11_n = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) && !_ep_in_res_ack;
  assign EVENTS0[10].event_current = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_10_n = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q) && !_ep_wb_res_ack;
  assign EVENTS0[9].event_current = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_9_n = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) && !_ep_out_res_valid;
  assign EVENTS0[8].event_current = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_8_n = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && !_ep_out_req_ack;
  assign EVENTS0[7].event_current = EVENTS0[6].event_current || EVENTS0[3].event_current;
  assign EVENTS0[6].event_current = _thread_0_event_counter_6_1_q;
  assign _thread_0_event_counter_6_1_n = EVENTS0[5].event_current;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = EVENTS0[2].event_current && thread_0_wire$44;
  assign EVENTS0[3].event_current = EVENTS0[2].event_current && !thread_0_wire$44;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_in_req_valid;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_wb_req_valid;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_wb_req_valid;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[12].event_current;
  assign _ep_in_req_ack = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_wb_req_ack = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_out_res_ack = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q);
  assign _ep_in_res_valid = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q);
  assign _ep_in_res_0 = thread_0_wire$77;
  assign _ep_out_req_valid = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q);
  assign _ep_out_req_0 = thread_0_wire$74;
  assign _ep_wb_res_valid = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q);
  assign _ep_wb_res_0 = thread_0_wire$76;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      regs_q <= '0;
      _thread_0_event_counter_12_1_q <= '0;
      _thread_0_event_syncstate_11_q <= '0;
      _thread_0_event_syncstate_10_q <= '0;
      _thread_0_event_syncstate_9_q <= '0;
      _thread_0_event_syncstate_8_q <= '0;
      _thread_0_event_counter_6_1_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[5].event_current) begin
        regs_q[0 +: 32] <= thread_0_wire$53;
      end
      if (EVENTS0[4].event_current) begin
        regs_q[thread_0_wire$52 +: 32] <= thread_0_wire$4;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_12_1_q <= _thread_0_event_counter_12_1_n;
      _thread_0_event_syncstate_11_q <= _thread_0_event_syncstate_11_n;
      _thread_0_event_syncstate_10_q <= _thread_0_event_syncstate_10_n;
      _thread_0_event_syncstate_9_q <= _thread_0_event_syncstate_9_n;
      _thread_0_event_syncstate_8_q <= _thread_0_event_syncstate_8_n;
      _thread_0_event_counter_6_1_q <= _thread_0_event_counter_6_1_n;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
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
  output logic[63:0] _ep_out_req_0,
  output logic[0:0] _ep_out_res_ack,
  input logic[0:0] _ep_out_res_valid,
  input logic[0:0] _ep_out_res_0,
  output logic[0:0] _ep_branch_req_ack,
  input logic[0:0] _ep_branch_req_valid,
  input logic[32:0] _ep_branch_req_0,
  input logic[0:0] _ep_branch_res_ack,
  output logic[0:0] _ep_branch_res_valid,
  output logic[0:0] _ep_branch_res_0
);
  logic[8191:0] imem_q;
  logic[0:0] init_done_q;
  logic[31:0] pc_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin : _proc_transition
    if (~rst_ni) begin
    end
  end
  logic[31:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$33;
  logic[63:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$30;
  logic[63:0] thread_0_wire$29;
  logic[0:0] thread_0_wire$27;
  logic[31:0] thread_0_wire$25;
  logic[13:0] thread_0_wire$24;
  logic[13:0] thread_0_wire$22;
  logic[12:0] thread_0_wire$20;
  logic[12:0] thread_0_wire$18;
  logic[8191:0] thread_0_wire$16;
  logic[7:0] thread_0_wire$15;
  logic[31:0] thread_0_wire$14;
  logic[31:0] thread_0_wire$13;
  logic[0:0] thread_0_wire$12;
  logic[32:0] thread_0_wire$11;
  logic[0:0] thread_0_wire$2;
  logic[0:0] thread_0_wire$0;
  assign thread_0_wire$0 = init_done_q;
  localparam logic[0:0] thread_0_wire$1 = 1'b0;
  assign thread_0_wire$2 = thread_0_wire$0 == thread_0_wire$1;
  localparam logic[31:0] thread_0_wire$3 = 32'h8c010000;
  localparam logic[31:0] thread_0_wire$4 = 32'h00201020;
  localparam logic[31:0] thread_0_wire$5 = 32'h00411022;
  localparam logic[31:0] thread_0_wire$6 = 32'h08400005;
  localparam logic[31:0] thread_0_wire$7 = 32'h00411820;
  localparam logic[31:0] thread_0_wire$8 = 32'h00412020;
  localparam logic[31:0] thread_0_wire$9 = 32'hac810000;
  localparam logic[0:0] thread_0_wire$10 = 1'b1;
  assign thread_0_wire$11 = _ep_branch_req_0;
  assign thread_0_wire$12 = thread_0_wire$11[32 +: 1];
  assign thread_0_wire$13 = thread_0_wire$11[0 +: 32];
  assign thread_0_wire$14 = pc_q;
  assign thread_0_wire$15 = thread_0_wire$14[2 +: 8];
  assign thread_0_wire$16 = imem_q;
  localparam logic[4:0] thread_0_wire$17 = 5'd0;
  assign thread_0_wire$18 = {thread_0_wire$17, thread_0_wire$15};
  localparam logic[12:0] thread_0_wire$19 = 13'd32;
  assign thread_0_wire$20 = thread_0_wire$18 * thread_0_wire$19;
  localparam logic[0:0] thread_0_wire$21 = 1'd0;
  assign thread_0_wire$22 = {thread_0_wire$21, thread_0_wire$20};
  localparam logic[13:0] thread_0_wire$23 = 14'd0;
  assign thread_0_wire$24 = thread_0_wire$22 + thread_0_wire$23;
  assign thread_0_wire$25 = thread_0_wire$16[thread_0_wire$24 +: 32];
  localparam logic[0:0] thread_0_wire$26 = 1'b1;
  assign thread_0_wire$27 = thread_0_wire$12 == thread_0_wire$26;
  localparam logic[31:0] thread_0_wire$28 = 32'd0;
  assign thread_0_wire$29 = {thread_0_wire$14, thread_0_wire$28};
  assign thread_0_wire$30 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$31 = 1'b1;
  assign thread_0_wire$32 = {thread_0_wire$14, thread_0_wire$25};
  assign thread_0_wire$33 = _ep_out_res_0;
  localparam logic[31:0] thread_0_wire$34 = 32'd4;
  assign thread_0_wire$35 = thread_0_wire$14 + thread_0_wire$34;
  localparam logic[0:0] thread_0_wire$36 = 1'b1;
  for (genvar i = 0; i < 24; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_23_1_q, _thread_0_event_counter_23_1_n;
  logic _thread_0_event_syncstate_21_q, _thread_0_event_syncstate_21_n;
  logic _thread_0_event_counter_20_1_q, _thread_0_event_counter_20_1_n;
  logic _thread_0_event_syncstate_19_q, _thread_0_event_syncstate_19_n;
  logic _thread_0_event_syncstate_18_q, _thread_0_event_syncstate_18_n;
  logic _thread_0_event_syncstate_16_q, _thread_0_event_syncstate_16_n;
  logic _thread_0_event_counter_15_1_q, _thread_0_event_counter_15_1_n;
  logic _thread_0_event_syncstate_14_q, _thread_0_event_syncstate_14_n;
  logic _thread_0_event_syncstate_13_q, _thread_0_event_syncstate_13_n;
  logic _thread_0_event_syncstate_11_q, _thread_0_event_syncstate_11_n;
  logic _thread_0_event_counter_9_1_q, _thread_0_event_counter_9_1_n;
  logic _thread_0_event_counter_8_1_q, _thread_0_event_counter_8_1_n;
  logic _thread_0_event_counter_7_1_q, _thread_0_event_counter_7_1_n;
  logic _thread_0_event_counter_6_1_q, _thread_0_event_counter_6_1_n;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_counter_4_1_q, _thread_0_event_counter_4_1_n;
  logic _thread_0_event_counter_3_1_q, _thread_0_event_counter_3_1_n;
  logic _thread_0_event_counter_2_1_q, _thread_0_event_counter_2_1_n;
  assign EVENTS0[23].event_current = _thread_0_event_counter_23_1_q;
  assign _thread_0_event_counter_23_1_n = EVENTS0[22].event_current;
  assign EVENTS0[22].event_current = EVENTS0[21].event_current || EVENTS0[16].event_current || EVENTS0[9].event_current;
  assign EVENTS0[21].event_current = (EVENTS0[20].event_current || _thread_0_event_syncstate_21_q) && _ep_branch_res_ack;
    assign _thread_0_event_syncstate_21_n = (EVENTS0[20].event_current || _thread_0_event_syncstate_21_q) && !_ep_branch_res_ack;
  assign EVENTS0[20].event_current = _thread_0_event_counter_20_1_q;
  assign _thread_0_event_counter_20_1_n = EVENTS0[19].event_current;
  assign EVENTS0[19].event_current = (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_19_n = (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q) && !_ep_out_res_valid;
  assign EVENTS0[18].event_current = (EVENTS0[17].event_current || _thread_0_event_syncstate_18_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_18_n = (EVENTS0[17].event_current || _thread_0_event_syncstate_18_q) && !_ep_out_req_ack;
  assign EVENTS0[17].event_current = EVENTS0[11].event_current && thread_0_wire$27;
  assign EVENTS0[16].event_current = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && _ep_branch_res_ack;
    assign _thread_0_event_syncstate_16_n = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && !_ep_branch_res_ack;
  assign EVENTS0[15].event_current = _thread_0_event_counter_15_1_q;
  assign _thread_0_event_counter_15_1_n = EVENTS0[14].event_current;
  assign EVENTS0[14].event_current = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_14_n = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) && !_ep_out_res_valid;
  assign EVENTS0[13].event_current = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_13_n = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) && !_ep_out_req_ack;
  assign EVENTS0[12].event_current = EVENTS0[11].event_current && !thread_0_wire$27;
  assign EVENTS0[11].event_current = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) && _ep_branch_req_valid;
    assign _thread_0_event_syncstate_11_n = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) && !_ep_branch_req_valid;
  assign EVENTS0[10].event_current = EVENTS0[0].event_current && !thread_0_wire$2;
  assign EVENTS0[9].event_current = _thread_0_event_counter_9_1_q;
  assign _thread_0_event_counter_9_1_n = EVENTS0[8].event_current;
  assign EVENTS0[8].event_current = _thread_0_event_counter_8_1_q;
  assign _thread_0_event_counter_8_1_n = EVENTS0[7].event_current;
  assign EVENTS0[7].event_current = _thread_0_event_counter_7_1_q;
  assign _thread_0_event_counter_7_1_n = EVENTS0[6].event_current;
  assign EVENTS0[6].event_current = _thread_0_event_counter_6_1_q;
  assign _thread_0_event_counter_6_1_n = EVENTS0[5].event_current;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = _thread_0_event_counter_4_1_q;
  assign _thread_0_event_counter_4_1_n = EVENTS0[3].event_current;
  assign EVENTS0[3].event_current = _thread_0_event_counter_3_1_q;
  assign _thread_0_event_counter_3_1_n = EVENTS0[2].event_current;
  assign EVENTS0[2].event_current = _thread_0_event_counter_2_1_q;
  assign _thread_0_event_counter_2_1_n = EVENTS0[1].event_current;
  assign EVENTS0[1].event_current = EVENTS0[0].event_current && thread_0_wire$2;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[23].event_current;
  assign _ep_out_res_ack = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) || (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q);
  assign _ep_branch_req_ack = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q);
  assign _ep_out_req_valid = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) || (EVENTS0[17].event_current || _thread_0_event_syncstate_18_q);
  assign _ep_branch_res_valid = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) || (EVENTS0[20].event_current || _thread_0_event_syncstate_21_q);
  logic[0:0] _ep_branch_res_valid_selector_q, _ep_branch_res_valid_selector_n;
  assign _ep_branch_res_0 = (_ep_branch_res_valid_selector_n == 1'd0) ? thread_0_wire$36 : (_ep_branch_res_valid_selector_n == 1'd1) ? thread_0_wire$31 : '0;
  logic[0:0] _ep_out_req_valid_selector_q, _ep_out_req_valid_selector_n;
  assign _ep_out_req_0 = (_ep_out_req_valid_selector_n == 1'd0) ? thread_0_wire$32 : (_ep_out_req_valid_selector_n == 1'd1) ? thread_0_wire$29 : '0;
  always_comb begin: _thread_0_selector
    _ep_branch_res_valid_selector_n = _ep_branch_res_valid_selector_q;
    if ((EVENTS0[15].event_current || _thread_0_event_syncstate_16_q)) _ep_branch_res_valid_selector_n = 1'd0;
    if ((EVENTS0[20].event_current || _thread_0_event_syncstate_21_q)) _ep_branch_res_valid_selector_n = 1'd1;
    _ep_out_req_valid_selector_n = _ep_out_req_valid_selector_q;
    if ((EVENTS0[12].event_current || _thread_0_event_syncstate_13_q)) _ep_out_req_valid_selector_n = 1'd0;
    if ((EVENTS0[17].event_current || _thread_0_event_syncstate_18_q)) _ep_out_req_valid_selector_n = 1'd1;
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_selector_trans
    if (~rst_ni) begin
      _ep_branch_res_valid_selector_q <= '0;
      _ep_out_req_valid_selector_q <= '0;
    end else begin
      _ep_branch_res_valid_selector_q <= _ep_branch_res_valid_selector_n;
      _ep_out_req_valid_selector_q <= _ep_out_req_valid_selector_n;
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      imem_q <= '0;
      init_done_q <= '0;
      pc_q <= '0;
      _thread_0_event_counter_23_1_q <= '0;
      _thread_0_event_syncstate_21_q <= '0;
      _thread_0_event_counter_20_1_q <= '0;
      _thread_0_event_syncstate_19_q <= '0;
      _thread_0_event_syncstate_18_q <= '0;
      _thread_0_event_syncstate_16_q <= '0;
      _thread_0_event_counter_15_1_q <= '0;
      _thread_0_event_syncstate_14_q <= '0;
      _thread_0_event_syncstate_13_q <= '0;
      _thread_0_event_syncstate_11_q <= '0;
      _thread_0_event_counter_9_1_q <= '0;
      _thread_0_event_counter_8_1_q <= '0;
      _thread_0_event_counter_7_1_q <= '0;
      _thread_0_event_counter_6_1_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_counter_4_1_q <= '0;
      _thread_0_event_counter_3_1_q <= '0;
      _thread_0_event_counter_2_1_q <= '0;
    end else begin
      if (EVENTS0[19].event_current) begin
        pc_q[0 +: 32] <= thread_0_wire$13;
      end
      if (EVENTS0[14].event_current) begin
        pc_q[0 +: 32] <= thread_0_wire$35;
      end
      if (EVENTS0[8].event_current) begin
        init_done_q[0 +: 1] <= thread_0_wire$10;
      end
      if (EVENTS0[7].event_current) begin
        imem_q[192 +: 32] <= thread_0_wire$9;
      end
      if (EVENTS0[6].event_current) begin
        imem_q[160 +: 32] <= thread_0_wire$8;
      end
      if (EVENTS0[5].event_current) begin
        imem_q[128 +: 32] <= thread_0_wire$7;
      end
      if (EVENTS0[4].event_current) begin
        imem_q[96 +: 32] <= thread_0_wire$6;
      end
      if (EVENTS0[3].event_current) begin
        imem_q[64 +: 32] <= thread_0_wire$5;
      end
      if (EVENTS0[2].event_current) begin
        imem_q[32 +: 32] <= thread_0_wire$4;
      end
      if (EVENTS0[1].event_current) begin
        imem_q[0 +: 32] <= thread_0_wire$3;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_23_1_q <= _thread_0_event_counter_23_1_n;
      _thread_0_event_syncstate_21_q <= _thread_0_event_syncstate_21_n;
      _thread_0_event_counter_20_1_q <= _thread_0_event_counter_20_1_n;
      _thread_0_event_syncstate_19_q <= _thread_0_event_syncstate_19_n;
      _thread_0_event_syncstate_18_q <= _thread_0_event_syncstate_18_n;
      _thread_0_event_syncstate_16_q <= _thread_0_event_syncstate_16_n;
      _thread_0_event_counter_15_1_q <= _thread_0_event_counter_15_1_n;
      _thread_0_event_syncstate_14_q <= _thread_0_event_syncstate_14_n;
      _thread_0_event_syncstate_13_q <= _thread_0_event_syncstate_13_n;
      _thread_0_event_syncstate_11_q <= _thread_0_event_syncstate_11_n;
      _thread_0_event_counter_9_1_q <= _thread_0_event_counter_9_1_n;
      _thread_0_event_counter_8_1_q <= _thread_0_event_counter_8_1_n;
      _thread_0_event_counter_7_1_q <= _thread_0_event_counter_7_1_n;
      _thread_0_event_counter_6_1_q <= _thread_0_event_counter_6_1_n;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_counter_4_1_q <= _thread_0_event_counter_4_1_n;
      _thread_0_event_counter_3_1_q <= _thread_0_event_counter_3_1_n;
      _thread_0_event_counter_2_1_q <= _thread_0_event_counter_2_1_n;
    end
  end
endmodule
module MipsPipeline (
  input logic[0:0] clk_i,
  input logic[0:0] rst_ni
);
  logic[0:0] _if_id_le_req_ack;
  logic[0:0] _if_id_le_req_valid;
  logic[63:0] _if_id_le_req_0;
  logic[0:0] _if_id_le_res_ack;
  logic[0:0] _if_id_le_res_valid;
  logic[0:0] _if_id_le_res_0;
  logic[0:0] _id_ex_le_req_ack;
  logic[0:0] _id_ex_le_req_valid;
  logic[185:0] _id_ex_le_req_0;
  logic[0:0] _id_ex_le_res_ack;
  logic[0:0] _id_ex_le_res_valid;
  logic[0:0] _id_ex_le_res_0;
  logic[0:0] _ex_mem_le_req_ack;
  logic[0:0] _ex_mem_le_req_valid;
  logic[72:0] _ex_mem_le_req_0;
  logic[0:0] _ex_mem_le_res_ack;
  logic[0:0] _ex_mem_le_res_valid;
  logic[0:0] _ex_mem_le_res_0;
  logic[0:0] _mem_wb_le_req_ack;
  logic[0:0] _mem_wb_le_req_valid;
  logic[70:0] _mem_wb_le_req_0;
  logic[0:0] _mem_wb_le_res_ack;
  logic[0:0] _mem_wb_le_res_valid;
  logic[0:0] _mem_wb_le_res_0;
  logic[0:0] _wb_id_le_req_ack;
  logic[0:0] _wb_id_le_req_valid;
  logic[37:0] _wb_id_le_req_0;
  logic[0:0] _wb_id_le_res_ack;
  logic[0:0] _wb_id_le_res_valid;
  logic[0:0] _wb_id_le_res_0;
  logic[0:0] _branch_le_req_ack;
  logic[0:0] _branch_le_req_valid;
  logic[32:0] _branch_le_req_0;
  logic[0:0] _branch_le_res_ack;
  logic[0:0] _branch_le_res_valid;
  logic[0:0] _branch_le_res_0;
  Fetch _spawn_0 (
    .clk_i,
    .rst_ni
    ,._ep_out_res_valid (_if_id_le_res_valid)
    ,._ep_out_res_ack (_if_id_le_res_ack)
    ,._ep_out_res_0 (_if_id_le_res_0)
    ,._ep_out_req_valid (_if_id_le_req_valid)
    ,._ep_out_req_ack (_if_id_le_req_ack)
    ,._ep_out_req_0 (_if_id_le_req_0)
    ,._ep_branch_res_valid (_branch_le_res_valid)
    ,._ep_branch_res_ack (_branch_le_res_ack)
    ,._ep_branch_res_0 (_branch_le_res_0)
    ,._ep_branch_req_valid (_branch_le_req_valid)
    ,._ep_branch_req_ack (_branch_le_req_ack)
    ,._ep_branch_req_0 (_branch_le_req_0)
  );
  Decode _spawn_1 (
    .clk_i,
    .rst_ni
    ,._ep_in_res_valid (_if_id_le_res_valid)
    ,._ep_in_res_ack (_if_id_le_res_ack)
    ,._ep_in_res_0 (_if_id_le_res_0)
    ,._ep_in_req_valid (_if_id_le_req_valid)
    ,._ep_in_req_ack (_if_id_le_req_ack)
    ,._ep_in_req_0 (_if_id_le_req_0)
    ,._ep_out_res_valid (_id_ex_le_res_valid)
    ,._ep_out_res_ack (_id_ex_le_res_ack)
    ,._ep_out_res_0 (_id_ex_le_res_0)
    ,._ep_out_req_valid (_id_ex_le_req_valid)
    ,._ep_out_req_ack (_id_ex_le_req_ack)
    ,._ep_out_req_0 (_id_ex_le_req_0)
    ,._ep_wb_res_valid (_wb_id_le_res_valid)
    ,._ep_wb_res_ack (_wb_id_le_res_ack)
    ,._ep_wb_res_0 (_wb_id_le_res_0)
    ,._ep_wb_req_valid (_wb_id_le_req_valid)
    ,._ep_wb_req_ack (_wb_id_le_req_ack)
    ,._ep_wb_req_0 (_wb_id_le_req_0)
  );
  Execute _spawn_2 (
    .clk_i,
    .rst_ni
    ,._ep_in_res_valid (_id_ex_le_res_valid)
    ,._ep_in_res_ack (_id_ex_le_res_ack)
    ,._ep_in_res_0 (_id_ex_le_res_0)
    ,._ep_in_req_valid (_id_ex_le_req_valid)
    ,._ep_in_req_ack (_id_ex_le_req_ack)
    ,._ep_in_req_0 (_id_ex_le_req_0)
    ,._ep_out_res_valid (_ex_mem_le_res_valid)
    ,._ep_out_res_ack (_ex_mem_le_res_ack)
    ,._ep_out_res_0 (_ex_mem_le_res_0)
    ,._ep_out_req_valid (_ex_mem_le_req_valid)
    ,._ep_out_req_ack (_ex_mem_le_req_ack)
    ,._ep_out_req_0 (_ex_mem_le_req_0)
    ,._ep_branch_res_valid (_branch_le_res_valid)
    ,._ep_branch_res_ack (_branch_le_res_ack)
    ,._ep_branch_res_0 (_branch_le_res_0)
    ,._ep_branch_req_valid (_branch_le_req_valid)
    ,._ep_branch_req_ack (_branch_le_req_ack)
    ,._ep_branch_req_0 (_branch_le_req_0)
  );
  Memory _spawn_3 (
    .clk_i,
    .rst_ni
    ,._ep_in_res_valid (_ex_mem_le_res_valid)
    ,._ep_in_res_ack (_ex_mem_le_res_ack)
    ,._ep_in_res_0 (_ex_mem_le_res_0)
    ,._ep_in_req_valid (_ex_mem_le_req_valid)
    ,._ep_in_req_ack (_ex_mem_le_req_ack)
    ,._ep_in_req_0 (_ex_mem_le_req_0)
    ,._ep_out_res_valid (_mem_wb_le_res_valid)
    ,._ep_out_res_ack (_mem_wb_le_res_ack)
    ,._ep_out_res_0 (_mem_wb_le_res_0)
    ,._ep_out_req_valid (_mem_wb_le_req_valid)
    ,._ep_out_req_ack (_mem_wb_le_req_ack)
    ,._ep_out_req_0 (_mem_wb_le_req_0)
  );
  Writeback _spawn_4 (
    .clk_i,
    .rst_ni
    ,._ep_in_res_valid (_mem_wb_le_res_valid)
    ,._ep_in_res_ack (_mem_wb_le_res_ack)
    ,._ep_in_res_0 (_mem_wb_le_res_0)
    ,._ep_in_req_valid (_mem_wb_le_req_valid)
    ,._ep_in_req_ack (_mem_wb_le_req_ack)
    ,._ep_in_req_0 (_mem_wb_le_req_0)
    ,._ep_wb_out_res_valid (_wb_id_le_res_valid)
    ,._ep_wb_out_res_ack (_wb_id_le_res_ack)
    ,._ep_wb_out_res_0 (_wb_id_le_res_0)
    ,._ep_wb_out_req_valid (_wb_id_le_req_valid)
    ,._ep_wb_out_req_ack (_wb_id_le_req_ack)
    ,._ep_wb_out_req_0 (_wb_id_le_req_0)
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
