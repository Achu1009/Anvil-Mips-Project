`timescale 1ns/1ps
//=====================================================================
//  tb_equiv_sv.sv -- generic differential-testing testbench for the
//  SV baseline (mips_pipeline_processor.sv). Unmodified across all 8
//  programs: the program itself lives in the per-program copy of
//  instruction_fetch.sv this is compiled against.
//
//  Emits a fixed, parseable trace on stdout:
//    PCTRACE <cycle> <8-hex-digit pc>     -- once per cycle the PC changes
//    REG <idx 0-31> <decimal value>       -- final register file
//    DMEM <idx 0-15> <decimal value>      -- final data memory, word-indexed
//    DONE
//  equivalence/run_equivalence.py greps these lines out of both this
//  testbench's output and tb_equiv_anvil.sv's output and diffs them.
//=====================================================================
module tb_equiv_sv;

    localparam time CLK_HALF   = 5ns;
    localparam int  RUN_CYCLES = 60;

    logic        clk;
    logic        reset;
    logic [31:0] dummy_out;
    integer      c;
    logic [31:0] last_pc;

    mips_pipeline_processor #(
        .DMEM_LATENCY   (1),
        .DMEM_RANDOMISE (1'b0)
    ) dut (
        .clk       (clk),
        .reset     (reset),
        .dummy_out (dummy_out)
    );

    initial begin
        clk = 1'b0;
        forever #CLK_HALF clk = ~clk;
    end

    initial begin
        reset = 1'b1;
        #20ns;
        reset = 1'b0;

        last_pc = 32'hFFFFFFFF;
        for (c = 0; c < RUN_CYCLES; c = c + 1) begin
            @(posedge clk);
            #1;
            if (dut.u_if.pc !== last_pc) begin
                $display("PCTRACE %0d %08h", c, dut.u_if.pc);
                last_pc = dut.u_if.pc;
            end
        end

        for (int k = 0; k < 32; k = k + 1) begin
            $display("REG %0d %0d", k, dut.u_regfile.regs[k]);
        end
        for (int k = 0; k < 16; k = k + 1) begin
            $display("DMEM %0d %0d",
                k,
                {dut.u_dmem.mem[4*k], dut.u_dmem.mem[4*k+1],
                 dut.u_dmem.mem[4*k+2], dut.u_dmem.mem[4*k+3]});
        end
        $display("DONE");
        $finish;
    end

endmodule
