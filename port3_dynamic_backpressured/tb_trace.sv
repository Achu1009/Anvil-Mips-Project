`timescale 1ns/1ps
module tb;
  logic clk_i=0, rst_ni=0; integer c, stalls; logic [31:0] lpc;
  MipsPipelineBP uut(.clk_i(clk_i), .rst_ni(rst_ni));
  always #5 clk_i = ~clk_i;
  `define PC   uut._spawn_0.pc_q
  `define REGS uut._spawn_1.regs_q
  `define DMEM uut._spawn_5.mem_q
  initial begin
    rst_ni = 0; #22; rst_ni = 1; lpc = 32'hffffffff; stalls = 0;
    for (c = 0; c < 24; c = c + 1) begin
      @(posedge clk_i); #1;
      if (`PC !== lpc) begin
        $display("cyc %0d: PC=%h   r1=%0d r2=%0d r3=%0d r4=%0d  dmem[w5]=%0d",
                 c, `PC, `REGS[63:32], `REGS[95:64], `REGS[127:96], `REGS[159:128], `DMEM[5*32 +: 32]);
        lpc = `PC;
      end else begin
        stalls = stalls + 1;
        $display("cyc %0d: --- pipeline frozen (PC held at %h)", c, `PC);
      end
    end
    $display("non-advancing cycles in first 24 = %0d", stalls);
    $finish;
  end
endmodule
