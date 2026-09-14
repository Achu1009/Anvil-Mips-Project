`timescale 1ns/1ps
// C1, as an SVA-derived procedural checker (runs anywhere, incl. Icarus).
//   a_C1_wb_fanout_identical: assert property (@(posedge clk_i) disable iff (!rst_ni)
//                             wb_id === wb_ex)
module tb;
  logic clk_i = 0, rst_ni = 0; integer c, c1_fires;
  MipsPipeline uut(.clk_i(clk_i), .rst_ni(rst_ni));
  always #5 clk_i = ~clk_i;
  `define REGS uut._spawn_1.regs_q
  `define DMEM uut._spawn_3.dmem_q
  `define WB_ID uut._wb_id_le_req_0
  `define WB_EX uut._wb_ex_le_req_0

  always @(posedge clk_i) if (rst_ni) begin
    if (`WB_ID !== `WB_EX) begin
      c1_fires = c1_fires + 1;
      if (c1_fires <= 3)
        $display("  C1 VIOLATION @cyc %0d: wb_id=%h  wb_ex=%h  (ID and EX disagree on the commit)",
                 c, `WB_ID, `WB_EX);
    end
  end

  initial begin
    c1_fires = 0; rst_ni = 0; #22; rst_ni = 1;
    for (c = 0; c < 40; c = c + 1) @(posedge clk_i);
    #1;
    $display("  end state: r1=%0d r2=%0d r3=%0d r4=%0d r0=%0d dmem[word5]=%0d",
             `REGS[63:32], `REGS[95:64], `REGS[127:96], `REGS[159:128], `REGS[31:0], `DMEM[5*32 +: 32]);
    $display("  C1 fired %0d times", c1_fires);
    if (`REGS[63:32]==20 && `REGS[95:64]==0 && `REGS[127:96]==0 &&
        `REGS[159:128]==20 && `REGS[31:0]==0 && `DMEM[5*32 +: 32]==20)
      $display("  scoreboard: PASS"); else $display("  scoreboard: FAIL");
    $finish;
  end
endmodule
