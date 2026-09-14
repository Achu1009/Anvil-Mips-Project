`timescale 1ns/1ps
//=====================================================================
//  tb_equiv_anvil.sv -- generic differential-testing testbench for the
//  Anvil port (anvil_code_pipelined, generated as MipsPipeline).
//  Unmodified across all 8 programs: the program lives in the
//  per-program copy of fetch.anv the design was compiled from.
//
//  Signal names (_spawn_1.regs_q, _spawn_3.dmem_q, _spawn_0.pc_q) are
//  taken directly from Anvil's own generated RTL, confirmed by
//  grepping mips_anvil_pipelined.sv rather than assumed: `reg foo :
//  logic[N][W]` compiles to a single flat `logic[N*W-1:0]` vector,
//  word k at bit offset k*32, width 32 (regs_q, dmem_q and imem_q all
//  follow this). Spawn order (Fetch, Decode, Execute, Memory,
//  Writeback) gives spawn_0..spawn_4.
//
//  Emits the same trace format as tb_equiv_sv.sv -- see that file.
//=====================================================================
module tb_equiv_anvil;

    // One more than tb_equiv_sv.sv's RUN_CYCLES: Fetch spends its first
    // post-reset cycle loading imem and setting init_done (PC held at 0),
    // a cycle the SV baseline doesn't spend because its reset block
    // preloads pc and imem together. This keeps both testbenches' USABLE
    // (post-boot) windows the same length -- see
    // run_equivalence.py:normalize_anvil_boot_offset for the corresponding
    // trace-comparison adjustment, and the run summary this suite prints
    // for why that offset is structural, not a bug.
    localparam int RUN_CYCLES = 61;

    logic        clk_i;
    logic        rst_ni;
    integer      c;
    logic [31:0] last_pc;

    MipsPipeline uut (
        .clk_i  (clk_i),
        .rst_ni (rst_ni)
    );

    initial begin
        clk_i = 1'b0;
        forever #5 clk_i = ~clk_i;
    end

    initial begin
        rst_ni = 1'b0;
        #20ns;
        rst_ni = 1'b1;

        last_pc = 32'hFFFFFFFF;
        for (c = 0; c < RUN_CYCLES; c = c + 1) begin
            @(posedge clk_i);
            #1;
            if (uut._spawn_0.pc_q !== last_pc) begin
                $display("PCTRACE %0d %08h", c, uut._spawn_0.pc_q);
                last_pc = uut._spawn_0.pc_q;
            end
        end

        for (int k = 0; k < 32; k = k + 1) begin
            $display("REG %0d %0d", k, uut._spawn_1.regs_q[k*32 +: 32]);
        end
        for (int k = 0; k < 16; k = k + 1) begin
            $display("DMEM %0d %0d", k, uut._spawn_3.dmem_q[k*32 +: 32]);
        end
        $display("DONE");
        $finish;
    end

endmodule
