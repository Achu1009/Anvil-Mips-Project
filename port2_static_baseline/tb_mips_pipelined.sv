`timescale 1ns/1ps
module tb; logic clk_i=0,rst_ni=0; integer c; logic[31:0] lpc;
  MipsPipeline uut(.clk_i(clk_i),.rst_ni(rst_ni));
  always #5 clk_i=~clk_i;
  initial begin rst_ni=0;#22;rst_ni=1; lpc=32'hffffffff;
    for(c=0;c<40;c=c+1) begin @(posedge clk_i);#1;
      if (uut._spawn_1.regs_q[31:0]!==0) $display("  [ZERO-VIOLATION] cyc=%0d r0=%0d",c,uut._spawn_1.regs_q[31:0]);
      if (uut._spawn_0.pc_q!==lpc) begin lpc=uut._spawn_0.pc_q;
        $display("cyc=%0d PC->%h  r1=%0d r2=%0d r3=%0d r4=%0d r5=%0d",c,lpc,
          uut._spawn_1.regs_q[63:32],uut._spawn_1.regs_q[95:64],uut._spawn_1.regs_q[127:96],
          uut._spawn_1.regs_q[159:128],uut._spawn_1.regs_q[191:160]); end
    end
    $display("FINAL r1=%0d r2=%0d r3=%0d r4=%0d r5=%0d r0=%0d dmem5w=%0d",
      uut._spawn_1.regs_q[63:32],uut._spawn_1.regs_q[95:64],uut._spawn_1.regs_q[127:96],
      uut._spawn_1.regs_q[159:128],uut._spawn_1.regs_q[191:160],uut._spawn_1.regs_q[31:0],
      uut._spawn_3.dmem_q[191:160]);
    $finish; end
endmodule
