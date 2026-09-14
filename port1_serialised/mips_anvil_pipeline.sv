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
  logic[0:0] thread_0_wire$21;
  logic[4:0] thread_0_wire$20;
  logic[31:0] thread_0_wire$19;
  logic[0:0] thread_0_wire$18;
  logic[0:0] thread_0_wire$16;
  logic[4:0] thread_0_wire$15;
  logic[31:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$13;
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
  localparam logic[0:0] thread_0_wire$12 = 1'b1;
  assign thread_0_wire$13 = _ep_wb_out_res_0;
  assign thread_0_wire$14 = temp_write_data_q;
  assign thread_0_wire$15 = temp_dest_reg_q;
  assign thread_0_wire$16 = temp_reg_write_q;
  localparam logic[0:0] thread_0_wire$17 = 1'b1;
  assign thread_0_wire$18 = _ep_wb_out_res_0;
  assign thread_0_wire$19 = temp_write_data_q;
  assign thread_0_wire$20 = temp_dest_reg_q;
  assign thread_0_wire$21 = temp_reg_write_q;
  for (genvar i = 0; i < 22; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_21_1_q, _thread_0_event_counter_21_1_n;
  logic _thread_0_event_counter_20_1_q, _thread_0_event_counter_20_1_n;
  logic _thread_0_event_counter_18_1_q, _thread_0_event_counter_18_1_n;
  logic _thread_0_event_counter_17_1_q, _thread_0_event_counter_17_1_n;
  logic _thread_0_event_syncstate_16_q, _thread_0_event_syncstate_16_n;
  logic _thread_0_event_syncstate_15_q, _thread_0_event_syncstate_15_n;
  logic _thread_0_event_counter_14_1_q, _thread_0_event_counter_14_1_n;
  logic _thread_0_event_counter_13_1_q, _thread_0_event_counter_13_1_n;
  logic _thread_0_event_counter_12_1_q, _thread_0_event_counter_12_1_n;
  logic _thread_0_event_counter_10_1_q, _thread_0_event_counter_10_1_n;
  logic _thread_0_event_counter_9_1_q, _thread_0_event_counter_9_1_n;
  logic _thread_0_event_syncstate_8_q, _thread_0_event_syncstate_8_n;
  logic _thread_0_event_syncstate_7_q, _thread_0_event_syncstate_7_n;
  logic _thread_0_event_counter_6_1_q, _thread_0_event_counter_6_1_n;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_counter_4_1_q, _thread_0_event_counter_4_1_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[21].event_current = _thread_0_event_counter_21_1_q;
  assign _thread_0_event_counter_21_1_n = EVENTS0[20].event_current;
  assign EVENTS0[20].event_current = _thread_0_event_counter_20_1_q;
  assign _thread_0_event_counter_20_1_n = EVENTS0[19].event_current;
  assign EVENTS0[19].event_current = EVENTS0[18].event_current || EVENTS0[10].event_current;
  assign EVENTS0[18].event_current = _thread_0_event_counter_18_1_q;
  assign _thread_0_event_counter_18_1_n = EVENTS0[17].event_current;
  assign EVENTS0[17].event_current = _thread_0_event_counter_17_1_q;
  assign _thread_0_event_counter_17_1_n = EVENTS0[16].event_current;
  assign EVENTS0[16].event_current = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && _ep_wb_out_res_valid;
    assign _thread_0_event_syncstate_16_n = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && !_ep_wb_out_res_valid;
  assign EVENTS0[15].event_current = (EVENTS0[14].event_current || _thread_0_event_syncstate_15_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_15_n = (EVENTS0[14].event_current || _thread_0_event_syncstate_15_q) && !_ep_in_res_ack;
  assign EVENTS0[14].event_current = _thread_0_event_counter_14_1_q;
  assign _thread_0_event_counter_14_1_n = EVENTS0[13].event_current;
  assign EVENTS0[13].event_current = _thread_0_event_counter_13_1_q;
  assign _thread_0_event_counter_13_1_n = EVENTS0[12].event_current;
  assign EVENTS0[12].event_current = _thread_0_event_counter_12_1_q;
  assign _thread_0_event_counter_12_1_n = EVENTS0[11].event_current;
  assign EVENTS0[11].event_current = EVENTS0[2].event_current && thread_0_wire$11;
  assign EVENTS0[10].event_current = _thread_0_event_counter_10_1_q;
  assign _thread_0_event_counter_10_1_n = EVENTS0[9].event_current;
  assign EVENTS0[9].event_current = _thread_0_event_counter_9_1_q;
  assign _thread_0_event_counter_9_1_n = EVENTS0[8].event_current;
  assign EVENTS0[8].event_current = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && _ep_wb_out_res_valid;
    assign _thread_0_event_syncstate_8_n = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && !_ep_wb_out_res_valid;
  assign EVENTS0[7].event_current = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_7_n = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) && !_ep_in_res_ack;
  assign EVENTS0[6].event_current = _thread_0_event_counter_6_1_q;
  assign _thread_0_event_counter_6_1_n = EVENTS0[5].event_current;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = _thread_0_event_counter_4_1_q;
  assign _thread_0_event_counter_4_1_n = EVENTS0[3].event_current;
  assign EVENTS0[3].event_current = EVENTS0[2].event_current && !thread_0_wire$11;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_in_req_valid;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_wb_out_req_ack;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_wb_out_req_ack;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[21].event_current;
  assign _ep_wb_out_res_ack = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) || (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q);
  assign _ep_in_req_ack = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_in_res_valid = (EVENTS0[6].event_current || _thread_0_event_syncstate_7_q) || (EVENTS0[14].event_current || _thread_0_event_syncstate_15_q);
  assign _ep_wb_out_req_valid = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_wb_out_req_0 = thread_0_wire$3;
  logic[0:0] _ep_in_res_valid_selector_q, _ep_in_res_valid_selector_n;
  assign _ep_in_res_0 = (_ep_in_res_valid_selector_n == 1'd0) ? thread_0_wire$17 : (_ep_in_res_valid_selector_n == 1'd1) ? thread_0_wire$12 : '0;
  always_comb begin: _thread_0_selector
    _ep_in_res_valid_selector_n = _ep_in_res_valid_selector_q;
    if ((EVENTS0[6].event_current || _thread_0_event_syncstate_7_q)) _ep_in_res_valid_selector_n = 1'd0;
    if ((EVENTS0[14].event_current || _thread_0_event_syncstate_15_q)) _ep_in_res_valid_selector_n = 1'd1;
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_selector_trans
    if (~rst_ni) begin
      _ep_in_res_valid_selector_q <= '0;
    end else begin
      _ep_in_res_valid_selector_q <= _ep_in_res_valid_selector_n;
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      prev_dest_reg_q <= '0;
      prev_reg_write_q <= '0;
      prev_write_data_q <= '0;
      temp_dest_reg_q <= '0;
      temp_reg_write_q <= '0;
      temp_write_data_q <= '0;
      _thread_0_event_counter_21_1_q <= '0;
      _thread_0_event_counter_20_1_q <= '0;
      _thread_0_event_counter_18_1_q <= '0;
      _thread_0_event_counter_17_1_q <= '0;
      _thread_0_event_syncstate_16_q <= '0;
      _thread_0_event_syncstate_15_q <= '0;
      _thread_0_event_counter_14_1_q <= '0;
      _thread_0_event_counter_13_1_q <= '0;
      _thread_0_event_counter_12_1_q <= '0;
      _thread_0_event_counter_10_1_q <= '0;
      _thread_0_event_counter_9_1_q <= '0;
      _thread_0_event_syncstate_8_q <= '0;
      _thread_0_event_syncstate_7_q <= '0;
      _thread_0_event_counter_6_1_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_counter_4_1_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[18].event_current) begin
        prev_reg_write_q[0 +: 1] <= thread_0_wire$16;
      end
      if (EVENTS0[17].event_current) begin
        prev_dest_reg_q[0 +: 5] <= thread_0_wire$15;
      end
      if (EVENTS0[16].event_current) begin
        prev_write_data_q[0 +: 32] <= thread_0_wire$14;
      end
      if (EVENTS0[13].event_current) begin
        temp_reg_write_q[0 +: 1] <= thread_0_wire$9;
      end
      if (EVENTS0[12].event_current) begin
        temp_dest_reg_q[0 +: 5] <= thread_0_wire$8;
      end
      if (EVENTS0[11].event_current) begin
        temp_write_data_q[0 +: 32] <= thread_0_wire$6;
      end
      if (EVENTS0[10].event_current) begin
        prev_reg_write_q[0 +: 1] <= thread_0_wire$21;
      end
      if (EVENTS0[9].event_current) begin
        prev_dest_reg_q[0 +: 5] <= thread_0_wire$20;
      end
      if (EVENTS0[8].event_current) begin
        prev_write_data_q[0 +: 32] <= thread_0_wire$19;
      end
      if (EVENTS0[5].event_current) begin
        temp_reg_write_q[0 +: 1] <= thread_0_wire$9;
      end
      if (EVENTS0[4].event_current) begin
        temp_dest_reg_q[0 +: 5] <= thread_0_wire$8;
      end
      if (EVENTS0[3].event_current) begin
        temp_write_data_q[0 +: 32] <= thread_0_wire$7;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_21_1_q <= _thread_0_event_counter_21_1_n;
      _thread_0_event_counter_20_1_q <= _thread_0_event_counter_20_1_n;
      _thread_0_event_counter_18_1_q <= _thread_0_event_counter_18_1_n;
      _thread_0_event_counter_17_1_q <= _thread_0_event_counter_17_1_n;
      _thread_0_event_syncstate_16_q <= _thread_0_event_syncstate_16_n;
      _thread_0_event_syncstate_15_q <= _thread_0_event_syncstate_15_n;
      _thread_0_event_counter_14_1_q <= _thread_0_event_counter_14_1_n;
      _thread_0_event_counter_13_1_q <= _thread_0_event_counter_13_1_n;
      _thread_0_event_counter_12_1_q <= _thread_0_event_counter_12_1_n;
      _thread_0_event_counter_10_1_q <= _thread_0_event_counter_10_1_n;
      _thread_0_event_counter_9_1_q <= _thread_0_event_counter_9_1_n;
      _thread_0_event_syncstate_8_q <= _thread_0_event_syncstate_8_n;
      _thread_0_event_syncstate_7_q <= _thread_0_event_syncstate_7_n;
      _thread_0_event_counter_6_1_q <= _thread_0_event_counter_6_1_n;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_counter_4_1_q <= _thread_0_event_counter_4_1_n;
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
  logic[31:0] thread_0_wire$115;
  logic[0:0] thread_0_wire$114;
  logic[0:0] thread_0_wire$113;
  logic[0:0] thread_0_wire$111;
  logic[72:0] thread_0_wire$110;
  logic[0:0] thread_0_wire$109;
  logic[0:0] thread_0_wire$108;
  logic[31:0] thread_0_wire$106;
  logic[31:0] thread_0_wire$105;
  logic[0:0] thread_0_wire$104;
  logic[0:0] thread_0_wire$103;
  logic[0:0] thread_0_wire$101;
  logic[72:0] thread_0_wire$100;
  logic[0:0] thread_0_wire$99;
  logic[0:0] thread_0_wire$98;
  logic[31:0] thread_0_wire$96;
  logic[0:0] thread_0_wire$95;
  logic[31:0] thread_0_wire$93;
  logic[0:0] thread_0_wire$92;
  logic[0:0] thread_0_wire$91;
  logic[0:0] thread_0_wire$89;
  logic[72:0] thread_0_wire$88;
  logic[0:0] thread_0_wire$87;
  logic[0:0] thread_0_wire$86;
  logic[31:0] thread_0_wire$84;
  logic[31:0] thread_0_wire$83;
  logic[0:0] thread_0_wire$82;
  logic[0:0] thread_0_wire$81;
  logic[0:0] thread_0_wire$79;
  logic[72:0] thread_0_wire$78;
  logic[0:0] thread_0_wire$77;
  logic[0:0] thread_0_wire$76;
  logic[31:0] thread_0_wire$74;
  logic[0:0] thread_0_wire$73;
  logic[0:0] thread_0_wire$71;
  logic[31:0] thread_0_wire$69;
  logic[0:0] thread_0_wire$68;
  logic[0:0] thread_0_wire$67;
  logic[0:0] thread_0_wire$65;
  logic[72:0] thread_0_wire$64;
  logic[0:0] thread_0_wire$63;
  logic[0:0] thread_0_wire$62;
  logic[31:0] thread_0_wire$60;
  logic[31:0] thread_0_wire$59;
  logic[0:0] thread_0_wire$58;
  logic[0:0] thread_0_wire$57;
  logic[0:0] thread_0_wire$55;
  logic[72:0] thread_0_wire$54;
  logic[0:0] thread_0_wire$53;
  logic[0:0] thread_0_wire$52;
  logic[31:0] thread_0_wire$50;
  logic[0:0] thread_0_wire$49;
  logic[31:0] thread_0_wire$47;
  logic[0:0] thread_0_wire$46;
  logic[0:0] thread_0_wire$45;
  logic[0:0] thread_0_wire$43;
  logic[72:0] thread_0_wire$42;
  logic[0:0] thread_0_wire$41;
  logic[0:0] thread_0_wire$40;
  logic[31:0] thread_0_wire$38;
  logic[31:0] thread_0_wire$37;
  logic[0:0] thread_0_wire$36;
  logic[0:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$33;
  logic[72:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$31;
  logic[0:0] thread_0_wire$30;
  logic[31:0] thread_0_wire$28;
  logic[0:0] thread_0_wire$27;
  logic[0:0] thread_0_wire$25;
  logic[0:0] thread_0_wire$23;
  logic[31:0] thread_0_wire$21;
  logic[31:0] thread_0_wire$20;
  logic[0:0] thread_0_wire$19;
  logic[3:0] thread_0_wire$18;
  logic[0:0] thread_0_wire$17;
  logic[0:0] thread_0_wire$16;
  logic[0:0] thread_0_wire$15;
  logic[0:0] thread_0_wire$14;
  logic[0:0] thread_0_wire$13;
  logic[31:0] thread_0_wire$12;
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
  assign thread_0_wire$11 = thread_0_wire$3[154 +: 32];
  assign thread_0_wire$12 = thread_0_wire$3[26 +: 32];
  assign thread_0_wire$13 = thread_0_wire$3[4 +: 1];
  assign thread_0_wire$14 = thread_0_wire$3[3 +: 1];
  assign thread_0_wire$15 = thread_0_wire$3[2 +: 1];
  assign thread_0_wire$16 = thread_0_wire$3[1 +: 1];
  assign thread_0_wire$17 = thread_0_wire$3[0 +: 1];
  assign thread_0_wire$18 = thread_0_wire$3[7 +: 4];
  assign thread_0_wire$19 = thread_0_wire$18[0 +: 1];
  assign thread_0_wire$20 = thread_0_wire$12 + thread_0_wire$12;
  assign thread_0_wire$21 = thread_0_wire$20 + thread_0_wire$20;
  localparam logic[0:0] thread_0_wire$22 = 1'b1;
  assign thread_0_wire$23 = thread_0_wire$7 == thread_0_wire$22;
  localparam logic[0:0] thread_0_wire$24 = 1'b1;
  assign thread_0_wire$25 = thread_0_wire$8 == thread_0_wire$24;
  localparam logic[0:0] thread_0_wire$26 = 1'b1;
  assign thread_0_wire$27 = thread_0_wire$19 == thread_0_wire$26;
  assign thread_0_wire$28 = thread_0_wire$4 - thread_0_wire$6;
  localparam logic[31:0] thread_0_wire$29 = 32'd0;
  assign thread_0_wire$30 = thread_0_wire$4 == thread_0_wire$29;
  assign thread_0_wire$31 = thread_0_wire$17 & thread_0_wire$30;
  assign thread_0_wire$32 = {thread_0_wire$28, thread_0_wire$5, thread_0_wire$9, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15, thread_0_wire$16};
  assign thread_0_wire$33 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$34 = 1'b1;
  assign thread_0_wire$35 = _ep_branch_res_0;
  assign thread_0_wire$36 = temp_b_taken_q;
  assign thread_0_wire$37 = temp_b_target_q;
  assign thread_0_wire$38 = thread_0_wire$4 + thread_0_wire$6;
  localparam logic[31:0] thread_0_wire$39 = 32'd0;
  assign thread_0_wire$40 = thread_0_wire$4 == thread_0_wire$39;
  assign thread_0_wire$41 = thread_0_wire$17 & thread_0_wire$40;
  assign thread_0_wire$42 = {thread_0_wire$38, thread_0_wire$5, thread_0_wire$9, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15, thread_0_wire$16};
  assign thread_0_wire$43 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$44 = 1'b1;
  assign thread_0_wire$45 = _ep_branch_res_0;
  assign thread_0_wire$46 = temp_b_taken_q;
  assign thread_0_wire$47 = temp_b_target_q;
  localparam logic[0:0] thread_0_wire$48 = 1'b1;
  assign thread_0_wire$49 = thread_0_wire$19 == thread_0_wire$48;
  assign thread_0_wire$50 = thread_0_wire$4 - thread_0_wire$6;
  localparam logic[31:0] thread_0_wire$51 = 32'd0;
  assign thread_0_wire$52 = thread_0_wire$4 == thread_0_wire$51;
  assign thread_0_wire$53 = thread_0_wire$17 & thread_0_wire$52;
  assign thread_0_wire$54 = {thread_0_wire$50, thread_0_wire$5, thread_0_wire$10, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15, thread_0_wire$16};
  assign thread_0_wire$55 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$56 = 1'b1;
  assign thread_0_wire$57 = _ep_branch_res_0;
  assign thread_0_wire$58 = temp_b_taken_q;
  assign thread_0_wire$59 = temp_b_target_q;
  assign thread_0_wire$60 = thread_0_wire$4 + thread_0_wire$6;
  localparam logic[31:0] thread_0_wire$61 = 32'd0;
  assign thread_0_wire$62 = thread_0_wire$4 == thread_0_wire$61;
  assign thread_0_wire$63 = thread_0_wire$17 & thread_0_wire$62;
  assign thread_0_wire$64 = {thread_0_wire$60, thread_0_wire$5, thread_0_wire$10, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15, thread_0_wire$16};
  assign thread_0_wire$65 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$66 = 1'b1;
  assign thread_0_wire$67 = _ep_branch_res_0;
  assign thread_0_wire$68 = temp_b_taken_q;
  assign thread_0_wire$69 = temp_b_target_q;
  localparam logic[0:0] thread_0_wire$70 = 1'b1;
  assign thread_0_wire$71 = thread_0_wire$8 == thread_0_wire$70;
  localparam logic[0:0] thread_0_wire$72 = 1'b1;
  assign thread_0_wire$73 = thread_0_wire$19 == thread_0_wire$72;
  assign thread_0_wire$74 = thread_0_wire$4 - thread_0_wire$5;
  localparam logic[31:0] thread_0_wire$75 = 32'd0;
  assign thread_0_wire$76 = thread_0_wire$4 == thread_0_wire$75;
  assign thread_0_wire$77 = thread_0_wire$17 & thread_0_wire$76;
  assign thread_0_wire$78 = {thread_0_wire$74, thread_0_wire$5, thread_0_wire$9, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15, thread_0_wire$16};
  assign thread_0_wire$79 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$80 = 1'b1;
  assign thread_0_wire$81 = _ep_branch_res_0;
  assign thread_0_wire$82 = temp_b_taken_q;
  assign thread_0_wire$83 = temp_b_target_q;
  assign thread_0_wire$84 = thread_0_wire$4 + thread_0_wire$5;
  localparam logic[31:0] thread_0_wire$85 = 32'd0;
  assign thread_0_wire$86 = thread_0_wire$4 == thread_0_wire$85;
  assign thread_0_wire$87 = thread_0_wire$17 & thread_0_wire$86;
  assign thread_0_wire$88 = {thread_0_wire$84, thread_0_wire$5, thread_0_wire$9, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15, thread_0_wire$16};
  assign thread_0_wire$89 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$90 = 1'b1;
  assign thread_0_wire$91 = _ep_branch_res_0;
  assign thread_0_wire$92 = temp_b_taken_q;
  assign thread_0_wire$93 = temp_b_target_q;
  localparam logic[0:0] thread_0_wire$94 = 1'b1;
  assign thread_0_wire$95 = thread_0_wire$19 == thread_0_wire$94;
  assign thread_0_wire$96 = thread_0_wire$4 - thread_0_wire$5;
  localparam logic[31:0] thread_0_wire$97 = 32'd0;
  assign thread_0_wire$98 = thread_0_wire$4 == thread_0_wire$97;
  assign thread_0_wire$99 = thread_0_wire$17 & thread_0_wire$98;
  assign thread_0_wire$100 = {thread_0_wire$96, thread_0_wire$5, thread_0_wire$10, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15, thread_0_wire$16};
  assign thread_0_wire$101 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$102 = 1'b1;
  assign thread_0_wire$103 = _ep_branch_res_0;
  assign thread_0_wire$104 = temp_b_taken_q;
  assign thread_0_wire$105 = temp_b_target_q;
  assign thread_0_wire$106 = thread_0_wire$4 + thread_0_wire$5;
  localparam logic[31:0] thread_0_wire$107 = 32'd0;
  assign thread_0_wire$108 = thread_0_wire$4 == thread_0_wire$107;
  assign thread_0_wire$109 = thread_0_wire$17 & thread_0_wire$108;
  assign thread_0_wire$110 = {thread_0_wire$106, thread_0_wire$5, thread_0_wire$10, thread_0_wire$13, thread_0_wire$14, thread_0_wire$15, thread_0_wire$16};
  assign thread_0_wire$111 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$112 = 1'b1;
  assign thread_0_wire$113 = _ep_branch_res_0;
  assign thread_0_wire$114 = temp_b_taken_q;
  assign thread_0_wire$115 = temp_b_target_q;
  for (genvar i = 0; i < 76; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_75_1_q, _thread_0_event_counter_75_1_n;
  logic _thread_0_event_counter_74_1_q, _thread_0_event_counter_74_1_n;
  logic _thread_0_event_counter_72_1_q, _thread_0_event_counter_72_1_n;
  logic _thread_0_event_syncstate_71_q, _thread_0_event_syncstate_71_n;
  logic _thread_0_event_syncstate_70_q, _thread_0_event_syncstate_70_n;
  logic _thread_0_event_syncstate_69_q, _thread_0_event_syncstate_69_n;
  logic _thread_0_event_syncstate_68_q, _thread_0_event_syncstate_68_n;
  logic _thread_0_event_counter_67_1_q, _thread_0_event_counter_67_1_n;
  logic _thread_0_event_counter_66_1_q, _thread_0_event_counter_66_1_n;
  logic _thread_0_event_counter_64_1_q, _thread_0_event_counter_64_1_n;
  logic _thread_0_event_syncstate_63_q, _thread_0_event_syncstate_63_n;
  logic _thread_0_event_syncstate_62_q, _thread_0_event_syncstate_62_n;
  logic _thread_0_event_syncstate_61_q, _thread_0_event_syncstate_61_n;
  logic _thread_0_event_syncstate_60_q, _thread_0_event_syncstate_60_n;
  logic _thread_0_event_counter_59_1_q, _thread_0_event_counter_59_1_n;
  logic _thread_0_event_counter_58_1_q, _thread_0_event_counter_58_1_n;
  logic _thread_0_event_counter_55_1_q, _thread_0_event_counter_55_1_n;
  logic _thread_0_event_syncstate_54_q, _thread_0_event_syncstate_54_n;
  logic _thread_0_event_syncstate_53_q, _thread_0_event_syncstate_53_n;
  logic _thread_0_event_syncstate_52_q, _thread_0_event_syncstate_52_n;
  logic _thread_0_event_syncstate_51_q, _thread_0_event_syncstate_51_n;
  logic _thread_0_event_counter_50_1_q, _thread_0_event_counter_50_1_n;
  logic _thread_0_event_counter_49_1_q, _thread_0_event_counter_49_1_n;
  logic _thread_0_event_counter_47_1_q, _thread_0_event_counter_47_1_n;
  logic _thread_0_event_syncstate_46_q, _thread_0_event_syncstate_46_n;
  logic _thread_0_event_syncstate_45_q, _thread_0_event_syncstate_45_n;
  logic _thread_0_event_syncstate_44_q, _thread_0_event_syncstate_44_n;
  logic _thread_0_event_syncstate_43_q, _thread_0_event_syncstate_43_n;
  logic _thread_0_event_counter_42_1_q, _thread_0_event_counter_42_1_n;
  logic _thread_0_event_counter_41_1_q, _thread_0_event_counter_41_1_n;
  logic _thread_0_event_counter_37_1_q, _thread_0_event_counter_37_1_n;
  logic _thread_0_event_syncstate_36_q, _thread_0_event_syncstate_36_n;
  logic _thread_0_event_syncstate_35_q, _thread_0_event_syncstate_35_n;
  logic _thread_0_event_syncstate_34_q, _thread_0_event_syncstate_34_n;
  logic _thread_0_event_syncstate_33_q, _thread_0_event_syncstate_33_n;
  logic _thread_0_event_counter_32_1_q, _thread_0_event_counter_32_1_n;
  logic _thread_0_event_counter_31_1_q, _thread_0_event_counter_31_1_n;
  logic _thread_0_event_counter_29_1_q, _thread_0_event_counter_29_1_n;
  logic _thread_0_event_syncstate_28_q, _thread_0_event_syncstate_28_n;
  logic _thread_0_event_syncstate_27_q, _thread_0_event_syncstate_27_n;
  logic _thread_0_event_syncstate_26_q, _thread_0_event_syncstate_26_n;
  logic _thread_0_event_syncstate_25_q, _thread_0_event_syncstate_25_n;
  logic _thread_0_event_counter_24_1_q, _thread_0_event_counter_24_1_n;
  logic _thread_0_event_counter_23_1_q, _thread_0_event_counter_23_1_n;
  logic _thread_0_event_counter_20_1_q, _thread_0_event_counter_20_1_n;
  logic _thread_0_event_syncstate_19_q, _thread_0_event_syncstate_19_n;
  logic _thread_0_event_syncstate_18_q, _thread_0_event_syncstate_18_n;
  logic _thread_0_event_syncstate_17_q, _thread_0_event_syncstate_17_n;
  logic _thread_0_event_syncstate_16_q, _thread_0_event_syncstate_16_n;
  logic _thread_0_event_counter_15_1_q, _thread_0_event_counter_15_1_n;
  logic _thread_0_event_counter_14_1_q, _thread_0_event_counter_14_1_n;
  logic _thread_0_event_counter_12_1_q, _thread_0_event_counter_12_1_n;
  logic _thread_0_event_syncstate_11_q, _thread_0_event_syncstate_11_n;
  logic _thread_0_event_syncstate_10_q, _thread_0_event_syncstate_10_n;
  logic _thread_0_event_syncstate_9_q, _thread_0_event_syncstate_9_n;
  logic _thread_0_event_syncstate_8_q, _thread_0_event_syncstate_8_n;
  logic _thread_0_event_counter_7_1_q, _thread_0_event_counter_7_1_n;
  logic _thread_0_event_counter_6_1_q, _thread_0_event_counter_6_1_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[75].event_current = _thread_0_event_counter_75_1_q;
  assign _thread_0_event_counter_75_1_n = EVENTS0[74].event_current;
  assign EVENTS0[74].event_current = _thread_0_event_counter_74_1_q;
  assign _thread_0_event_counter_74_1_n = EVENTS0[73].event_current;
  assign EVENTS0[73].event_current = EVENTS0[72].event_current || EVENTS0[64].event_current || EVENTS0[55].event_current || EVENTS0[47].event_current || EVENTS0[37].event_current || EVENTS0[29].event_current || EVENTS0[20].event_current || EVENTS0[12].event_current;
  assign EVENTS0[72].event_current = _thread_0_event_counter_72_1_q;
  assign _thread_0_event_counter_72_1_n = EVENTS0[71].event_current;
  assign EVENTS0[71].event_current = (EVENTS0[70].event_current || _thread_0_event_syncstate_71_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_71_n = (EVENTS0[70].event_current || _thread_0_event_syncstate_71_q) && !_ep_branch_res_valid;
  assign EVENTS0[70].event_current = (EVENTS0[69].event_current || _thread_0_event_syncstate_70_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_70_n = (EVENTS0[69].event_current || _thread_0_event_syncstate_70_q) && !_ep_in_res_ack;
  assign EVENTS0[69].event_current = (EVENTS0[68].event_current || _thread_0_event_syncstate_69_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_69_n = (EVENTS0[68].event_current || _thread_0_event_syncstate_69_q) && !_ep_out_res_valid;
  assign EVENTS0[68].event_current = (EVENTS0[67].event_current || _thread_0_event_syncstate_68_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_68_n = (EVENTS0[67].event_current || _thread_0_event_syncstate_68_q) && !_ep_out_req_ack;
  assign EVENTS0[67].event_current = _thread_0_event_counter_67_1_q;
  assign _thread_0_event_counter_67_1_n = EVENTS0[66].event_current;
  assign EVENTS0[66].event_current = _thread_0_event_counter_66_1_q;
  assign _thread_0_event_counter_66_1_n = EVENTS0[65].event_current;
  assign EVENTS0[65].event_current = EVENTS0[56].event_current && thread_0_wire$95;
  assign EVENTS0[64].event_current = _thread_0_event_counter_64_1_q;
  assign _thread_0_event_counter_64_1_n = EVENTS0[63].event_current;
  assign EVENTS0[63].event_current = (EVENTS0[62].event_current || _thread_0_event_syncstate_63_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_63_n = (EVENTS0[62].event_current || _thread_0_event_syncstate_63_q) && !_ep_branch_res_valid;
  assign EVENTS0[62].event_current = (EVENTS0[61].event_current || _thread_0_event_syncstate_62_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_62_n = (EVENTS0[61].event_current || _thread_0_event_syncstate_62_q) && !_ep_in_res_ack;
  assign EVENTS0[61].event_current = (EVENTS0[60].event_current || _thread_0_event_syncstate_61_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_61_n = (EVENTS0[60].event_current || _thread_0_event_syncstate_61_q) && !_ep_out_res_valid;
  assign EVENTS0[60].event_current = (EVENTS0[59].event_current || _thread_0_event_syncstate_60_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_60_n = (EVENTS0[59].event_current || _thread_0_event_syncstate_60_q) && !_ep_out_req_ack;
  assign EVENTS0[59].event_current = _thread_0_event_counter_59_1_q;
  assign _thread_0_event_counter_59_1_n = EVENTS0[58].event_current;
  assign EVENTS0[58].event_current = _thread_0_event_counter_58_1_q;
  assign _thread_0_event_counter_58_1_n = EVENTS0[57].event_current;
  assign EVENTS0[57].event_current = EVENTS0[56].event_current && !thread_0_wire$95;
  assign EVENTS0[56].event_current = EVENTS0[38].event_current && !thread_0_wire$71;
  assign EVENTS0[55].event_current = _thread_0_event_counter_55_1_q;
  assign _thread_0_event_counter_55_1_n = EVENTS0[54].event_current;
  assign EVENTS0[54].event_current = (EVENTS0[53].event_current || _thread_0_event_syncstate_54_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_54_n = (EVENTS0[53].event_current || _thread_0_event_syncstate_54_q) && !_ep_branch_res_valid;
  assign EVENTS0[53].event_current = (EVENTS0[52].event_current || _thread_0_event_syncstate_53_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_53_n = (EVENTS0[52].event_current || _thread_0_event_syncstate_53_q) && !_ep_in_res_ack;
  assign EVENTS0[52].event_current = (EVENTS0[51].event_current || _thread_0_event_syncstate_52_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_52_n = (EVENTS0[51].event_current || _thread_0_event_syncstate_52_q) && !_ep_out_res_valid;
  assign EVENTS0[51].event_current = (EVENTS0[50].event_current || _thread_0_event_syncstate_51_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_51_n = (EVENTS0[50].event_current || _thread_0_event_syncstate_51_q) && !_ep_out_req_ack;
  assign EVENTS0[50].event_current = _thread_0_event_counter_50_1_q;
  assign _thread_0_event_counter_50_1_n = EVENTS0[49].event_current;
  assign EVENTS0[49].event_current = _thread_0_event_counter_49_1_q;
  assign _thread_0_event_counter_49_1_n = EVENTS0[48].event_current;
  assign EVENTS0[48].event_current = EVENTS0[39].event_current && thread_0_wire$73;
  assign EVENTS0[47].event_current = _thread_0_event_counter_47_1_q;
  assign _thread_0_event_counter_47_1_n = EVENTS0[46].event_current;
  assign EVENTS0[46].event_current = (EVENTS0[45].event_current || _thread_0_event_syncstate_46_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_46_n = (EVENTS0[45].event_current || _thread_0_event_syncstate_46_q) && !_ep_branch_res_valid;
  assign EVENTS0[45].event_current = (EVENTS0[44].event_current || _thread_0_event_syncstate_45_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_45_n = (EVENTS0[44].event_current || _thread_0_event_syncstate_45_q) && !_ep_in_res_ack;
  assign EVENTS0[44].event_current = (EVENTS0[43].event_current || _thread_0_event_syncstate_44_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_44_n = (EVENTS0[43].event_current || _thread_0_event_syncstate_44_q) && !_ep_out_res_valid;
  assign EVENTS0[43].event_current = (EVENTS0[42].event_current || _thread_0_event_syncstate_43_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_43_n = (EVENTS0[42].event_current || _thread_0_event_syncstate_43_q) && !_ep_out_req_ack;
  assign EVENTS0[42].event_current = _thread_0_event_counter_42_1_q;
  assign _thread_0_event_counter_42_1_n = EVENTS0[41].event_current;
  assign EVENTS0[41].event_current = _thread_0_event_counter_41_1_q;
  assign _thread_0_event_counter_41_1_n = EVENTS0[40].event_current;
  assign EVENTS0[40].event_current = EVENTS0[39].event_current && !thread_0_wire$73;
  assign EVENTS0[39].event_current = EVENTS0[38].event_current && thread_0_wire$71;
  assign EVENTS0[38].event_current = EVENTS0[2].event_current && !thread_0_wire$23;
  assign EVENTS0[37].event_current = _thread_0_event_counter_37_1_q;
  assign _thread_0_event_counter_37_1_n = EVENTS0[36].event_current;
  assign EVENTS0[36].event_current = (EVENTS0[35].event_current || _thread_0_event_syncstate_36_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_36_n = (EVENTS0[35].event_current || _thread_0_event_syncstate_36_q) && !_ep_branch_res_valid;
  assign EVENTS0[35].event_current = (EVENTS0[34].event_current || _thread_0_event_syncstate_35_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_35_n = (EVENTS0[34].event_current || _thread_0_event_syncstate_35_q) && !_ep_in_res_ack;
  assign EVENTS0[34].event_current = (EVENTS0[33].event_current || _thread_0_event_syncstate_34_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_34_n = (EVENTS0[33].event_current || _thread_0_event_syncstate_34_q) && !_ep_out_res_valid;
  assign EVENTS0[33].event_current = (EVENTS0[32].event_current || _thread_0_event_syncstate_33_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_33_n = (EVENTS0[32].event_current || _thread_0_event_syncstate_33_q) && !_ep_out_req_ack;
  assign EVENTS0[32].event_current = _thread_0_event_counter_32_1_q;
  assign _thread_0_event_counter_32_1_n = EVENTS0[31].event_current;
  assign EVENTS0[31].event_current = _thread_0_event_counter_31_1_q;
  assign _thread_0_event_counter_31_1_n = EVENTS0[30].event_current;
  assign EVENTS0[30].event_current = EVENTS0[21].event_current && thread_0_wire$49;
  assign EVENTS0[29].event_current = _thread_0_event_counter_29_1_q;
  assign _thread_0_event_counter_29_1_n = EVENTS0[28].event_current;
  assign EVENTS0[28].event_current = (EVENTS0[27].event_current || _thread_0_event_syncstate_28_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_28_n = (EVENTS0[27].event_current || _thread_0_event_syncstate_28_q) && !_ep_branch_res_valid;
  assign EVENTS0[27].event_current = (EVENTS0[26].event_current || _thread_0_event_syncstate_27_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_27_n = (EVENTS0[26].event_current || _thread_0_event_syncstate_27_q) && !_ep_in_res_ack;
  assign EVENTS0[26].event_current = (EVENTS0[25].event_current || _thread_0_event_syncstate_26_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_26_n = (EVENTS0[25].event_current || _thread_0_event_syncstate_26_q) && !_ep_out_res_valid;
  assign EVENTS0[25].event_current = (EVENTS0[24].event_current || _thread_0_event_syncstate_25_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_25_n = (EVENTS0[24].event_current || _thread_0_event_syncstate_25_q) && !_ep_out_req_ack;
  assign EVENTS0[24].event_current = _thread_0_event_counter_24_1_q;
  assign _thread_0_event_counter_24_1_n = EVENTS0[23].event_current;
  assign EVENTS0[23].event_current = _thread_0_event_counter_23_1_q;
  assign _thread_0_event_counter_23_1_n = EVENTS0[22].event_current;
  assign EVENTS0[22].event_current = EVENTS0[21].event_current && !thread_0_wire$49;
  assign EVENTS0[21].event_current = EVENTS0[3].event_current && !thread_0_wire$25;
  assign EVENTS0[20].event_current = _thread_0_event_counter_20_1_q;
  assign _thread_0_event_counter_20_1_n = EVENTS0[19].event_current;
  assign EVENTS0[19].event_current = (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_19_n = (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q) && !_ep_branch_res_valid;
  assign EVENTS0[18].event_current = (EVENTS0[17].event_current || _thread_0_event_syncstate_18_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_18_n = (EVENTS0[17].event_current || _thread_0_event_syncstate_18_q) && !_ep_in_res_ack;
  assign EVENTS0[17].event_current = (EVENTS0[16].event_current || _thread_0_event_syncstate_17_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_17_n = (EVENTS0[16].event_current || _thread_0_event_syncstate_17_q) && !_ep_out_res_valid;
  assign EVENTS0[16].event_current = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_16_n = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && !_ep_out_req_ack;
  assign EVENTS0[15].event_current = _thread_0_event_counter_15_1_q;
  assign _thread_0_event_counter_15_1_n = EVENTS0[14].event_current;
  assign EVENTS0[14].event_current = _thread_0_event_counter_14_1_q;
  assign _thread_0_event_counter_14_1_n = EVENTS0[13].event_current;
  assign EVENTS0[13].event_current = EVENTS0[4].event_current && thread_0_wire$27;
  assign EVENTS0[12].event_current = _thread_0_event_counter_12_1_q;
  assign _thread_0_event_counter_12_1_n = EVENTS0[11].event_current;
  assign EVENTS0[11].event_current = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) && _ep_branch_res_valid;
    assign _thread_0_event_syncstate_11_n = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) && !_ep_branch_res_valid;
  assign EVENTS0[10].event_current = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_10_n = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q) && !_ep_in_res_ack;
  assign EVENTS0[9].event_current = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_9_n = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) && !_ep_out_res_valid;
  assign EVENTS0[8].event_current = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_8_n = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && !_ep_out_req_ack;
  assign EVENTS0[7].event_current = _thread_0_event_counter_7_1_q;
  assign _thread_0_event_counter_7_1_n = EVENTS0[6].event_current;
  assign EVENTS0[6].event_current = _thread_0_event_counter_6_1_q;
  assign _thread_0_event_counter_6_1_n = EVENTS0[5].event_current;
  assign EVENTS0[5].event_current = EVENTS0[4].event_current && !thread_0_wire$27;
  assign EVENTS0[4].event_current = EVENTS0[3].event_current && thread_0_wire$25;
  assign EVENTS0[3].event_current = EVENTS0[2].event_current && thread_0_wire$23;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_in_req_valid;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_branch_req_ack;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_branch_req_ack;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[75].event_current;
  assign _ep_in_req_ack = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_out_res_ack = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) || (EVENTS0[16].event_current || _thread_0_event_syncstate_17_q) || (EVENTS0[25].event_current || _thread_0_event_syncstate_26_q) || (EVENTS0[33].event_current || _thread_0_event_syncstate_34_q) || (EVENTS0[43].event_current || _thread_0_event_syncstate_44_q) || (EVENTS0[51].event_current || _thread_0_event_syncstate_52_q) || (EVENTS0[60].event_current || _thread_0_event_syncstate_61_q) || (EVENTS0[68].event_current || _thread_0_event_syncstate_69_q);
  assign _ep_branch_res_ack = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) || (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q) || (EVENTS0[27].event_current || _thread_0_event_syncstate_28_q) || (EVENTS0[35].event_current || _thread_0_event_syncstate_36_q) || (EVENTS0[45].event_current || _thread_0_event_syncstate_46_q) || (EVENTS0[53].event_current || _thread_0_event_syncstate_54_q) || (EVENTS0[62].event_current || _thread_0_event_syncstate_63_q) || (EVENTS0[70].event_current || _thread_0_event_syncstate_71_q);
  assign _ep_in_res_valid = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q) || (EVENTS0[17].event_current || _thread_0_event_syncstate_18_q) || (EVENTS0[26].event_current || _thread_0_event_syncstate_27_q) || (EVENTS0[34].event_current || _thread_0_event_syncstate_35_q) || (EVENTS0[44].event_current || _thread_0_event_syncstate_45_q) || (EVENTS0[52].event_current || _thread_0_event_syncstate_53_q) || (EVENTS0[61].event_current || _thread_0_event_syncstate_62_q) || (EVENTS0[69].event_current || _thread_0_event_syncstate_70_q);
  assign _ep_out_req_valid = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) || (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) || (EVENTS0[24].event_current || _thread_0_event_syncstate_25_q) || (EVENTS0[32].event_current || _thread_0_event_syncstate_33_q) || (EVENTS0[42].event_current || _thread_0_event_syncstate_43_q) || (EVENTS0[50].event_current || _thread_0_event_syncstate_51_q) || (EVENTS0[59].event_current || _thread_0_event_syncstate_60_q) || (EVENTS0[67].event_current || _thread_0_event_syncstate_68_q);
  assign _ep_branch_req_valid = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_branch_req_0 = thread_0_wire$2;
  logic[2:0] _ep_out_req_valid_selector_q, _ep_out_req_valid_selector_n;
  assign _ep_out_req_0 = (_ep_out_req_valid_selector_n == 3'd0) ? thread_0_wire$42 : (_ep_out_req_valid_selector_n == 3'd1) ? thread_0_wire$32 : (_ep_out_req_valid_selector_n == 3'd2) ? thread_0_wire$64 : (_ep_out_req_valid_selector_n == 3'd3) ? thread_0_wire$54 : (_ep_out_req_valid_selector_n == 3'd4) ? thread_0_wire$88 : (_ep_out_req_valid_selector_n == 3'd5) ? thread_0_wire$78 : (_ep_out_req_valid_selector_n == 3'd6) ? thread_0_wire$110 : (_ep_out_req_valid_selector_n == 3'd7) ? thread_0_wire$100 : '0;
  logic[2:0] _ep_in_res_valid_selector_q, _ep_in_res_valid_selector_n;
  assign _ep_in_res_0 = (_ep_in_res_valid_selector_n == 3'd0) ? thread_0_wire$44 : (_ep_in_res_valid_selector_n == 3'd1) ? thread_0_wire$34 : (_ep_in_res_valid_selector_n == 3'd2) ? thread_0_wire$66 : (_ep_in_res_valid_selector_n == 3'd3) ? thread_0_wire$56 : (_ep_in_res_valid_selector_n == 3'd4) ? thread_0_wire$90 : (_ep_in_res_valid_selector_n == 3'd5) ? thread_0_wire$80 : (_ep_in_res_valid_selector_n == 3'd6) ? thread_0_wire$112 : (_ep_in_res_valid_selector_n == 3'd7) ? thread_0_wire$102 : '0;
  always_comb begin: _thread_0_selector
    _ep_out_req_valid_selector_n = _ep_out_req_valid_selector_q;
    if ((EVENTS0[7].event_current || _thread_0_event_syncstate_8_q)) _ep_out_req_valid_selector_n = 3'd0;
    if ((EVENTS0[15].event_current || _thread_0_event_syncstate_16_q)) _ep_out_req_valid_selector_n = 3'd1;
    if ((EVENTS0[24].event_current || _thread_0_event_syncstate_25_q)) _ep_out_req_valid_selector_n = 3'd2;
    if ((EVENTS0[32].event_current || _thread_0_event_syncstate_33_q)) _ep_out_req_valid_selector_n = 3'd3;
    if ((EVENTS0[42].event_current || _thread_0_event_syncstate_43_q)) _ep_out_req_valid_selector_n = 3'd4;
    if ((EVENTS0[50].event_current || _thread_0_event_syncstate_51_q)) _ep_out_req_valid_selector_n = 3'd5;
    if ((EVENTS0[59].event_current || _thread_0_event_syncstate_60_q)) _ep_out_req_valid_selector_n = 3'd6;
    if ((EVENTS0[67].event_current || _thread_0_event_syncstate_68_q)) _ep_out_req_valid_selector_n = 3'd7;
    _ep_in_res_valid_selector_n = _ep_in_res_valid_selector_q;
    if ((EVENTS0[9].event_current || _thread_0_event_syncstate_10_q)) _ep_in_res_valid_selector_n = 3'd0;
    if ((EVENTS0[17].event_current || _thread_0_event_syncstate_18_q)) _ep_in_res_valid_selector_n = 3'd1;
    if ((EVENTS0[26].event_current || _thread_0_event_syncstate_27_q)) _ep_in_res_valid_selector_n = 3'd2;
    if ((EVENTS0[34].event_current || _thread_0_event_syncstate_35_q)) _ep_in_res_valid_selector_n = 3'd3;
    if ((EVENTS0[44].event_current || _thread_0_event_syncstate_45_q)) _ep_in_res_valid_selector_n = 3'd4;
    if ((EVENTS0[52].event_current || _thread_0_event_syncstate_53_q)) _ep_in_res_valid_selector_n = 3'd5;
    if ((EVENTS0[61].event_current || _thread_0_event_syncstate_62_q)) _ep_in_res_valid_selector_n = 3'd6;
    if ((EVENTS0[69].event_current || _thread_0_event_syncstate_70_q)) _ep_in_res_valid_selector_n = 3'd7;
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
      prev_b_taken_q <= '0;
      prev_b_target_q <= '0;
      temp_b_taken_q <= '0;
      temp_b_target_q <= '0;
      _thread_0_event_counter_75_1_q <= '0;
      _thread_0_event_counter_74_1_q <= '0;
      _thread_0_event_counter_72_1_q <= '0;
      _thread_0_event_syncstate_71_q <= '0;
      _thread_0_event_syncstate_70_q <= '0;
      _thread_0_event_syncstate_69_q <= '0;
      _thread_0_event_syncstate_68_q <= '0;
      _thread_0_event_counter_67_1_q <= '0;
      _thread_0_event_counter_66_1_q <= '0;
      _thread_0_event_counter_64_1_q <= '0;
      _thread_0_event_syncstate_63_q <= '0;
      _thread_0_event_syncstate_62_q <= '0;
      _thread_0_event_syncstate_61_q <= '0;
      _thread_0_event_syncstate_60_q <= '0;
      _thread_0_event_counter_59_1_q <= '0;
      _thread_0_event_counter_58_1_q <= '0;
      _thread_0_event_counter_55_1_q <= '0;
      _thread_0_event_syncstate_54_q <= '0;
      _thread_0_event_syncstate_53_q <= '0;
      _thread_0_event_syncstate_52_q <= '0;
      _thread_0_event_syncstate_51_q <= '0;
      _thread_0_event_counter_50_1_q <= '0;
      _thread_0_event_counter_49_1_q <= '0;
      _thread_0_event_counter_47_1_q <= '0;
      _thread_0_event_syncstate_46_q <= '0;
      _thread_0_event_syncstate_45_q <= '0;
      _thread_0_event_syncstate_44_q <= '0;
      _thread_0_event_syncstate_43_q <= '0;
      _thread_0_event_counter_42_1_q <= '0;
      _thread_0_event_counter_41_1_q <= '0;
      _thread_0_event_counter_37_1_q <= '0;
      _thread_0_event_syncstate_36_q <= '0;
      _thread_0_event_syncstate_35_q <= '0;
      _thread_0_event_syncstate_34_q <= '0;
      _thread_0_event_syncstate_33_q <= '0;
      _thread_0_event_counter_32_1_q <= '0;
      _thread_0_event_counter_31_1_q <= '0;
      _thread_0_event_counter_29_1_q <= '0;
      _thread_0_event_syncstate_28_q <= '0;
      _thread_0_event_syncstate_27_q <= '0;
      _thread_0_event_syncstate_26_q <= '0;
      _thread_0_event_syncstate_25_q <= '0;
      _thread_0_event_counter_24_1_q <= '0;
      _thread_0_event_counter_23_1_q <= '0;
      _thread_0_event_counter_20_1_q <= '0;
      _thread_0_event_syncstate_19_q <= '0;
      _thread_0_event_syncstate_18_q <= '0;
      _thread_0_event_syncstate_17_q <= '0;
      _thread_0_event_syncstate_16_q <= '0;
      _thread_0_event_counter_15_1_q <= '0;
      _thread_0_event_counter_14_1_q <= '0;
      _thread_0_event_counter_12_1_q <= '0;
      _thread_0_event_syncstate_11_q <= '0;
      _thread_0_event_syncstate_10_q <= '0;
      _thread_0_event_syncstate_9_q <= '0;
      _thread_0_event_syncstate_8_q <= '0;
      _thread_0_event_counter_7_1_q <= '0;
      _thread_0_event_counter_6_1_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[72].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$105;
      end
      if (EVENTS0[71].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$104;
      end
      if (EVENTS0[66].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$21;
      end
      if (EVENTS0[65].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$99;
      end
      if (EVENTS0[64].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$115;
      end
      if (EVENTS0[63].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$114;
      end
      if (EVENTS0[58].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$21;
      end
      if (EVENTS0[57].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$109;
      end
      if (EVENTS0[55].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$83;
      end
      if (EVENTS0[54].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$82;
      end
      if (EVENTS0[49].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$21;
      end
      if (EVENTS0[48].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$77;
      end
      if (EVENTS0[47].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$93;
      end
      if (EVENTS0[46].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$92;
      end
      if (EVENTS0[41].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$21;
      end
      if (EVENTS0[40].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$87;
      end
      if (EVENTS0[37].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$59;
      end
      if (EVENTS0[36].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$58;
      end
      if (EVENTS0[31].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$21;
      end
      if (EVENTS0[30].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$53;
      end
      if (EVENTS0[29].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$69;
      end
      if (EVENTS0[28].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$68;
      end
      if (EVENTS0[23].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$21;
      end
      if (EVENTS0[22].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$63;
      end
      if (EVENTS0[20].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$37;
      end
      if (EVENTS0[19].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$36;
      end
      if (EVENTS0[14].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$21;
      end
      if (EVENTS0[13].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$31;
      end
      if (EVENTS0[12].event_current) begin
        prev_b_target_q[0 +: 32] <= thread_0_wire$47;
      end
      if (EVENTS0[11].event_current) begin
        prev_b_taken_q[0 +: 1] <= thread_0_wire$46;
      end
      if (EVENTS0[6].event_current) begin
        temp_b_target_q[0 +: 32] <= thread_0_wire$21;
      end
      if (EVENTS0[5].event_current) begin
        temp_b_taken_q[0 +: 1] <= thread_0_wire$41;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_75_1_q <= _thread_0_event_counter_75_1_n;
      _thread_0_event_counter_74_1_q <= _thread_0_event_counter_74_1_n;
      _thread_0_event_counter_72_1_q <= _thread_0_event_counter_72_1_n;
      _thread_0_event_syncstate_71_q <= _thread_0_event_syncstate_71_n;
      _thread_0_event_syncstate_70_q <= _thread_0_event_syncstate_70_n;
      _thread_0_event_syncstate_69_q <= _thread_0_event_syncstate_69_n;
      _thread_0_event_syncstate_68_q <= _thread_0_event_syncstate_68_n;
      _thread_0_event_counter_67_1_q <= _thread_0_event_counter_67_1_n;
      _thread_0_event_counter_66_1_q <= _thread_0_event_counter_66_1_n;
      _thread_0_event_counter_64_1_q <= _thread_0_event_counter_64_1_n;
      _thread_0_event_syncstate_63_q <= _thread_0_event_syncstate_63_n;
      _thread_0_event_syncstate_62_q <= _thread_0_event_syncstate_62_n;
      _thread_0_event_syncstate_61_q <= _thread_0_event_syncstate_61_n;
      _thread_0_event_syncstate_60_q <= _thread_0_event_syncstate_60_n;
      _thread_0_event_counter_59_1_q <= _thread_0_event_counter_59_1_n;
      _thread_0_event_counter_58_1_q <= _thread_0_event_counter_58_1_n;
      _thread_0_event_counter_55_1_q <= _thread_0_event_counter_55_1_n;
      _thread_0_event_syncstate_54_q <= _thread_0_event_syncstate_54_n;
      _thread_0_event_syncstate_53_q <= _thread_0_event_syncstate_53_n;
      _thread_0_event_syncstate_52_q <= _thread_0_event_syncstate_52_n;
      _thread_0_event_syncstate_51_q <= _thread_0_event_syncstate_51_n;
      _thread_0_event_counter_50_1_q <= _thread_0_event_counter_50_1_n;
      _thread_0_event_counter_49_1_q <= _thread_0_event_counter_49_1_n;
      _thread_0_event_counter_47_1_q <= _thread_0_event_counter_47_1_n;
      _thread_0_event_syncstate_46_q <= _thread_0_event_syncstate_46_n;
      _thread_0_event_syncstate_45_q <= _thread_0_event_syncstate_45_n;
      _thread_0_event_syncstate_44_q <= _thread_0_event_syncstate_44_n;
      _thread_0_event_syncstate_43_q <= _thread_0_event_syncstate_43_n;
      _thread_0_event_counter_42_1_q <= _thread_0_event_counter_42_1_n;
      _thread_0_event_counter_41_1_q <= _thread_0_event_counter_41_1_n;
      _thread_0_event_counter_37_1_q <= _thread_0_event_counter_37_1_n;
      _thread_0_event_syncstate_36_q <= _thread_0_event_syncstate_36_n;
      _thread_0_event_syncstate_35_q <= _thread_0_event_syncstate_35_n;
      _thread_0_event_syncstate_34_q <= _thread_0_event_syncstate_34_n;
      _thread_0_event_syncstate_33_q <= _thread_0_event_syncstate_33_n;
      _thread_0_event_counter_32_1_q <= _thread_0_event_counter_32_1_n;
      _thread_0_event_counter_31_1_q <= _thread_0_event_counter_31_1_n;
      _thread_0_event_counter_29_1_q <= _thread_0_event_counter_29_1_n;
      _thread_0_event_syncstate_28_q <= _thread_0_event_syncstate_28_n;
      _thread_0_event_syncstate_27_q <= _thread_0_event_syncstate_27_n;
      _thread_0_event_syncstate_26_q <= _thread_0_event_syncstate_26_n;
      _thread_0_event_syncstate_25_q <= _thread_0_event_syncstate_25_n;
      _thread_0_event_counter_24_1_q <= _thread_0_event_counter_24_1_n;
      _thread_0_event_counter_23_1_q <= _thread_0_event_counter_23_1_n;
      _thread_0_event_counter_20_1_q <= _thread_0_event_counter_20_1_n;
      _thread_0_event_syncstate_19_q <= _thread_0_event_syncstate_19_n;
      _thread_0_event_syncstate_18_q <= _thread_0_event_syncstate_18_n;
      _thread_0_event_syncstate_17_q <= _thread_0_event_syncstate_17_n;
      _thread_0_event_syncstate_16_q <= _thread_0_event_syncstate_16_n;
      _thread_0_event_counter_15_1_q <= _thread_0_event_counter_15_1_n;
      _thread_0_event_counter_14_1_q <= _thread_0_event_counter_14_1_n;
      _thread_0_event_counter_12_1_q <= _thread_0_event_counter_12_1_n;
      _thread_0_event_syncstate_11_q <= _thread_0_event_syncstate_11_n;
      _thread_0_event_syncstate_10_q <= _thread_0_event_syncstate_10_n;
      _thread_0_event_syncstate_9_q <= _thread_0_event_syncstate_9_n;
      _thread_0_event_syncstate_8_q <= _thread_0_event_syncstate_8_n;
      _thread_0_event_counter_7_1_q <= _thread_0_event_counter_7_1_n;
      _thread_0_event_counter_6_1_q <= _thread_0_event_counter_6_1_n;
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
  logic[0:0] thread_0_wire$413;
  logic[185:0] thread_0_wire$412;
  logic[31:0] thread_0_wire$411;
  logic[10:0] thread_0_wire$410;
  logic[10:0] thread_0_wire$408;
  logic[9:0] thread_0_wire$406;
  logic[9:0] thread_0_wire$404;
  logic[1023:0] thread_0_wire$402;
  logic[31:0] thread_0_wire$401;
  logic[10:0] thread_0_wire$400;
  logic[10:0] thread_0_wire$398;
  logic[9:0] thread_0_wire$396;
  logic[9:0] thread_0_wire$394;
  logic[1023:0] thread_0_wire$392;
  logic[0:0] thread_0_wire$391;
  logic[0:0] thread_0_wire$390;
  logic[0:0] thread_0_wire$387;
  logic[185:0] thread_0_wire$386;
  logic[31:0] thread_0_wire$385;
  logic[10:0] thread_0_wire$384;
  logic[10:0] thread_0_wire$382;
  logic[9:0] thread_0_wire$380;
  logic[9:0] thread_0_wire$378;
  logic[1023:0] thread_0_wire$376;
  logic[31:0] thread_0_wire$375;
  logic[10:0] thread_0_wire$374;
  logic[10:0] thread_0_wire$372;
  logic[9:0] thread_0_wire$370;
  logic[9:0] thread_0_wire$368;
  logic[1023:0] thread_0_wire$366;
  logic[0:0] thread_0_wire$365;
  logic[0:0] thread_0_wire$364;
  logic[31:0] thread_0_wire$363;
  logic[0:0] thread_0_wire$361;
  logic[0:0] thread_0_wire$357;
  logic[185:0] thread_0_wire$356;
  logic[31:0] thread_0_wire$355;
  logic[10:0] thread_0_wire$354;
  logic[10:0] thread_0_wire$352;
  logic[9:0] thread_0_wire$350;
  logic[9:0] thread_0_wire$348;
  logic[1023:0] thread_0_wire$346;
  logic[31:0] thread_0_wire$345;
  logic[10:0] thread_0_wire$344;
  logic[10:0] thread_0_wire$342;
  logic[9:0] thread_0_wire$340;
  logic[9:0] thread_0_wire$338;
  logic[1023:0] thread_0_wire$336;
  logic[0:0] thread_0_wire$335;
  logic[0:0] thread_0_wire$334;
  logic[31:0] thread_0_wire$333;
  logic[0:0] thread_0_wire$331;
  logic[31:0] thread_0_wire$329;
  logic[0:0] thread_0_wire$327;
  logic[0:0] thread_0_wire$323;
  logic[185:0] thread_0_wire$322;
  logic[31:0] thread_0_wire$321;
  logic[10:0] thread_0_wire$320;
  logic[10:0] thread_0_wire$318;
  logic[9:0] thread_0_wire$316;
  logic[9:0] thread_0_wire$314;
  logic[1023:0] thread_0_wire$312;
  logic[31:0] thread_0_wire$311;
  logic[10:0] thread_0_wire$310;
  logic[10:0] thread_0_wire$308;
  logic[9:0] thread_0_wire$306;
  logic[9:0] thread_0_wire$304;
  logic[1023:0] thread_0_wire$302;
  logic[0:0] thread_0_wire$301;
  logic[0:0] thread_0_wire$300;
  logic[0:0] thread_0_wire$297;
  logic[185:0] thread_0_wire$296;
  logic[31:0] thread_0_wire$295;
  logic[10:0] thread_0_wire$294;
  logic[10:0] thread_0_wire$292;
  logic[9:0] thread_0_wire$290;
  logic[9:0] thread_0_wire$288;
  logic[1023:0] thread_0_wire$286;
  logic[31:0] thread_0_wire$285;
  logic[10:0] thread_0_wire$284;
  logic[10:0] thread_0_wire$282;
  logic[9:0] thread_0_wire$280;
  logic[9:0] thread_0_wire$278;
  logic[1023:0] thread_0_wire$276;
  logic[0:0] thread_0_wire$275;
  logic[0:0] thread_0_wire$274;
  logic[31:0] thread_0_wire$273;
  logic[0:0] thread_0_wire$271;
  logic[0:0] thread_0_wire$267;
  logic[185:0] thread_0_wire$266;
  logic[31:0] thread_0_wire$265;
  logic[10:0] thread_0_wire$264;
  logic[10:0] thread_0_wire$262;
  logic[9:0] thread_0_wire$260;
  logic[9:0] thread_0_wire$258;
  logic[1023:0] thread_0_wire$256;
  logic[31:0] thread_0_wire$255;
  logic[10:0] thread_0_wire$254;
  logic[10:0] thread_0_wire$252;
  logic[9:0] thread_0_wire$250;
  logic[9:0] thread_0_wire$248;
  logic[1023:0] thread_0_wire$246;
  logic[0:0] thread_0_wire$245;
  logic[0:0] thread_0_wire$244;
  logic[31:0] thread_0_wire$243;
  logic[0:0] thread_0_wire$241;
  logic[31:0] thread_0_wire$239;
  logic[0:0] thread_0_wire$237;
  logic[0:0] thread_0_wire$235;
  logic[0:0] thread_0_wire$233;
  logic[0:0] thread_0_wire$232;
  logic[0:0] thread_0_wire$230;
  logic[0:0] thread_0_wire$228;
  logic[0:0] thread_0_wire$226;
  logic[0:0] thread_0_wire$224;
  logic[4:0] thread_0_wire$222;
  logic[4:0] thread_0_wire$221;
  logic[4:0] thread_0_wire$220;
  logic[5:0] thread_0_wire$219;
  logic[5:0] thread_0_wire$218;
  logic[0:0] thread_0_wire$215;
  logic[185:0] thread_0_wire$214;
  logic[31:0] thread_0_wire$213;
  logic[10:0] thread_0_wire$212;
  logic[10:0] thread_0_wire$210;
  logic[9:0] thread_0_wire$208;
  logic[9:0] thread_0_wire$206;
  logic[1023:0] thread_0_wire$204;
  logic[31:0] thread_0_wire$203;
  logic[10:0] thread_0_wire$202;
  logic[10:0] thread_0_wire$200;
  logic[9:0] thread_0_wire$198;
  logic[9:0] thread_0_wire$196;
  logic[1023:0] thread_0_wire$194;
  logic[0:0] thread_0_wire$193;
  logic[0:0] thread_0_wire$192;
  logic[0:0] thread_0_wire$189;
  logic[185:0] thread_0_wire$188;
  logic[31:0] thread_0_wire$187;
  logic[10:0] thread_0_wire$186;
  logic[10:0] thread_0_wire$184;
  logic[9:0] thread_0_wire$182;
  logic[9:0] thread_0_wire$180;
  logic[1023:0] thread_0_wire$178;
  logic[31:0] thread_0_wire$177;
  logic[10:0] thread_0_wire$176;
  logic[10:0] thread_0_wire$174;
  logic[9:0] thread_0_wire$172;
  logic[9:0] thread_0_wire$170;
  logic[1023:0] thread_0_wire$168;
  logic[0:0] thread_0_wire$167;
  logic[0:0] thread_0_wire$166;
  logic[31:0] thread_0_wire$165;
  logic[0:0] thread_0_wire$163;
  logic[0:0] thread_0_wire$159;
  logic[185:0] thread_0_wire$158;
  logic[31:0] thread_0_wire$157;
  logic[10:0] thread_0_wire$156;
  logic[10:0] thread_0_wire$154;
  logic[9:0] thread_0_wire$152;
  logic[9:0] thread_0_wire$150;
  logic[1023:0] thread_0_wire$148;
  logic[31:0] thread_0_wire$147;
  logic[10:0] thread_0_wire$146;
  logic[10:0] thread_0_wire$144;
  logic[9:0] thread_0_wire$142;
  logic[9:0] thread_0_wire$140;
  logic[1023:0] thread_0_wire$138;
  logic[0:0] thread_0_wire$137;
  logic[0:0] thread_0_wire$136;
  logic[31:0] thread_0_wire$135;
  logic[0:0] thread_0_wire$133;
  logic[31:0] thread_0_wire$131;
  logic[0:0] thread_0_wire$129;
  logic[0:0] thread_0_wire$125;
  logic[185:0] thread_0_wire$124;
  logic[31:0] thread_0_wire$123;
  logic[10:0] thread_0_wire$122;
  logic[10:0] thread_0_wire$120;
  logic[9:0] thread_0_wire$118;
  logic[9:0] thread_0_wire$116;
  logic[1023:0] thread_0_wire$114;
  logic[31:0] thread_0_wire$113;
  logic[10:0] thread_0_wire$112;
  logic[10:0] thread_0_wire$110;
  logic[9:0] thread_0_wire$108;
  logic[9:0] thread_0_wire$106;
  logic[1023:0] thread_0_wire$104;
  logic[0:0] thread_0_wire$103;
  logic[0:0] thread_0_wire$102;
  logic[0:0] thread_0_wire$99;
  logic[185:0] thread_0_wire$98;
  logic[31:0] thread_0_wire$97;
  logic[10:0] thread_0_wire$96;
  logic[10:0] thread_0_wire$94;
  logic[9:0] thread_0_wire$92;
  logic[9:0] thread_0_wire$90;
  logic[1023:0] thread_0_wire$88;
  logic[31:0] thread_0_wire$87;
  logic[10:0] thread_0_wire$86;
  logic[10:0] thread_0_wire$84;
  logic[9:0] thread_0_wire$82;
  logic[9:0] thread_0_wire$80;
  logic[1023:0] thread_0_wire$78;
  logic[0:0] thread_0_wire$77;
  logic[0:0] thread_0_wire$76;
  logic[31:0] thread_0_wire$75;
  logic[0:0] thread_0_wire$73;
  logic[0:0] thread_0_wire$69;
  logic[185:0] thread_0_wire$68;
  logic[31:0] thread_0_wire$67;
  logic[10:0] thread_0_wire$66;
  logic[10:0] thread_0_wire$64;
  logic[9:0] thread_0_wire$62;
  logic[9:0] thread_0_wire$60;
  logic[1023:0] thread_0_wire$58;
  logic[31:0] thread_0_wire$57;
  logic[10:0] thread_0_wire$56;
  logic[10:0] thread_0_wire$54;
  logic[9:0] thread_0_wire$52;
  logic[9:0] thread_0_wire$50;
  logic[1023:0] thread_0_wire$48;
  logic[0:0] thread_0_wire$47;
  logic[0:0] thread_0_wire$46;
  logic[31:0] thread_0_wire$45;
  logic[0:0] thread_0_wire$43;
  logic[31:0] thread_0_wire$41;
  logic[0:0] thread_0_wire$39;
  logic[0:0] thread_0_wire$37;
  logic[0:0] thread_0_wire$35;
  logic[0:0] thread_0_wire$34;
  logic[0:0] thread_0_wire$32;
  logic[0:0] thread_0_wire$30;
  logic[0:0] thread_0_wire$28;
  logic[0:0] thread_0_wire$26;
  logic[4:0] thread_0_wire$24;
  logic[4:0] thread_0_wire$23;
  logic[4:0] thread_0_wire$22;
  logic[5:0] thread_0_wire$21;
  logic[5:0] thread_0_wire$20;
  logic[10:0] thread_0_wire$18;
  logic[10:0] thread_0_wire$16;
  logic[9:0] thread_0_wire$14;
  logic[9:0] thread_0_wire$12;
  logic[0:0] thread_0_wire$10;
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
  localparam logic[0:0] thread_0_wire$9 = 1'b1;
  assign thread_0_wire$10 = thread_0_wire$2 == thread_0_wire$9;
  localparam logic[4:0] thread_0_wire$11 = 5'd0;
  assign thread_0_wire$12 = {thread_0_wire$11, thread_0_wire$3};
  localparam logic[9:0] thread_0_wire$13 = 10'd32;
  assign thread_0_wire$14 = thread_0_wire$12 * thread_0_wire$13;
  localparam logic[0:0] thread_0_wire$15 = 1'd0;
  assign thread_0_wire$16 = {thread_0_wire$15, thread_0_wire$14};
  localparam logic[10:0] thread_0_wire$17 = 11'd0;
  assign thread_0_wire$18 = thread_0_wire$16 + thread_0_wire$17;
  localparam logic[31:0] thread_0_wire$19 = 32'd0;
  assign thread_0_wire$20 = thread_0_wire$5[26 +: 6];
  assign thread_0_wire$21 = thread_0_wire$5[0 +: 6];
  assign thread_0_wire$22 = thread_0_wire$5[11 +: 5];
  assign thread_0_wire$23 = thread_0_wire$5[16 +: 5];
  assign thread_0_wire$24 = thread_0_wire$5[21 +: 5];
  localparam logic[5:0] thread_0_wire$25 = 6'b000000;
  assign thread_0_wire$26 = thread_0_wire$20 == thread_0_wire$25;
  localparam logic[5:0] thread_0_wire$27 = 6'b100011;
  assign thread_0_wire$28 = thread_0_wire$20 == thread_0_wire$27;
  localparam logic[5:0] thread_0_wire$29 = 6'b101011;
  assign thread_0_wire$30 = thread_0_wire$20 == thread_0_wire$29;
  localparam logic[5:0] thread_0_wire$31 = 6'b000010;
  assign thread_0_wire$32 = thread_0_wire$20 == thread_0_wire$31;
  localparam logic[5:0] thread_0_wire$33 = 6'b100010;
  assign thread_0_wire$34 = thread_0_wire$21 == thread_0_wire$33;
  assign thread_0_wire$35 = thread_0_wire$26 & thread_0_wire$34;
  localparam logic[0:0] thread_0_wire$36 = 1'b1;
  assign thread_0_wire$37 = thread_0_wire$35 == thread_0_wire$36;
  localparam logic[3:0] thread_0_wire$38 = 4'd1;
  assign thread_0_wire$39 = thread_0_wire$5[15 +: 1];
  localparam logic[31:0] thread_0_wire$40 = 32'h0000ffff;
  assign thread_0_wire$41 = thread_0_wire$5 & thread_0_wire$40;
  localparam logic[0:0] thread_0_wire$42 = 1'b1;
  assign thread_0_wire$43 = thread_0_wire$32 == thread_0_wire$42;
  localparam logic[31:0] thread_0_wire$44 = 32'h001fffff;
  assign thread_0_wire$45 = thread_0_wire$5 & thread_0_wire$44;
  assign thread_0_wire$46 = thread_0_wire$26 | thread_0_wire$28;
  assign thread_0_wire$47 = thread_0_wire$28 | thread_0_wire$30;
  assign thread_0_wire$48 = regs_q;
  localparam logic[4:0] thread_0_wire$49 = 5'd0;
  assign thread_0_wire$50 = {thread_0_wire$49, thread_0_wire$23};
  localparam logic[9:0] thread_0_wire$51 = 10'd32;
  assign thread_0_wire$52 = thread_0_wire$50 * thread_0_wire$51;
  localparam logic[0:0] thread_0_wire$53 = 1'd0;
  assign thread_0_wire$54 = {thread_0_wire$53, thread_0_wire$52};
  localparam logic[10:0] thread_0_wire$55 = 11'd0;
  assign thread_0_wire$56 = thread_0_wire$54 + thread_0_wire$55;
  assign thread_0_wire$57 = thread_0_wire$48[thread_0_wire$56 +: 32];
  assign thread_0_wire$58 = regs_q;
  localparam logic[4:0] thread_0_wire$59 = 5'd0;
  assign thread_0_wire$60 = {thread_0_wire$59, thread_0_wire$24};
  localparam logic[9:0] thread_0_wire$61 = 10'd32;
  assign thread_0_wire$62 = thread_0_wire$60 * thread_0_wire$61;
  localparam logic[0:0] thread_0_wire$63 = 1'd0;
  assign thread_0_wire$64 = {thread_0_wire$63, thread_0_wire$62};
  localparam logic[10:0] thread_0_wire$65 = 11'd0;
  assign thread_0_wire$66 = thread_0_wire$64 + thread_0_wire$65;
  assign thread_0_wire$67 = thread_0_wire$58[thread_0_wire$66 +: 32];
  assign thread_0_wire$68 = {thread_0_wire$6, thread_0_wire$67, thread_0_wire$57, thread_0_wire$45, thread_0_wire$8, thread_0_wire$24, thread_0_wire$23, thread_0_wire$22, thread_0_wire$38, thread_0_wire$47, thread_0_wire$26, thread_0_wire$28, thread_0_wire$30, thread_0_wire$46, thread_0_wire$28, thread_0_wire$32};
  assign thread_0_wire$69 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$70 = 1'b1;
  localparam logic[0:0] thread_0_wire$71 = 1'b1;
  localparam logic[0:0] thread_0_wire$72 = 1'b1;
  assign thread_0_wire$73 = thread_0_wire$39 == thread_0_wire$72;
  localparam logic[31:0] thread_0_wire$74 = 32'hffff0000;
  assign thread_0_wire$75 = thread_0_wire$41 | thread_0_wire$74;
  assign thread_0_wire$76 = thread_0_wire$26 | thread_0_wire$28;
  assign thread_0_wire$77 = thread_0_wire$28 | thread_0_wire$30;
  assign thread_0_wire$78 = regs_q;
  localparam logic[4:0] thread_0_wire$79 = 5'd0;
  assign thread_0_wire$80 = {thread_0_wire$79, thread_0_wire$23};
  localparam logic[9:0] thread_0_wire$81 = 10'd32;
  assign thread_0_wire$82 = thread_0_wire$80 * thread_0_wire$81;
  localparam logic[0:0] thread_0_wire$83 = 1'd0;
  assign thread_0_wire$84 = {thread_0_wire$83, thread_0_wire$82};
  localparam logic[10:0] thread_0_wire$85 = 11'd0;
  assign thread_0_wire$86 = thread_0_wire$84 + thread_0_wire$85;
  assign thread_0_wire$87 = thread_0_wire$78[thread_0_wire$86 +: 32];
  assign thread_0_wire$88 = regs_q;
  localparam logic[4:0] thread_0_wire$89 = 5'd0;
  assign thread_0_wire$90 = {thread_0_wire$89, thread_0_wire$24};
  localparam logic[9:0] thread_0_wire$91 = 10'd32;
  assign thread_0_wire$92 = thread_0_wire$90 * thread_0_wire$91;
  localparam logic[0:0] thread_0_wire$93 = 1'd0;
  assign thread_0_wire$94 = {thread_0_wire$93, thread_0_wire$92};
  localparam logic[10:0] thread_0_wire$95 = 11'd0;
  assign thread_0_wire$96 = thread_0_wire$94 + thread_0_wire$95;
  assign thread_0_wire$97 = thread_0_wire$88[thread_0_wire$96 +: 32];
  assign thread_0_wire$98 = {thread_0_wire$6, thread_0_wire$97, thread_0_wire$87, thread_0_wire$75, thread_0_wire$8, thread_0_wire$24, thread_0_wire$23, thread_0_wire$22, thread_0_wire$38, thread_0_wire$77, thread_0_wire$26, thread_0_wire$28, thread_0_wire$30, thread_0_wire$76, thread_0_wire$28, thread_0_wire$32};
  assign thread_0_wire$99 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$100 = 1'b1;
  localparam logic[0:0] thread_0_wire$101 = 1'b1;
  assign thread_0_wire$102 = thread_0_wire$26 | thread_0_wire$28;
  assign thread_0_wire$103 = thread_0_wire$28 | thread_0_wire$30;
  assign thread_0_wire$104 = regs_q;
  localparam logic[4:0] thread_0_wire$105 = 5'd0;
  assign thread_0_wire$106 = {thread_0_wire$105, thread_0_wire$23};
  localparam logic[9:0] thread_0_wire$107 = 10'd32;
  assign thread_0_wire$108 = thread_0_wire$106 * thread_0_wire$107;
  localparam logic[0:0] thread_0_wire$109 = 1'd0;
  assign thread_0_wire$110 = {thread_0_wire$109, thread_0_wire$108};
  localparam logic[10:0] thread_0_wire$111 = 11'd0;
  assign thread_0_wire$112 = thread_0_wire$110 + thread_0_wire$111;
  assign thread_0_wire$113 = thread_0_wire$104[thread_0_wire$112 +: 32];
  assign thread_0_wire$114 = regs_q;
  localparam logic[4:0] thread_0_wire$115 = 5'd0;
  assign thread_0_wire$116 = {thread_0_wire$115, thread_0_wire$24};
  localparam logic[9:0] thread_0_wire$117 = 10'd32;
  assign thread_0_wire$118 = thread_0_wire$116 * thread_0_wire$117;
  localparam logic[0:0] thread_0_wire$119 = 1'd0;
  assign thread_0_wire$120 = {thread_0_wire$119, thread_0_wire$118};
  localparam logic[10:0] thread_0_wire$121 = 11'd0;
  assign thread_0_wire$122 = thread_0_wire$120 + thread_0_wire$121;
  assign thread_0_wire$123 = thread_0_wire$114[thread_0_wire$122 +: 32];
  assign thread_0_wire$124 = {thread_0_wire$6, thread_0_wire$123, thread_0_wire$113, thread_0_wire$41, thread_0_wire$8, thread_0_wire$24, thread_0_wire$23, thread_0_wire$22, thread_0_wire$38, thread_0_wire$103, thread_0_wire$26, thread_0_wire$28, thread_0_wire$30, thread_0_wire$102, thread_0_wire$28, thread_0_wire$32};
  assign thread_0_wire$125 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$126 = 1'b1;
  localparam logic[0:0] thread_0_wire$127 = 1'b1;
  localparam logic[3:0] thread_0_wire$128 = 4'd0;
  assign thread_0_wire$129 = thread_0_wire$5[15 +: 1];
  localparam logic[31:0] thread_0_wire$130 = 32'h0000ffff;
  assign thread_0_wire$131 = thread_0_wire$5 & thread_0_wire$130;
  localparam logic[0:0] thread_0_wire$132 = 1'b1;
  assign thread_0_wire$133 = thread_0_wire$32 == thread_0_wire$132;
  localparam logic[31:0] thread_0_wire$134 = 32'h001fffff;
  assign thread_0_wire$135 = thread_0_wire$5 & thread_0_wire$134;
  assign thread_0_wire$136 = thread_0_wire$26 | thread_0_wire$28;
  assign thread_0_wire$137 = thread_0_wire$28 | thread_0_wire$30;
  assign thread_0_wire$138 = regs_q;
  localparam logic[4:0] thread_0_wire$139 = 5'd0;
  assign thread_0_wire$140 = {thread_0_wire$139, thread_0_wire$23};
  localparam logic[9:0] thread_0_wire$141 = 10'd32;
  assign thread_0_wire$142 = thread_0_wire$140 * thread_0_wire$141;
  localparam logic[0:0] thread_0_wire$143 = 1'd0;
  assign thread_0_wire$144 = {thread_0_wire$143, thread_0_wire$142};
  localparam logic[10:0] thread_0_wire$145 = 11'd0;
  assign thread_0_wire$146 = thread_0_wire$144 + thread_0_wire$145;
  assign thread_0_wire$147 = thread_0_wire$138[thread_0_wire$146 +: 32];
  assign thread_0_wire$148 = regs_q;
  localparam logic[4:0] thread_0_wire$149 = 5'd0;
  assign thread_0_wire$150 = {thread_0_wire$149, thread_0_wire$24};
  localparam logic[9:0] thread_0_wire$151 = 10'd32;
  assign thread_0_wire$152 = thread_0_wire$150 * thread_0_wire$151;
  localparam logic[0:0] thread_0_wire$153 = 1'd0;
  assign thread_0_wire$154 = {thread_0_wire$153, thread_0_wire$152};
  localparam logic[10:0] thread_0_wire$155 = 11'd0;
  assign thread_0_wire$156 = thread_0_wire$154 + thread_0_wire$155;
  assign thread_0_wire$157 = thread_0_wire$148[thread_0_wire$156 +: 32];
  assign thread_0_wire$158 = {thread_0_wire$6, thread_0_wire$157, thread_0_wire$147, thread_0_wire$135, thread_0_wire$8, thread_0_wire$24, thread_0_wire$23, thread_0_wire$22, thread_0_wire$128, thread_0_wire$137, thread_0_wire$26, thread_0_wire$28, thread_0_wire$30, thread_0_wire$136, thread_0_wire$28, thread_0_wire$32};
  assign thread_0_wire$159 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$160 = 1'b1;
  localparam logic[0:0] thread_0_wire$161 = 1'b1;
  localparam logic[0:0] thread_0_wire$162 = 1'b1;
  assign thread_0_wire$163 = thread_0_wire$129 == thread_0_wire$162;
  localparam logic[31:0] thread_0_wire$164 = 32'hffff0000;
  assign thread_0_wire$165 = thread_0_wire$131 | thread_0_wire$164;
  assign thread_0_wire$166 = thread_0_wire$26 | thread_0_wire$28;
  assign thread_0_wire$167 = thread_0_wire$28 | thread_0_wire$30;
  assign thread_0_wire$168 = regs_q;
  localparam logic[4:0] thread_0_wire$169 = 5'd0;
  assign thread_0_wire$170 = {thread_0_wire$169, thread_0_wire$23};
  localparam logic[9:0] thread_0_wire$171 = 10'd32;
  assign thread_0_wire$172 = thread_0_wire$170 * thread_0_wire$171;
  localparam logic[0:0] thread_0_wire$173 = 1'd0;
  assign thread_0_wire$174 = {thread_0_wire$173, thread_0_wire$172};
  localparam logic[10:0] thread_0_wire$175 = 11'd0;
  assign thread_0_wire$176 = thread_0_wire$174 + thread_0_wire$175;
  assign thread_0_wire$177 = thread_0_wire$168[thread_0_wire$176 +: 32];
  assign thread_0_wire$178 = regs_q;
  localparam logic[4:0] thread_0_wire$179 = 5'd0;
  assign thread_0_wire$180 = {thread_0_wire$179, thread_0_wire$24};
  localparam logic[9:0] thread_0_wire$181 = 10'd32;
  assign thread_0_wire$182 = thread_0_wire$180 * thread_0_wire$181;
  localparam logic[0:0] thread_0_wire$183 = 1'd0;
  assign thread_0_wire$184 = {thread_0_wire$183, thread_0_wire$182};
  localparam logic[10:0] thread_0_wire$185 = 11'd0;
  assign thread_0_wire$186 = thread_0_wire$184 + thread_0_wire$185;
  assign thread_0_wire$187 = thread_0_wire$178[thread_0_wire$186 +: 32];
  assign thread_0_wire$188 = {thread_0_wire$6, thread_0_wire$187, thread_0_wire$177, thread_0_wire$165, thread_0_wire$8, thread_0_wire$24, thread_0_wire$23, thread_0_wire$22, thread_0_wire$128, thread_0_wire$167, thread_0_wire$26, thread_0_wire$28, thread_0_wire$30, thread_0_wire$166, thread_0_wire$28, thread_0_wire$32};
  assign thread_0_wire$189 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$190 = 1'b1;
  localparam logic[0:0] thread_0_wire$191 = 1'b1;
  assign thread_0_wire$192 = thread_0_wire$26 | thread_0_wire$28;
  assign thread_0_wire$193 = thread_0_wire$28 | thread_0_wire$30;
  assign thread_0_wire$194 = regs_q;
  localparam logic[4:0] thread_0_wire$195 = 5'd0;
  assign thread_0_wire$196 = {thread_0_wire$195, thread_0_wire$23};
  localparam logic[9:0] thread_0_wire$197 = 10'd32;
  assign thread_0_wire$198 = thread_0_wire$196 * thread_0_wire$197;
  localparam logic[0:0] thread_0_wire$199 = 1'd0;
  assign thread_0_wire$200 = {thread_0_wire$199, thread_0_wire$198};
  localparam logic[10:0] thread_0_wire$201 = 11'd0;
  assign thread_0_wire$202 = thread_0_wire$200 + thread_0_wire$201;
  assign thread_0_wire$203 = thread_0_wire$194[thread_0_wire$202 +: 32];
  assign thread_0_wire$204 = regs_q;
  localparam logic[4:0] thread_0_wire$205 = 5'd0;
  assign thread_0_wire$206 = {thread_0_wire$205, thread_0_wire$24};
  localparam logic[9:0] thread_0_wire$207 = 10'd32;
  assign thread_0_wire$208 = thread_0_wire$206 * thread_0_wire$207;
  localparam logic[0:0] thread_0_wire$209 = 1'd0;
  assign thread_0_wire$210 = {thread_0_wire$209, thread_0_wire$208};
  localparam logic[10:0] thread_0_wire$211 = 11'd0;
  assign thread_0_wire$212 = thread_0_wire$210 + thread_0_wire$211;
  assign thread_0_wire$213 = thread_0_wire$204[thread_0_wire$212 +: 32];
  assign thread_0_wire$214 = {thread_0_wire$6, thread_0_wire$213, thread_0_wire$203, thread_0_wire$131, thread_0_wire$8, thread_0_wire$24, thread_0_wire$23, thread_0_wire$22, thread_0_wire$128, thread_0_wire$193, thread_0_wire$26, thread_0_wire$28, thread_0_wire$30, thread_0_wire$192, thread_0_wire$28, thread_0_wire$32};
  assign thread_0_wire$215 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$216 = 1'b1;
  localparam logic[0:0] thread_0_wire$217 = 1'b1;
  assign thread_0_wire$218 = thread_0_wire$5[26 +: 6];
  assign thread_0_wire$219 = thread_0_wire$5[0 +: 6];
  assign thread_0_wire$220 = thread_0_wire$5[11 +: 5];
  assign thread_0_wire$221 = thread_0_wire$5[16 +: 5];
  assign thread_0_wire$222 = thread_0_wire$5[21 +: 5];
  localparam logic[5:0] thread_0_wire$223 = 6'b000000;
  assign thread_0_wire$224 = thread_0_wire$218 == thread_0_wire$223;
  localparam logic[5:0] thread_0_wire$225 = 6'b100011;
  assign thread_0_wire$226 = thread_0_wire$218 == thread_0_wire$225;
  localparam logic[5:0] thread_0_wire$227 = 6'b101011;
  assign thread_0_wire$228 = thread_0_wire$218 == thread_0_wire$227;
  localparam logic[5:0] thread_0_wire$229 = 6'b000010;
  assign thread_0_wire$230 = thread_0_wire$218 == thread_0_wire$229;
  localparam logic[5:0] thread_0_wire$231 = 6'b100010;
  assign thread_0_wire$232 = thread_0_wire$219 == thread_0_wire$231;
  assign thread_0_wire$233 = thread_0_wire$224 & thread_0_wire$232;
  localparam logic[0:0] thread_0_wire$234 = 1'b1;
  assign thread_0_wire$235 = thread_0_wire$233 == thread_0_wire$234;
  localparam logic[3:0] thread_0_wire$236 = 4'd1;
  assign thread_0_wire$237 = thread_0_wire$5[15 +: 1];
  localparam logic[31:0] thread_0_wire$238 = 32'h0000ffff;
  assign thread_0_wire$239 = thread_0_wire$5 & thread_0_wire$238;
  localparam logic[0:0] thread_0_wire$240 = 1'b1;
  assign thread_0_wire$241 = thread_0_wire$230 == thread_0_wire$240;
  localparam logic[31:0] thread_0_wire$242 = 32'h001fffff;
  assign thread_0_wire$243 = thread_0_wire$5 & thread_0_wire$242;
  assign thread_0_wire$244 = thread_0_wire$224 | thread_0_wire$226;
  assign thread_0_wire$245 = thread_0_wire$226 | thread_0_wire$228;
  assign thread_0_wire$246 = regs_q;
  localparam logic[4:0] thread_0_wire$247 = 5'd0;
  assign thread_0_wire$248 = {thread_0_wire$247, thread_0_wire$221};
  localparam logic[9:0] thread_0_wire$249 = 10'd32;
  assign thread_0_wire$250 = thread_0_wire$248 * thread_0_wire$249;
  localparam logic[0:0] thread_0_wire$251 = 1'd0;
  assign thread_0_wire$252 = {thread_0_wire$251, thread_0_wire$250};
  localparam logic[10:0] thread_0_wire$253 = 11'd0;
  assign thread_0_wire$254 = thread_0_wire$252 + thread_0_wire$253;
  assign thread_0_wire$255 = thread_0_wire$246[thread_0_wire$254 +: 32];
  assign thread_0_wire$256 = regs_q;
  localparam logic[4:0] thread_0_wire$257 = 5'd0;
  assign thread_0_wire$258 = {thread_0_wire$257, thread_0_wire$222};
  localparam logic[9:0] thread_0_wire$259 = 10'd32;
  assign thread_0_wire$260 = thread_0_wire$258 * thread_0_wire$259;
  localparam logic[0:0] thread_0_wire$261 = 1'd0;
  assign thread_0_wire$262 = {thread_0_wire$261, thread_0_wire$260};
  localparam logic[10:0] thread_0_wire$263 = 11'd0;
  assign thread_0_wire$264 = thread_0_wire$262 + thread_0_wire$263;
  assign thread_0_wire$265 = thread_0_wire$256[thread_0_wire$264 +: 32];
  assign thread_0_wire$266 = {thread_0_wire$6, thread_0_wire$265, thread_0_wire$255, thread_0_wire$243, thread_0_wire$8, thread_0_wire$222, thread_0_wire$221, thread_0_wire$220, thread_0_wire$236, thread_0_wire$245, thread_0_wire$224, thread_0_wire$226, thread_0_wire$228, thread_0_wire$244, thread_0_wire$226, thread_0_wire$230};
  assign thread_0_wire$267 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$268 = 1'b1;
  localparam logic[0:0] thread_0_wire$269 = 1'b1;
  localparam logic[0:0] thread_0_wire$270 = 1'b1;
  assign thread_0_wire$271 = thread_0_wire$237 == thread_0_wire$270;
  localparam logic[31:0] thread_0_wire$272 = 32'hffff0000;
  assign thread_0_wire$273 = thread_0_wire$239 | thread_0_wire$272;
  assign thread_0_wire$274 = thread_0_wire$224 | thread_0_wire$226;
  assign thread_0_wire$275 = thread_0_wire$226 | thread_0_wire$228;
  assign thread_0_wire$276 = regs_q;
  localparam logic[4:0] thread_0_wire$277 = 5'd0;
  assign thread_0_wire$278 = {thread_0_wire$277, thread_0_wire$221};
  localparam logic[9:0] thread_0_wire$279 = 10'd32;
  assign thread_0_wire$280 = thread_0_wire$278 * thread_0_wire$279;
  localparam logic[0:0] thread_0_wire$281 = 1'd0;
  assign thread_0_wire$282 = {thread_0_wire$281, thread_0_wire$280};
  localparam logic[10:0] thread_0_wire$283 = 11'd0;
  assign thread_0_wire$284 = thread_0_wire$282 + thread_0_wire$283;
  assign thread_0_wire$285 = thread_0_wire$276[thread_0_wire$284 +: 32];
  assign thread_0_wire$286 = regs_q;
  localparam logic[4:0] thread_0_wire$287 = 5'd0;
  assign thread_0_wire$288 = {thread_0_wire$287, thread_0_wire$222};
  localparam logic[9:0] thread_0_wire$289 = 10'd32;
  assign thread_0_wire$290 = thread_0_wire$288 * thread_0_wire$289;
  localparam logic[0:0] thread_0_wire$291 = 1'd0;
  assign thread_0_wire$292 = {thread_0_wire$291, thread_0_wire$290};
  localparam logic[10:0] thread_0_wire$293 = 11'd0;
  assign thread_0_wire$294 = thread_0_wire$292 + thread_0_wire$293;
  assign thread_0_wire$295 = thread_0_wire$286[thread_0_wire$294 +: 32];
  assign thread_0_wire$296 = {thread_0_wire$6, thread_0_wire$295, thread_0_wire$285, thread_0_wire$273, thread_0_wire$8, thread_0_wire$222, thread_0_wire$221, thread_0_wire$220, thread_0_wire$236, thread_0_wire$275, thread_0_wire$224, thread_0_wire$226, thread_0_wire$228, thread_0_wire$274, thread_0_wire$226, thread_0_wire$230};
  assign thread_0_wire$297 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$298 = 1'b1;
  localparam logic[0:0] thread_0_wire$299 = 1'b1;
  assign thread_0_wire$300 = thread_0_wire$224 | thread_0_wire$226;
  assign thread_0_wire$301 = thread_0_wire$226 | thread_0_wire$228;
  assign thread_0_wire$302 = regs_q;
  localparam logic[4:0] thread_0_wire$303 = 5'd0;
  assign thread_0_wire$304 = {thread_0_wire$303, thread_0_wire$221};
  localparam logic[9:0] thread_0_wire$305 = 10'd32;
  assign thread_0_wire$306 = thread_0_wire$304 * thread_0_wire$305;
  localparam logic[0:0] thread_0_wire$307 = 1'd0;
  assign thread_0_wire$308 = {thread_0_wire$307, thread_0_wire$306};
  localparam logic[10:0] thread_0_wire$309 = 11'd0;
  assign thread_0_wire$310 = thread_0_wire$308 + thread_0_wire$309;
  assign thread_0_wire$311 = thread_0_wire$302[thread_0_wire$310 +: 32];
  assign thread_0_wire$312 = regs_q;
  localparam logic[4:0] thread_0_wire$313 = 5'd0;
  assign thread_0_wire$314 = {thread_0_wire$313, thread_0_wire$222};
  localparam logic[9:0] thread_0_wire$315 = 10'd32;
  assign thread_0_wire$316 = thread_0_wire$314 * thread_0_wire$315;
  localparam logic[0:0] thread_0_wire$317 = 1'd0;
  assign thread_0_wire$318 = {thread_0_wire$317, thread_0_wire$316};
  localparam logic[10:0] thread_0_wire$319 = 11'd0;
  assign thread_0_wire$320 = thread_0_wire$318 + thread_0_wire$319;
  assign thread_0_wire$321 = thread_0_wire$312[thread_0_wire$320 +: 32];
  assign thread_0_wire$322 = {thread_0_wire$6, thread_0_wire$321, thread_0_wire$311, thread_0_wire$239, thread_0_wire$8, thread_0_wire$222, thread_0_wire$221, thread_0_wire$220, thread_0_wire$236, thread_0_wire$301, thread_0_wire$224, thread_0_wire$226, thread_0_wire$228, thread_0_wire$300, thread_0_wire$226, thread_0_wire$230};
  assign thread_0_wire$323 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$324 = 1'b1;
  localparam logic[0:0] thread_0_wire$325 = 1'b1;
  localparam logic[3:0] thread_0_wire$326 = 4'd0;
  assign thread_0_wire$327 = thread_0_wire$5[15 +: 1];
  localparam logic[31:0] thread_0_wire$328 = 32'h0000ffff;
  assign thread_0_wire$329 = thread_0_wire$5 & thread_0_wire$328;
  localparam logic[0:0] thread_0_wire$330 = 1'b1;
  assign thread_0_wire$331 = thread_0_wire$230 == thread_0_wire$330;
  localparam logic[31:0] thread_0_wire$332 = 32'h001fffff;
  assign thread_0_wire$333 = thread_0_wire$5 & thread_0_wire$332;
  assign thread_0_wire$334 = thread_0_wire$224 | thread_0_wire$226;
  assign thread_0_wire$335 = thread_0_wire$226 | thread_0_wire$228;
  assign thread_0_wire$336 = regs_q;
  localparam logic[4:0] thread_0_wire$337 = 5'd0;
  assign thread_0_wire$338 = {thread_0_wire$337, thread_0_wire$221};
  localparam logic[9:0] thread_0_wire$339 = 10'd32;
  assign thread_0_wire$340 = thread_0_wire$338 * thread_0_wire$339;
  localparam logic[0:0] thread_0_wire$341 = 1'd0;
  assign thread_0_wire$342 = {thread_0_wire$341, thread_0_wire$340};
  localparam logic[10:0] thread_0_wire$343 = 11'd0;
  assign thread_0_wire$344 = thread_0_wire$342 + thread_0_wire$343;
  assign thread_0_wire$345 = thread_0_wire$336[thread_0_wire$344 +: 32];
  assign thread_0_wire$346 = regs_q;
  localparam logic[4:0] thread_0_wire$347 = 5'd0;
  assign thread_0_wire$348 = {thread_0_wire$347, thread_0_wire$222};
  localparam logic[9:0] thread_0_wire$349 = 10'd32;
  assign thread_0_wire$350 = thread_0_wire$348 * thread_0_wire$349;
  localparam logic[0:0] thread_0_wire$351 = 1'd0;
  assign thread_0_wire$352 = {thread_0_wire$351, thread_0_wire$350};
  localparam logic[10:0] thread_0_wire$353 = 11'd0;
  assign thread_0_wire$354 = thread_0_wire$352 + thread_0_wire$353;
  assign thread_0_wire$355 = thread_0_wire$346[thread_0_wire$354 +: 32];
  assign thread_0_wire$356 = {thread_0_wire$6, thread_0_wire$355, thread_0_wire$345, thread_0_wire$333, thread_0_wire$8, thread_0_wire$222, thread_0_wire$221, thread_0_wire$220, thread_0_wire$326, thread_0_wire$335, thread_0_wire$224, thread_0_wire$226, thread_0_wire$228, thread_0_wire$334, thread_0_wire$226, thread_0_wire$230};
  assign thread_0_wire$357 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$358 = 1'b1;
  localparam logic[0:0] thread_0_wire$359 = 1'b1;
  localparam logic[0:0] thread_0_wire$360 = 1'b1;
  assign thread_0_wire$361 = thread_0_wire$327 == thread_0_wire$360;
  localparam logic[31:0] thread_0_wire$362 = 32'hffff0000;
  assign thread_0_wire$363 = thread_0_wire$329 | thread_0_wire$362;
  assign thread_0_wire$364 = thread_0_wire$224 | thread_0_wire$226;
  assign thread_0_wire$365 = thread_0_wire$226 | thread_0_wire$228;
  assign thread_0_wire$366 = regs_q;
  localparam logic[4:0] thread_0_wire$367 = 5'd0;
  assign thread_0_wire$368 = {thread_0_wire$367, thread_0_wire$221};
  localparam logic[9:0] thread_0_wire$369 = 10'd32;
  assign thread_0_wire$370 = thread_0_wire$368 * thread_0_wire$369;
  localparam logic[0:0] thread_0_wire$371 = 1'd0;
  assign thread_0_wire$372 = {thread_0_wire$371, thread_0_wire$370};
  localparam logic[10:0] thread_0_wire$373 = 11'd0;
  assign thread_0_wire$374 = thread_0_wire$372 + thread_0_wire$373;
  assign thread_0_wire$375 = thread_0_wire$366[thread_0_wire$374 +: 32];
  assign thread_0_wire$376 = regs_q;
  localparam logic[4:0] thread_0_wire$377 = 5'd0;
  assign thread_0_wire$378 = {thread_0_wire$377, thread_0_wire$222};
  localparam logic[9:0] thread_0_wire$379 = 10'd32;
  assign thread_0_wire$380 = thread_0_wire$378 * thread_0_wire$379;
  localparam logic[0:0] thread_0_wire$381 = 1'd0;
  assign thread_0_wire$382 = {thread_0_wire$381, thread_0_wire$380};
  localparam logic[10:0] thread_0_wire$383 = 11'd0;
  assign thread_0_wire$384 = thread_0_wire$382 + thread_0_wire$383;
  assign thread_0_wire$385 = thread_0_wire$376[thread_0_wire$384 +: 32];
  assign thread_0_wire$386 = {thread_0_wire$6, thread_0_wire$385, thread_0_wire$375, thread_0_wire$363, thread_0_wire$8, thread_0_wire$222, thread_0_wire$221, thread_0_wire$220, thread_0_wire$326, thread_0_wire$365, thread_0_wire$224, thread_0_wire$226, thread_0_wire$228, thread_0_wire$364, thread_0_wire$226, thread_0_wire$230};
  assign thread_0_wire$387 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$388 = 1'b1;
  localparam logic[0:0] thread_0_wire$389 = 1'b1;
  assign thread_0_wire$390 = thread_0_wire$224 | thread_0_wire$226;
  assign thread_0_wire$391 = thread_0_wire$226 | thread_0_wire$228;
  assign thread_0_wire$392 = regs_q;
  localparam logic[4:0] thread_0_wire$393 = 5'd0;
  assign thread_0_wire$394 = {thread_0_wire$393, thread_0_wire$221};
  localparam logic[9:0] thread_0_wire$395 = 10'd32;
  assign thread_0_wire$396 = thread_0_wire$394 * thread_0_wire$395;
  localparam logic[0:0] thread_0_wire$397 = 1'd0;
  assign thread_0_wire$398 = {thread_0_wire$397, thread_0_wire$396};
  localparam logic[10:0] thread_0_wire$399 = 11'd0;
  assign thread_0_wire$400 = thread_0_wire$398 + thread_0_wire$399;
  assign thread_0_wire$401 = thread_0_wire$392[thread_0_wire$400 +: 32];
  assign thread_0_wire$402 = regs_q;
  localparam logic[4:0] thread_0_wire$403 = 5'd0;
  assign thread_0_wire$404 = {thread_0_wire$403, thread_0_wire$222};
  localparam logic[9:0] thread_0_wire$405 = 10'd32;
  assign thread_0_wire$406 = thread_0_wire$404 * thread_0_wire$405;
  localparam logic[0:0] thread_0_wire$407 = 1'd0;
  assign thread_0_wire$408 = {thread_0_wire$407, thread_0_wire$406};
  localparam logic[10:0] thread_0_wire$409 = 11'd0;
  assign thread_0_wire$410 = thread_0_wire$408 + thread_0_wire$409;
  assign thread_0_wire$411 = thread_0_wire$402[thread_0_wire$410 +: 32];
  assign thread_0_wire$412 = {thread_0_wire$6, thread_0_wire$411, thread_0_wire$401, thread_0_wire$329, thread_0_wire$8, thread_0_wire$222, thread_0_wire$221, thread_0_wire$220, thread_0_wire$326, thread_0_wire$391, thread_0_wire$224, thread_0_wire$226, thread_0_wire$228, thread_0_wire$390, thread_0_wire$226, thread_0_wire$230};
  assign thread_0_wire$413 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$414 = 1'b1;
  localparam logic[0:0] thread_0_wire$415 = 1'b1;
  for (genvar i = 0; i < 77; i ++) begin : EVENTS0
    logic event_current;
    end
  logic _init_0;
  logic _thread_0_event_counter_76_1_q, _thread_0_event_counter_76_1_n;
  logic _thread_0_event_syncstate_74_q, _thread_0_event_syncstate_74_n;
  logic _thread_0_event_syncstate_73_q, _thread_0_event_syncstate_73_n;
  logic _thread_0_event_syncstate_72_q, _thread_0_event_syncstate_72_n;
  logic _thread_0_event_syncstate_71_q, _thread_0_event_syncstate_71_n;
  logic _thread_0_event_syncstate_69_q, _thread_0_event_syncstate_69_n;
  logic _thread_0_event_syncstate_68_q, _thread_0_event_syncstate_68_n;
  logic _thread_0_event_syncstate_67_q, _thread_0_event_syncstate_67_n;
  logic _thread_0_event_syncstate_66_q, _thread_0_event_syncstate_66_n;
  logic _thread_0_event_syncstate_63_q, _thread_0_event_syncstate_63_n;
  logic _thread_0_event_syncstate_62_q, _thread_0_event_syncstate_62_n;
  logic _thread_0_event_syncstate_61_q, _thread_0_event_syncstate_61_n;
  logic _thread_0_event_syncstate_60_q, _thread_0_event_syncstate_60_n;
  logic _thread_0_event_syncstate_57_q, _thread_0_event_syncstate_57_n;
  logic _thread_0_event_syncstate_56_q, _thread_0_event_syncstate_56_n;
  logic _thread_0_event_syncstate_55_q, _thread_0_event_syncstate_55_n;
  logic _thread_0_event_syncstate_54_q, _thread_0_event_syncstate_54_n;
  logic _thread_0_event_syncstate_52_q, _thread_0_event_syncstate_52_n;
  logic _thread_0_event_syncstate_51_q, _thread_0_event_syncstate_51_n;
  logic _thread_0_event_syncstate_50_q, _thread_0_event_syncstate_50_n;
  logic _thread_0_event_syncstate_49_q, _thread_0_event_syncstate_49_n;
  logic _thread_0_event_syncstate_46_q, _thread_0_event_syncstate_46_n;
  logic _thread_0_event_syncstate_45_q, _thread_0_event_syncstate_45_n;
  logic _thread_0_event_syncstate_44_q, _thread_0_event_syncstate_44_n;
  logic _thread_0_event_syncstate_43_q, _thread_0_event_syncstate_43_n;
  logic _thread_0_event_syncstate_39_q, _thread_0_event_syncstate_39_n;
  logic _thread_0_event_syncstate_38_q, _thread_0_event_syncstate_38_n;
  logic _thread_0_event_syncstate_37_q, _thread_0_event_syncstate_37_n;
  logic _thread_0_event_syncstate_36_q, _thread_0_event_syncstate_36_n;
  logic _thread_0_event_syncstate_34_q, _thread_0_event_syncstate_34_n;
  logic _thread_0_event_syncstate_33_q, _thread_0_event_syncstate_33_n;
  logic _thread_0_event_syncstate_32_q, _thread_0_event_syncstate_32_n;
  logic _thread_0_event_syncstate_31_q, _thread_0_event_syncstate_31_n;
  logic _thread_0_event_syncstate_28_q, _thread_0_event_syncstate_28_n;
  logic _thread_0_event_syncstate_27_q, _thread_0_event_syncstate_27_n;
  logic _thread_0_event_syncstate_26_q, _thread_0_event_syncstate_26_n;
  logic _thread_0_event_syncstate_25_q, _thread_0_event_syncstate_25_n;
  logic _thread_0_event_syncstate_22_q, _thread_0_event_syncstate_22_n;
  logic _thread_0_event_syncstate_21_q, _thread_0_event_syncstate_21_n;
  logic _thread_0_event_syncstate_20_q, _thread_0_event_syncstate_20_n;
  logic _thread_0_event_syncstate_19_q, _thread_0_event_syncstate_19_n;
  logic _thread_0_event_syncstate_17_q, _thread_0_event_syncstate_17_n;
  logic _thread_0_event_syncstate_16_q, _thread_0_event_syncstate_16_n;
  logic _thread_0_event_syncstate_15_q, _thread_0_event_syncstate_15_n;
  logic _thread_0_event_syncstate_14_q, _thread_0_event_syncstate_14_n;
  logic _thread_0_event_syncstate_11_q, _thread_0_event_syncstate_11_n;
  logic _thread_0_event_syncstate_10_q, _thread_0_event_syncstate_10_n;
  logic _thread_0_event_syncstate_9_q, _thread_0_event_syncstate_9_n;
  logic _thread_0_event_syncstate_8_q, _thread_0_event_syncstate_8_n;
  logic _thread_0_event_counter_5_1_q, _thread_0_event_counter_5_1_n;
  logic _thread_0_event_counter_4_1_q, _thread_0_event_counter_4_1_n;
  logic _thread_0_event_syncstate_2_q, _thread_0_event_syncstate_2_n;
  logic _thread_0_event_syncstate_1_q, _thread_0_event_syncstate_1_n;
  assign EVENTS0[76].event_current = _thread_0_event_counter_76_1_q;
  assign _thread_0_event_counter_76_1_n = EVENTS0[75].event_current;
  assign EVENTS0[75].event_current = EVENTS0[74].event_current || EVENTS0[69].event_current || EVENTS0[63].event_current || EVENTS0[57].event_current || EVENTS0[52].event_current || EVENTS0[46].event_current || EVENTS0[39].event_current || EVENTS0[34].event_current || EVENTS0[28].event_current || EVENTS0[22].event_current || EVENTS0[17].event_current || EVENTS0[11].event_current;
  assign EVENTS0[74].event_current = (EVENTS0[73].event_current || _thread_0_event_syncstate_74_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_74_n = (EVENTS0[73].event_current || _thread_0_event_syncstate_74_q) && !_ep_in_res_ack;
  assign EVENTS0[73].event_current = (EVENTS0[72].event_current || _thread_0_event_syncstate_73_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_73_n = (EVENTS0[72].event_current || _thread_0_event_syncstate_73_q) && !_ep_wb_res_ack;
  assign EVENTS0[72].event_current = (EVENTS0[71].event_current || _thread_0_event_syncstate_72_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_72_n = (EVENTS0[71].event_current || _thread_0_event_syncstate_72_q) && !_ep_out_res_valid;
  assign EVENTS0[71].event_current = (EVENTS0[70].event_current || _thread_0_event_syncstate_71_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_71_n = (EVENTS0[70].event_current || _thread_0_event_syncstate_71_q) && !_ep_out_req_ack;
  assign EVENTS0[70].event_current = EVENTS0[64].event_current && thread_0_wire$361;
  assign EVENTS0[69].event_current = (EVENTS0[68].event_current || _thread_0_event_syncstate_69_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_69_n = (EVENTS0[68].event_current || _thread_0_event_syncstate_69_q) && !_ep_in_res_ack;
  assign EVENTS0[68].event_current = (EVENTS0[67].event_current || _thread_0_event_syncstate_68_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_68_n = (EVENTS0[67].event_current || _thread_0_event_syncstate_68_q) && !_ep_wb_res_ack;
  assign EVENTS0[67].event_current = (EVENTS0[66].event_current || _thread_0_event_syncstate_67_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_67_n = (EVENTS0[66].event_current || _thread_0_event_syncstate_67_q) && !_ep_out_res_valid;
  assign EVENTS0[66].event_current = (EVENTS0[65].event_current || _thread_0_event_syncstate_66_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_66_n = (EVENTS0[65].event_current || _thread_0_event_syncstate_66_q) && !_ep_out_req_ack;
  assign EVENTS0[65].event_current = EVENTS0[64].event_current && !thread_0_wire$361;
  assign EVENTS0[64].event_current = EVENTS0[58].event_current && !thread_0_wire$331;
  assign EVENTS0[63].event_current = (EVENTS0[62].event_current || _thread_0_event_syncstate_63_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_63_n = (EVENTS0[62].event_current || _thread_0_event_syncstate_63_q) && !_ep_in_res_ack;
  assign EVENTS0[62].event_current = (EVENTS0[61].event_current || _thread_0_event_syncstate_62_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_62_n = (EVENTS0[61].event_current || _thread_0_event_syncstate_62_q) && !_ep_wb_res_ack;
  assign EVENTS0[61].event_current = (EVENTS0[60].event_current || _thread_0_event_syncstate_61_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_61_n = (EVENTS0[60].event_current || _thread_0_event_syncstate_61_q) && !_ep_out_res_valid;
  assign EVENTS0[60].event_current = (EVENTS0[59].event_current || _thread_0_event_syncstate_60_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_60_n = (EVENTS0[59].event_current || _thread_0_event_syncstate_60_q) && !_ep_out_req_ack;
  assign EVENTS0[59].event_current = EVENTS0[58].event_current && thread_0_wire$331;
  assign EVENTS0[58].event_current = EVENTS0[40].event_current && !thread_0_wire$235;
  assign EVENTS0[57].event_current = (EVENTS0[56].event_current || _thread_0_event_syncstate_57_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_57_n = (EVENTS0[56].event_current || _thread_0_event_syncstate_57_q) && !_ep_in_res_ack;
  assign EVENTS0[56].event_current = (EVENTS0[55].event_current || _thread_0_event_syncstate_56_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_56_n = (EVENTS0[55].event_current || _thread_0_event_syncstate_56_q) && !_ep_wb_res_ack;
  assign EVENTS0[55].event_current = (EVENTS0[54].event_current || _thread_0_event_syncstate_55_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_55_n = (EVENTS0[54].event_current || _thread_0_event_syncstate_55_q) && !_ep_out_res_valid;
  assign EVENTS0[54].event_current = (EVENTS0[53].event_current || _thread_0_event_syncstate_54_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_54_n = (EVENTS0[53].event_current || _thread_0_event_syncstate_54_q) && !_ep_out_req_ack;
  assign EVENTS0[53].event_current = EVENTS0[47].event_current && thread_0_wire$271;
  assign EVENTS0[52].event_current = (EVENTS0[51].event_current || _thread_0_event_syncstate_52_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_52_n = (EVENTS0[51].event_current || _thread_0_event_syncstate_52_q) && !_ep_in_res_ack;
  assign EVENTS0[51].event_current = (EVENTS0[50].event_current || _thread_0_event_syncstate_51_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_51_n = (EVENTS0[50].event_current || _thread_0_event_syncstate_51_q) && !_ep_wb_res_ack;
  assign EVENTS0[50].event_current = (EVENTS0[49].event_current || _thread_0_event_syncstate_50_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_50_n = (EVENTS0[49].event_current || _thread_0_event_syncstate_50_q) && !_ep_out_res_valid;
  assign EVENTS0[49].event_current = (EVENTS0[48].event_current || _thread_0_event_syncstate_49_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_49_n = (EVENTS0[48].event_current || _thread_0_event_syncstate_49_q) && !_ep_out_req_ack;
  assign EVENTS0[48].event_current = EVENTS0[47].event_current && !thread_0_wire$271;
  assign EVENTS0[47].event_current = EVENTS0[41].event_current && !thread_0_wire$241;
  assign EVENTS0[46].event_current = (EVENTS0[45].event_current || _thread_0_event_syncstate_46_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_46_n = (EVENTS0[45].event_current || _thread_0_event_syncstate_46_q) && !_ep_in_res_ack;
  assign EVENTS0[45].event_current = (EVENTS0[44].event_current || _thread_0_event_syncstate_45_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_45_n = (EVENTS0[44].event_current || _thread_0_event_syncstate_45_q) && !_ep_wb_res_ack;
  assign EVENTS0[44].event_current = (EVENTS0[43].event_current || _thread_0_event_syncstate_44_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_44_n = (EVENTS0[43].event_current || _thread_0_event_syncstate_44_q) && !_ep_out_res_valid;
  assign EVENTS0[43].event_current = (EVENTS0[42].event_current || _thread_0_event_syncstate_43_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_43_n = (EVENTS0[42].event_current || _thread_0_event_syncstate_43_q) && !_ep_out_req_ack;
  assign EVENTS0[42].event_current = EVENTS0[41].event_current && thread_0_wire$241;
  assign EVENTS0[41].event_current = EVENTS0[40].event_current && thread_0_wire$235;
  assign EVENTS0[40].event_current = EVENTS0[2].event_current && !thread_0_wire$10;
  assign EVENTS0[39].event_current = (EVENTS0[38].event_current || _thread_0_event_syncstate_39_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_39_n = (EVENTS0[38].event_current || _thread_0_event_syncstate_39_q) && !_ep_in_res_ack;
  assign EVENTS0[38].event_current = (EVENTS0[37].event_current || _thread_0_event_syncstate_38_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_38_n = (EVENTS0[37].event_current || _thread_0_event_syncstate_38_q) && !_ep_wb_res_ack;
  assign EVENTS0[37].event_current = (EVENTS0[36].event_current || _thread_0_event_syncstate_37_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_37_n = (EVENTS0[36].event_current || _thread_0_event_syncstate_37_q) && !_ep_out_res_valid;
  assign EVENTS0[36].event_current = (EVENTS0[35].event_current || _thread_0_event_syncstate_36_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_36_n = (EVENTS0[35].event_current || _thread_0_event_syncstate_36_q) && !_ep_out_req_ack;
  assign EVENTS0[35].event_current = EVENTS0[29].event_current && thread_0_wire$163;
  assign EVENTS0[34].event_current = (EVENTS0[33].event_current || _thread_0_event_syncstate_34_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_34_n = (EVENTS0[33].event_current || _thread_0_event_syncstate_34_q) && !_ep_in_res_ack;
  assign EVENTS0[33].event_current = (EVENTS0[32].event_current || _thread_0_event_syncstate_33_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_33_n = (EVENTS0[32].event_current || _thread_0_event_syncstate_33_q) && !_ep_wb_res_ack;
  assign EVENTS0[32].event_current = (EVENTS0[31].event_current || _thread_0_event_syncstate_32_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_32_n = (EVENTS0[31].event_current || _thread_0_event_syncstate_32_q) && !_ep_out_res_valid;
  assign EVENTS0[31].event_current = (EVENTS0[30].event_current || _thread_0_event_syncstate_31_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_31_n = (EVENTS0[30].event_current || _thread_0_event_syncstate_31_q) && !_ep_out_req_ack;
  assign EVENTS0[30].event_current = EVENTS0[29].event_current && !thread_0_wire$163;
  assign EVENTS0[29].event_current = EVENTS0[23].event_current && !thread_0_wire$133;
  assign EVENTS0[28].event_current = (EVENTS0[27].event_current || _thread_0_event_syncstate_28_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_28_n = (EVENTS0[27].event_current || _thread_0_event_syncstate_28_q) && !_ep_in_res_ack;
  assign EVENTS0[27].event_current = (EVENTS0[26].event_current || _thread_0_event_syncstate_27_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_27_n = (EVENTS0[26].event_current || _thread_0_event_syncstate_27_q) && !_ep_wb_res_ack;
  assign EVENTS0[26].event_current = (EVENTS0[25].event_current || _thread_0_event_syncstate_26_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_26_n = (EVENTS0[25].event_current || _thread_0_event_syncstate_26_q) && !_ep_out_res_valid;
  assign EVENTS0[25].event_current = (EVENTS0[24].event_current || _thread_0_event_syncstate_25_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_25_n = (EVENTS0[24].event_current || _thread_0_event_syncstate_25_q) && !_ep_out_req_ack;
  assign EVENTS0[24].event_current = EVENTS0[23].event_current && thread_0_wire$133;
  assign EVENTS0[23].event_current = EVENTS0[5].event_current && !thread_0_wire$37;
  assign EVENTS0[22].event_current = (EVENTS0[21].event_current || _thread_0_event_syncstate_22_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_22_n = (EVENTS0[21].event_current || _thread_0_event_syncstate_22_q) && !_ep_in_res_ack;
  assign EVENTS0[21].event_current = (EVENTS0[20].event_current || _thread_0_event_syncstate_21_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_21_n = (EVENTS0[20].event_current || _thread_0_event_syncstate_21_q) && !_ep_wb_res_ack;
  assign EVENTS0[20].event_current = (EVENTS0[19].event_current || _thread_0_event_syncstate_20_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_20_n = (EVENTS0[19].event_current || _thread_0_event_syncstate_20_q) && !_ep_out_res_valid;
  assign EVENTS0[19].event_current = (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_19_n = (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q) && !_ep_out_req_ack;
  assign EVENTS0[18].event_current = EVENTS0[12].event_current && thread_0_wire$73;
  assign EVENTS0[17].event_current = (EVENTS0[16].event_current || _thread_0_event_syncstate_17_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_17_n = (EVENTS0[16].event_current || _thread_0_event_syncstate_17_q) && !_ep_in_res_ack;
  assign EVENTS0[16].event_current = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_16_n = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && !_ep_wb_res_ack;
  assign EVENTS0[15].event_current = (EVENTS0[14].event_current || _thread_0_event_syncstate_15_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_15_n = (EVENTS0[14].event_current || _thread_0_event_syncstate_15_q) && !_ep_out_res_valid;
  assign EVENTS0[14].event_current = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_14_n = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) && !_ep_out_req_ack;
  assign EVENTS0[13].event_current = EVENTS0[12].event_current && !thread_0_wire$73;
  assign EVENTS0[12].event_current = EVENTS0[6].event_current && !thread_0_wire$43;
  assign EVENTS0[11].event_current = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) && _ep_in_res_ack;
    assign _thread_0_event_syncstate_11_n = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) && !_ep_in_res_ack;
  assign EVENTS0[10].event_current = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q) && _ep_wb_res_ack;
    assign _thread_0_event_syncstate_10_n = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q) && !_ep_wb_res_ack;
  assign EVENTS0[9].event_current = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_9_n = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) && !_ep_out_res_valid;
  assign EVENTS0[8].event_current = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_8_n = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) && !_ep_out_req_ack;
  assign EVENTS0[7].event_current = EVENTS0[6].event_current && thread_0_wire$43;
  assign EVENTS0[6].event_current = EVENTS0[5].event_current && thread_0_wire$37;
  assign EVENTS0[5].event_current = _thread_0_event_counter_5_1_q;
  assign _thread_0_event_counter_5_1_n = EVENTS0[4].event_current;
  assign EVENTS0[4].event_current = _thread_0_event_counter_4_1_q;
  assign _thread_0_event_counter_4_1_n = EVENTS0[3].event_current;
  assign EVENTS0[3].event_current = EVENTS0[2].event_current && thread_0_wire$10;
  assign EVENTS0[2].event_current = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && _ep_in_req_valid;
    assign _thread_0_event_syncstate_2_n = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q) && !_ep_in_req_valid;
  assign EVENTS0[1].event_current = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && _ep_wb_req_valid;
    assign _thread_0_event_syncstate_1_n = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q) && !_ep_wb_req_valid;
  assign EVENTS0[0].event_current = _init_0 || EVENTS0[76].event_current;
  assign _ep_in_req_ack = (EVENTS0[1].event_current || _thread_0_event_syncstate_2_q);
  assign _ep_wb_req_ack = (EVENTS0[0].event_current || _thread_0_event_syncstate_1_q);
  assign _ep_out_res_ack = (EVENTS0[8].event_current || _thread_0_event_syncstate_9_q) || (EVENTS0[14].event_current || _thread_0_event_syncstate_15_q) || (EVENTS0[19].event_current || _thread_0_event_syncstate_20_q) || (EVENTS0[25].event_current || _thread_0_event_syncstate_26_q) || (EVENTS0[31].event_current || _thread_0_event_syncstate_32_q) || (EVENTS0[36].event_current || _thread_0_event_syncstate_37_q) || (EVENTS0[43].event_current || _thread_0_event_syncstate_44_q) || (EVENTS0[49].event_current || _thread_0_event_syncstate_50_q) || (EVENTS0[54].event_current || _thread_0_event_syncstate_55_q) || (EVENTS0[60].event_current || _thread_0_event_syncstate_61_q) || (EVENTS0[66].event_current || _thread_0_event_syncstate_67_q) || (EVENTS0[71].event_current || _thread_0_event_syncstate_72_q);
  assign _ep_in_res_valid = (EVENTS0[10].event_current || _thread_0_event_syncstate_11_q) || (EVENTS0[16].event_current || _thread_0_event_syncstate_17_q) || (EVENTS0[21].event_current || _thread_0_event_syncstate_22_q) || (EVENTS0[27].event_current || _thread_0_event_syncstate_28_q) || (EVENTS0[33].event_current || _thread_0_event_syncstate_34_q) || (EVENTS0[38].event_current || _thread_0_event_syncstate_39_q) || (EVENTS0[45].event_current || _thread_0_event_syncstate_46_q) || (EVENTS0[51].event_current || _thread_0_event_syncstate_52_q) || (EVENTS0[56].event_current || _thread_0_event_syncstate_57_q) || (EVENTS0[62].event_current || _thread_0_event_syncstate_63_q) || (EVENTS0[68].event_current || _thread_0_event_syncstate_69_q) || (EVENTS0[73].event_current || _thread_0_event_syncstate_74_q);
  assign _ep_out_req_valid = (EVENTS0[7].event_current || _thread_0_event_syncstate_8_q) || (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) || (EVENTS0[18].event_current || _thread_0_event_syncstate_19_q) || (EVENTS0[24].event_current || _thread_0_event_syncstate_25_q) || (EVENTS0[30].event_current || _thread_0_event_syncstate_31_q) || (EVENTS0[35].event_current || _thread_0_event_syncstate_36_q) || (EVENTS0[42].event_current || _thread_0_event_syncstate_43_q) || (EVENTS0[48].event_current || _thread_0_event_syncstate_49_q) || (EVENTS0[53].event_current || _thread_0_event_syncstate_54_q) || (EVENTS0[59].event_current || _thread_0_event_syncstate_60_q) || (EVENTS0[65].event_current || _thread_0_event_syncstate_66_q) || (EVENTS0[70].event_current || _thread_0_event_syncstate_71_q);
  assign _ep_wb_res_valid = (EVENTS0[9].event_current || _thread_0_event_syncstate_10_q) || (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) || (EVENTS0[20].event_current || _thread_0_event_syncstate_21_q) || (EVENTS0[26].event_current || _thread_0_event_syncstate_27_q) || (EVENTS0[32].event_current || _thread_0_event_syncstate_33_q) || (EVENTS0[37].event_current || _thread_0_event_syncstate_38_q) || (EVENTS0[44].event_current || _thread_0_event_syncstate_45_q) || (EVENTS0[50].event_current || _thread_0_event_syncstate_51_q) || (EVENTS0[55].event_current || _thread_0_event_syncstate_56_q) || (EVENTS0[61].event_current || _thread_0_event_syncstate_62_q) || (EVENTS0[67].event_current || _thread_0_event_syncstate_68_q) || (EVENTS0[72].event_current || _thread_0_event_syncstate_73_q);
  logic[3:0] _ep_wb_res_valid_selector_q, _ep_wb_res_valid_selector_n;
  assign _ep_wb_res_0 = (_ep_wb_res_valid_selector_n == 4'd0) ? thread_0_wire$70 : (_ep_wb_res_valid_selector_n == 4'd1) ? thread_0_wire$126 : (_ep_wb_res_valid_selector_n == 4'd2) ? thread_0_wire$100 : (_ep_wb_res_valid_selector_n == 4'd3) ? thread_0_wire$160 : (_ep_wb_res_valid_selector_n == 4'd4) ? thread_0_wire$216 : (_ep_wb_res_valid_selector_n == 4'd5) ? thread_0_wire$190 : (_ep_wb_res_valid_selector_n == 4'd6) ? thread_0_wire$268 : (_ep_wb_res_valid_selector_n == 4'd7) ? thread_0_wire$324 : (_ep_wb_res_valid_selector_n == 4'd8) ? thread_0_wire$298 : (_ep_wb_res_valid_selector_n == 4'd9) ? thread_0_wire$358 : (_ep_wb_res_valid_selector_n == 4'd10) ? thread_0_wire$414 : (_ep_wb_res_valid_selector_n == 4'd11) ? thread_0_wire$388 : '0;
  logic[3:0] _ep_out_req_valid_selector_q, _ep_out_req_valid_selector_n;
  assign _ep_out_req_0 = (_ep_out_req_valid_selector_n == 4'd0) ? thread_0_wire$68 : (_ep_out_req_valid_selector_n == 4'd1) ? thread_0_wire$124 : (_ep_out_req_valid_selector_n == 4'd2) ? thread_0_wire$98 : (_ep_out_req_valid_selector_n == 4'd3) ? thread_0_wire$158 : (_ep_out_req_valid_selector_n == 4'd4) ? thread_0_wire$214 : (_ep_out_req_valid_selector_n == 4'd5) ? thread_0_wire$188 : (_ep_out_req_valid_selector_n == 4'd6) ? thread_0_wire$266 : (_ep_out_req_valid_selector_n == 4'd7) ? thread_0_wire$322 : (_ep_out_req_valid_selector_n == 4'd8) ? thread_0_wire$296 : (_ep_out_req_valid_selector_n == 4'd9) ? thread_0_wire$356 : (_ep_out_req_valid_selector_n == 4'd10) ? thread_0_wire$412 : (_ep_out_req_valid_selector_n == 4'd11) ? thread_0_wire$386 : '0;
  logic[3:0] _ep_in_res_valid_selector_q, _ep_in_res_valid_selector_n;
  assign _ep_in_res_0 = (_ep_in_res_valid_selector_n == 4'd0) ? thread_0_wire$71 : (_ep_in_res_valid_selector_n == 4'd1) ? thread_0_wire$127 : (_ep_in_res_valid_selector_n == 4'd2) ? thread_0_wire$101 : (_ep_in_res_valid_selector_n == 4'd3) ? thread_0_wire$161 : (_ep_in_res_valid_selector_n == 4'd4) ? thread_0_wire$217 : (_ep_in_res_valid_selector_n == 4'd5) ? thread_0_wire$191 : (_ep_in_res_valid_selector_n == 4'd6) ? thread_0_wire$269 : (_ep_in_res_valid_selector_n == 4'd7) ? thread_0_wire$325 : (_ep_in_res_valid_selector_n == 4'd8) ? thread_0_wire$299 : (_ep_in_res_valid_selector_n == 4'd9) ? thread_0_wire$359 : (_ep_in_res_valid_selector_n == 4'd10) ? thread_0_wire$415 : (_ep_in_res_valid_selector_n == 4'd11) ? thread_0_wire$389 : '0;
  always_comb begin: _thread_0_selector
    _ep_wb_res_valid_selector_n = _ep_wb_res_valid_selector_q;
    if ((EVENTS0[9].event_current || _thread_0_event_syncstate_10_q)) _ep_wb_res_valid_selector_n = 4'd0;
    if ((EVENTS0[15].event_current || _thread_0_event_syncstate_16_q)) _ep_wb_res_valid_selector_n = 4'd1;
    if ((EVENTS0[20].event_current || _thread_0_event_syncstate_21_q)) _ep_wb_res_valid_selector_n = 4'd2;
    if ((EVENTS0[26].event_current || _thread_0_event_syncstate_27_q)) _ep_wb_res_valid_selector_n = 4'd3;
    if ((EVENTS0[32].event_current || _thread_0_event_syncstate_33_q)) _ep_wb_res_valid_selector_n = 4'd4;
    if ((EVENTS0[37].event_current || _thread_0_event_syncstate_38_q)) _ep_wb_res_valid_selector_n = 4'd5;
    if ((EVENTS0[44].event_current || _thread_0_event_syncstate_45_q)) _ep_wb_res_valid_selector_n = 4'd6;
    if ((EVENTS0[50].event_current || _thread_0_event_syncstate_51_q)) _ep_wb_res_valid_selector_n = 4'd7;
    if ((EVENTS0[55].event_current || _thread_0_event_syncstate_56_q)) _ep_wb_res_valid_selector_n = 4'd8;
    if ((EVENTS0[61].event_current || _thread_0_event_syncstate_62_q)) _ep_wb_res_valid_selector_n = 4'd9;
    if ((EVENTS0[67].event_current || _thread_0_event_syncstate_68_q)) _ep_wb_res_valid_selector_n = 4'd10;
    if ((EVENTS0[72].event_current || _thread_0_event_syncstate_73_q)) _ep_wb_res_valid_selector_n = 4'd11;
    _ep_out_req_valid_selector_n = _ep_out_req_valid_selector_q;
    if ((EVENTS0[7].event_current || _thread_0_event_syncstate_8_q)) _ep_out_req_valid_selector_n = 4'd0;
    if ((EVENTS0[13].event_current || _thread_0_event_syncstate_14_q)) _ep_out_req_valid_selector_n = 4'd1;
    if ((EVENTS0[18].event_current || _thread_0_event_syncstate_19_q)) _ep_out_req_valid_selector_n = 4'd2;
    if ((EVENTS0[24].event_current || _thread_0_event_syncstate_25_q)) _ep_out_req_valid_selector_n = 4'd3;
    if ((EVENTS0[30].event_current || _thread_0_event_syncstate_31_q)) _ep_out_req_valid_selector_n = 4'd4;
    if ((EVENTS0[35].event_current || _thread_0_event_syncstate_36_q)) _ep_out_req_valid_selector_n = 4'd5;
    if ((EVENTS0[42].event_current || _thread_0_event_syncstate_43_q)) _ep_out_req_valid_selector_n = 4'd6;
    if ((EVENTS0[48].event_current || _thread_0_event_syncstate_49_q)) _ep_out_req_valid_selector_n = 4'd7;
    if ((EVENTS0[53].event_current || _thread_0_event_syncstate_54_q)) _ep_out_req_valid_selector_n = 4'd8;
    if ((EVENTS0[59].event_current || _thread_0_event_syncstate_60_q)) _ep_out_req_valid_selector_n = 4'd9;
    if ((EVENTS0[65].event_current || _thread_0_event_syncstate_66_q)) _ep_out_req_valid_selector_n = 4'd10;
    if ((EVENTS0[70].event_current || _thread_0_event_syncstate_71_q)) _ep_out_req_valid_selector_n = 4'd11;
    _ep_in_res_valid_selector_n = _ep_in_res_valid_selector_q;
    if ((EVENTS0[10].event_current || _thread_0_event_syncstate_11_q)) _ep_in_res_valid_selector_n = 4'd0;
    if ((EVENTS0[16].event_current || _thread_0_event_syncstate_17_q)) _ep_in_res_valid_selector_n = 4'd1;
    if ((EVENTS0[21].event_current || _thread_0_event_syncstate_22_q)) _ep_in_res_valid_selector_n = 4'd2;
    if ((EVENTS0[27].event_current || _thread_0_event_syncstate_28_q)) _ep_in_res_valid_selector_n = 4'd3;
    if ((EVENTS0[33].event_current || _thread_0_event_syncstate_34_q)) _ep_in_res_valid_selector_n = 4'd4;
    if ((EVENTS0[38].event_current || _thread_0_event_syncstate_39_q)) _ep_in_res_valid_selector_n = 4'd5;
    if ((EVENTS0[45].event_current || _thread_0_event_syncstate_46_q)) _ep_in_res_valid_selector_n = 4'd6;
    if ((EVENTS0[51].event_current || _thread_0_event_syncstate_52_q)) _ep_in_res_valid_selector_n = 4'd7;
    if ((EVENTS0[56].event_current || _thread_0_event_syncstate_57_q)) _ep_in_res_valid_selector_n = 4'd8;
    if ((EVENTS0[62].event_current || _thread_0_event_syncstate_63_q)) _ep_in_res_valid_selector_n = 4'd9;
    if ((EVENTS0[68].event_current || _thread_0_event_syncstate_69_q)) _ep_in_res_valid_selector_n = 4'd10;
    if ((EVENTS0[73].event_current || _thread_0_event_syncstate_74_q)) _ep_in_res_valid_selector_n = 4'd11;
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_selector_trans
    if (~rst_ni) begin
      _ep_wb_res_valid_selector_q <= '0;
      _ep_out_req_valid_selector_q <= '0;
      _ep_in_res_valid_selector_q <= '0;
    end else begin
      _ep_wb_res_valid_selector_q <= _ep_wb_res_valid_selector_n;
      _ep_out_req_valid_selector_q <= _ep_out_req_valid_selector_n;
      _ep_in_res_valid_selector_q <= _ep_in_res_valid_selector_n;
    end
  end
  always_ff @(posedge clk_i or negedge rst_ni) begin : _thread_0_st_transition
    if (~rst_ni) begin
      _init_0 <= 1'b1;
      regs_q <= '0;
      _thread_0_event_counter_76_1_q <= '0;
      _thread_0_event_syncstate_74_q <= '0;
      _thread_0_event_syncstate_73_q <= '0;
      _thread_0_event_syncstate_72_q <= '0;
      _thread_0_event_syncstate_71_q <= '0;
      _thread_0_event_syncstate_69_q <= '0;
      _thread_0_event_syncstate_68_q <= '0;
      _thread_0_event_syncstate_67_q <= '0;
      _thread_0_event_syncstate_66_q <= '0;
      _thread_0_event_syncstate_63_q <= '0;
      _thread_0_event_syncstate_62_q <= '0;
      _thread_0_event_syncstate_61_q <= '0;
      _thread_0_event_syncstate_60_q <= '0;
      _thread_0_event_syncstate_57_q <= '0;
      _thread_0_event_syncstate_56_q <= '0;
      _thread_0_event_syncstate_55_q <= '0;
      _thread_0_event_syncstate_54_q <= '0;
      _thread_0_event_syncstate_52_q <= '0;
      _thread_0_event_syncstate_51_q <= '0;
      _thread_0_event_syncstate_50_q <= '0;
      _thread_0_event_syncstate_49_q <= '0;
      _thread_0_event_syncstate_46_q <= '0;
      _thread_0_event_syncstate_45_q <= '0;
      _thread_0_event_syncstate_44_q <= '0;
      _thread_0_event_syncstate_43_q <= '0;
      _thread_0_event_syncstate_39_q <= '0;
      _thread_0_event_syncstate_38_q <= '0;
      _thread_0_event_syncstate_37_q <= '0;
      _thread_0_event_syncstate_36_q <= '0;
      _thread_0_event_syncstate_34_q <= '0;
      _thread_0_event_syncstate_33_q <= '0;
      _thread_0_event_syncstate_32_q <= '0;
      _thread_0_event_syncstate_31_q <= '0;
      _thread_0_event_syncstate_28_q <= '0;
      _thread_0_event_syncstate_27_q <= '0;
      _thread_0_event_syncstate_26_q <= '0;
      _thread_0_event_syncstate_25_q <= '0;
      _thread_0_event_syncstate_22_q <= '0;
      _thread_0_event_syncstate_21_q <= '0;
      _thread_0_event_syncstate_20_q <= '0;
      _thread_0_event_syncstate_19_q <= '0;
      _thread_0_event_syncstate_17_q <= '0;
      _thread_0_event_syncstate_16_q <= '0;
      _thread_0_event_syncstate_15_q <= '0;
      _thread_0_event_syncstate_14_q <= '0;
      _thread_0_event_syncstate_11_q <= '0;
      _thread_0_event_syncstate_10_q <= '0;
      _thread_0_event_syncstate_9_q <= '0;
      _thread_0_event_syncstate_8_q <= '0;
      _thread_0_event_counter_5_1_q <= '0;
      _thread_0_event_counter_4_1_q <= '0;
      _thread_0_event_syncstate_2_q <= '0;
      _thread_0_event_syncstate_1_q <= '0;
    end else begin
      if (EVENTS0[4].event_current) begin
        regs_q[0 +: 32] <= thread_0_wire$19;
      end
      if (EVENTS0[3].event_current) begin
        regs_q[thread_0_wire$18 +: 32] <= thread_0_wire$4;
      end
      _init_0 <= 1'b0;
      _thread_0_event_counter_76_1_q <= _thread_0_event_counter_76_1_n;
      _thread_0_event_syncstate_74_q <= _thread_0_event_syncstate_74_n;
      _thread_0_event_syncstate_73_q <= _thread_0_event_syncstate_73_n;
      _thread_0_event_syncstate_72_q <= _thread_0_event_syncstate_72_n;
      _thread_0_event_syncstate_71_q <= _thread_0_event_syncstate_71_n;
      _thread_0_event_syncstate_69_q <= _thread_0_event_syncstate_69_n;
      _thread_0_event_syncstate_68_q <= _thread_0_event_syncstate_68_n;
      _thread_0_event_syncstate_67_q <= _thread_0_event_syncstate_67_n;
      _thread_0_event_syncstate_66_q <= _thread_0_event_syncstate_66_n;
      _thread_0_event_syncstate_63_q <= _thread_0_event_syncstate_63_n;
      _thread_0_event_syncstate_62_q <= _thread_0_event_syncstate_62_n;
      _thread_0_event_syncstate_61_q <= _thread_0_event_syncstate_61_n;
      _thread_0_event_syncstate_60_q <= _thread_0_event_syncstate_60_n;
      _thread_0_event_syncstate_57_q <= _thread_0_event_syncstate_57_n;
      _thread_0_event_syncstate_56_q <= _thread_0_event_syncstate_56_n;
      _thread_0_event_syncstate_55_q <= _thread_0_event_syncstate_55_n;
      _thread_0_event_syncstate_54_q <= _thread_0_event_syncstate_54_n;
      _thread_0_event_syncstate_52_q <= _thread_0_event_syncstate_52_n;
      _thread_0_event_syncstate_51_q <= _thread_0_event_syncstate_51_n;
      _thread_0_event_syncstate_50_q <= _thread_0_event_syncstate_50_n;
      _thread_0_event_syncstate_49_q <= _thread_0_event_syncstate_49_n;
      _thread_0_event_syncstate_46_q <= _thread_0_event_syncstate_46_n;
      _thread_0_event_syncstate_45_q <= _thread_0_event_syncstate_45_n;
      _thread_0_event_syncstate_44_q <= _thread_0_event_syncstate_44_n;
      _thread_0_event_syncstate_43_q <= _thread_0_event_syncstate_43_n;
      _thread_0_event_syncstate_39_q <= _thread_0_event_syncstate_39_n;
      _thread_0_event_syncstate_38_q <= _thread_0_event_syncstate_38_n;
      _thread_0_event_syncstate_37_q <= _thread_0_event_syncstate_37_n;
      _thread_0_event_syncstate_36_q <= _thread_0_event_syncstate_36_n;
      _thread_0_event_syncstate_34_q <= _thread_0_event_syncstate_34_n;
      _thread_0_event_syncstate_33_q <= _thread_0_event_syncstate_33_n;
      _thread_0_event_syncstate_32_q <= _thread_0_event_syncstate_32_n;
      _thread_0_event_syncstate_31_q <= _thread_0_event_syncstate_31_n;
      _thread_0_event_syncstate_28_q <= _thread_0_event_syncstate_28_n;
      _thread_0_event_syncstate_27_q <= _thread_0_event_syncstate_27_n;
      _thread_0_event_syncstate_26_q <= _thread_0_event_syncstate_26_n;
      _thread_0_event_syncstate_25_q <= _thread_0_event_syncstate_25_n;
      _thread_0_event_syncstate_22_q <= _thread_0_event_syncstate_22_n;
      _thread_0_event_syncstate_21_q <= _thread_0_event_syncstate_21_n;
      _thread_0_event_syncstate_20_q <= _thread_0_event_syncstate_20_n;
      _thread_0_event_syncstate_19_q <= _thread_0_event_syncstate_19_n;
      _thread_0_event_syncstate_17_q <= _thread_0_event_syncstate_17_n;
      _thread_0_event_syncstate_16_q <= _thread_0_event_syncstate_16_n;
      _thread_0_event_syncstate_15_q <= _thread_0_event_syncstate_15_n;
      _thread_0_event_syncstate_14_q <= _thread_0_event_syncstate_14_n;
      _thread_0_event_syncstate_11_q <= _thread_0_event_syncstate_11_n;
      _thread_0_event_syncstate_10_q <= _thread_0_event_syncstate_10_n;
      _thread_0_event_syncstate_9_q <= _thread_0_event_syncstate_9_n;
      _thread_0_event_syncstate_8_q <= _thread_0_event_syncstate_8_n;
      _thread_0_event_counter_5_1_q <= _thread_0_event_counter_5_1_n;
      _thread_0_event_counter_4_1_q <= _thread_0_event_counter_4_1_n;
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
  logic[31:0] thread_0_wire$31;
  logic[13:0] thread_0_wire$30;
  logic[13:0] thread_0_wire$28;
  logic[12:0] thread_0_wire$26;
  logic[12:0] thread_0_wire$24;
  logic[8191:0] thread_0_wire$22;
  logic[7:0] thread_0_wire$21;
  logic[0:0] thread_0_wire$19;
  logic[63:0] thread_0_wire$18;
  logic[0:0] thread_0_wire$16;
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
  localparam logic[0:0] thread_0_wire$15 = 1'b1;
  assign thread_0_wire$16 = thread_0_wire$12 == thread_0_wire$15;
  localparam logic[31:0] thread_0_wire$17 = 32'd0;
  assign thread_0_wire$18 = {thread_0_wire$14, thread_0_wire$17};
  assign thread_0_wire$19 = _ep_out_res_0;
  localparam logic[0:0] thread_0_wire$20 = 1'b1;
  assign thread_0_wire$21 = thread_0_wire$14[2 +: 8];
  assign thread_0_wire$22 = imem_q;
  localparam logic[4:0] thread_0_wire$23 = 5'd0;
  assign thread_0_wire$24 = {thread_0_wire$23, thread_0_wire$21};
  localparam logic[12:0] thread_0_wire$25 = 13'd32;
  assign thread_0_wire$26 = thread_0_wire$24 * thread_0_wire$25;
  localparam logic[0:0] thread_0_wire$27 = 1'd0;
  assign thread_0_wire$28 = {thread_0_wire$27, thread_0_wire$26};
  localparam logic[13:0] thread_0_wire$29 = 14'd0;
  assign thread_0_wire$30 = thread_0_wire$28 + thread_0_wire$29;
  assign thread_0_wire$31 = thread_0_wire$22[thread_0_wire$30 +: 32];
  assign thread_0_wire$32 = {thread_0_wire$14, thread_0_wire$31};
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
  assign EVENTS0[17].event_current = EVENTS0[11].event_current && thread_0_wire$16;
  assign EVENTS0[16].event_current = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && _ep_branch_res_ack;
    assign _thread_0_event_syncstate_16_n = (EVENTS0[15].event_current || _thread_0_event_syncstate_16_q) && !_ep_branch_res_ack;
  assign EVENTS0[15].event_current = _thread_0_event_counter_15_1_q;
  assign _thread_0_event_counter_15_1_n = EVENTS0[14].event_current;
  assign EVENTS0[14].event_current = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) && _ep_out_res_valid;
    assign _thread_0_event_syncstate_14_n = (EVENTS0[13].event_current || _thread_0_event_syncstate_14_q) && !_ep_out_res_valid;
  assign EVENTS0[13].event_current = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) && _ep_out_req_ack;
    assign _thread_0_event_syncstate_13_n = (EVENTS0[12].event_current || _thread_0_event_syncstate_13_q) && !_ep_out_req_ack;
  assign EVENTS0[12].event_current = EVENTS0[11].event_current && !thread_0_wire$16;
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
  assign _ep_branch_res_0 = (_ep_branch_res_valid_selector_n == 1'd0) ? thread_0_wire$36 : (_ep_branch_res_valid_selector_n == 1'd1) ? thread_0_wire$20 : '0;
  logic[0:0] _ep_out_req_valid_selector_q, _ep_out_req_valid_selector_n;
  assign _ep_out_req_0 = (_ep_out_req_valid_selector_n == 1'd0) ? thread_0_wire$32 : (_ep_out_req_valid_selector_n == 1'd1) ? thread_0_wire$18 : '0;
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
