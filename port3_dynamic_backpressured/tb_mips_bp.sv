`timescale 1ns/1ps
module tb;
  logic clk_i=0, rst_ni=0; integer c; logic [31:0] lpc;
  integer advances; logic [31:0] prev_pc;
  MipsPipelineBP uut(.clk_i(clk_i), .rst_ni(rst_ni));
  always #5 clk_i = ~clk_i;

  // handles
  `define PC   uut._spawn_0.pc_q
  `define REGS uut._spawn_1.regs_q
  `define DMEM uut._spawn_5.mem_q

  initial begin
    rst_ni = 0; #22; rst_ni = 1; lpc = 32'hffffffff; advances = 0;
    for (c = 0; c < 120; c = c + 1) begin
      @(posedge clk_i); #1;
      if (`REGS[31:0] !== 0) $display("  [ZERO-VIOLATION] cyc=%0d r0=%0d", c, `REGS[31:0]);
      if (`PC !== lpc) begin
        lpc = `PC; advances = advances + 1;
        $display("cyc=%0d PC->%h r1=%0d r2=%0d r3=%0d r4=%0d",
                 c, lpc, `REGS[63:32], `REGS[95:64], `REGS[127:96], `REGS[159:128]);
      end
    end
    $display("FINAL r1=%0d r2=%0d r3=%0d r4=%0d r0=%0d dmem[word5]=%0d dmem[word0]=%0d",
             `REGS[63:32], `REGS[95:64], `REGS[127:96], `REGS[159:128], `REGS[31:0],
             `DMEM[5*32 +: 32], `DMEM[0 +: 32]);
    if (`REGS[63:32]==20 && `REGS[95:64]==0 && `REGS[127:96]==0 &&
        `REGS[159:128]==20 && `REGS[31:0]==0 && `DMEM[5*32 +: 32]==20)
      $display("RESULT: PASS"); else $display("RESULT: FAIL");
    $finish;
  end
endmodule
