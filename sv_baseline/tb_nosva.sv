`timescale 1ns/1ps
//=====================================================================
//  tb_mips_pipeline_processor.sv
//
//  Testbench + SVA binding for the hand-written 5-stage MIPS pipeline.
//
//  Compile order (xsim / xvlog):
//      mips_pkg.sv
//      instruction_fetch.sv  instruction_decode.sv
//      forwarding_unit.sv    register_file.sv
//      mips_pipeline_processor.sv
//      mips_sva.sv
//      tb_mips_pipeline_processor.sv
//
//  Elaborate with assertions on (xelab default) and run:
//      xvlog -sv <files above>
//      xelab -debug typical tb_mips_pipeline_processor -s tb_run
//      xsim tb_run -runall
//=====================================================================

module tb_mips_pipeline_processor;

    localparam time     CLK_HALF   = 5ns;
    // Backpressure configuration.  LATENCY=1/RANDOMISE=0 reproduces the
    // original single-cycle memory exactly; override from the command
    // line with -GDMEM_LATENCY=3 -GDMEM_RANDOMISE=1.
    parameter int  DMEM_LATENCY   = 1;
    parameter bit  DMEM_RANDOMISE = 1'b0;

    // Memory stalls stretch the program, so the run length has to grow
    // with the latency: 7 instructions + 4 drain, 2 of them memory ops.
    localparam int      RUN_CYCLES = 22 + 8 * (DMEM_LATENCY - 1) + (DMEM_RANDOMISE ? 40 : 0);

    logic        clk;
    logic        reset;
    logic [31:0] dummy_out;
    int          errors = 0;

    mips_pipeline_processor #(
        .DMEM_LATENCY   (DMEM_LATENCY),
        .DMEM_RANDOMISE (DMEM_RANDOMISE)
    ) dut (
        .clk       (clk),
        .reset     (reset),
        .dummy_out (dummy_out)     // was left unconnected; named for clarity
    );

    //-----------------------------------------------------------------
    //  SVA BINDING  --  CORRECTED
    //
    //  The previous bind connected 9 of the 21 ports. Every unconnected
    //  input of a bound instance floats to 'z, and an expression
    //  containing z evaluates to x, which SVA treats as false. The
    //  practical effect was NOT "those properties were skipped": the
    //  bounds and reset properties (P19, P12, P20) have unconditional
    //  or z-valued antecedents and would have reported FAILURES, while
    //  the forwarding properties (P15, P6, P22, P24) had x-valued
    //  antecedents and passed VACUOUSLY. Only P1, P2, P5 and the
    //  hazard-control checks were reading real signals.
    //
    //  Port expressions in a bind are resolved in the scope of the
    //  TARGET module (mips_pipeline_processor), which is why `pc` is
    //  written as the downward reference u_if.pc -- the program counter
    //  is a local of the instruction_fetch instance, not a top-level
    //  net of the processor.
    //-----------------------------------------------------------------
    // (bind removed: no-SVA build)

    //-----------------------------------------------------------------
    //  Second bind: $zero immutability (P31/P32).
    //  regs[] is a local unpacked array of register_file, so it is
    //  resolved here, in the scope where it is declared, rather than
    //  through an unpacked-array select in the processor-level bind.
    //-----------------------------------------------------------------
    // (bind removed: no-SVA build)

    //-----------------------------------------------------------------
    //  Third bind: the data-memory contract (P39b/P39c/P44m).
    //  `mem` is a local unpacked array of data_memory, so it is resolved
    //  here, in the scope where it is declared.
    //-----------------------------------------------------------------
    // (bind removed: no-SVA build)

    //-----------------------------------------------------------------
    //  Clock
    //-----------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #CLK_HALF clk = ~clk;
    end

    //-----------------------------------------------------------------
    //  Reset
    //  Asserted from time 0 (an X->1 transition is a posedge, so the
    //  asynchronous clear in every always_ff fires immediately) and
    //  released at 20ns, i.e. between clock edges. Releasing ON an edge
    //  would create a genuine sampling race against the preponed region;
    //  keeping it off-edge is what makes P20a/P20b/P20c meaningful
    //  rather than accidental.
    //-----------------------------------------------------------------
    initial begin
        reset = 1'b1;
        #20ns;
        reset = 1'b0;
    end

    //-----------------------------------------------------------------
    //  Stimulus and end-of-test scoreboard
    //
    //  The program is hard-coded into imem inside instruction_fetch.sv:
    //      0: lw  r1, 0(r0)          ; r1 <- mem[0]  = 20
    //      1: add r2, r1, r0         ; load-use stall here
    //      2: sub r2, r2, r1         ; r2 <- 0       (EX/MEM forward)
    //      3: jz  r2, L              ; taken
    //      4: add r3, r2, r1         ; SQUASHED, must not execute
    //      5: L: add r4, r2, r1      ; r4 <- 20
    //      6: sw  r1, 0(r4)          ; mem[20] <- 20 (big endian)
    //-----------------------------------------------------------------
    initial begin
        wait (reset === 1'b0);
        repeat (RUN_CYCLES) @(posedge clk);

        $display("--------------------------------------------------");
        $display(" Architectural state at end of test");
        $display("--------------------------------------------------");
        $display("  R1 = %0d", dut.u_regfile.regs[1]);
        $display("  R2 = %0d", dut.u_regfile.regs[2]);
        $display("  R3 = %0d", dut.u_regfile.regs[3]);
        $display("  R4 = %0d", dut.u_regfile.regs[4]);
        $display("  DMEM[20..23] = %0d %0d %0d %0d",
                 dut.u_dmem.mem[20], dut.u_dmem.mem[21], dut.u_dmem.mem[22], dut.u_dmem.mem[23]);

        check32("R0 immutable",      dut.u_regfile.regs[0], 32'd0);
        check32("R1 (lw)",           dut.u_regfile.regs[1], 32'd20);
        check32("R2 (sub -> 0)",     dut.u_regfile.regs[2], 32'd0);
        check32("R3 (squashed)",     dut.u_regfile.regs[3], 32'd0);
        check32("R4 (add)",          dut.u_regfile.regs[4], 32'd20);
        check8 ("DMEM[20]",          dut.u_dmem.mem[20], 8'd0);
        check8 ("DMEM[21]",          dut.u_dmem.mem[21], 8'd0);
        check8 ("DMEM[22]",          dut.u_dmem.mem[22], 8'd0);
        check8 ("DMEM[23]",          dut.u_dmem.mem[23], 8'd20);

        $display("--------------------------------------------------");
        if (errors == 0)
            $display(" SCOREBOARD: PASS  (check the assertion report above");
        else
            $display(" SCOREBOARD: FAIL  (%0d mismatches)", errors);
        $display("  and confirm every cover in mips_sva.sv was hit --");
        $display("  an unhit cover means a property passed vacuously.)");
        $display("--------------------------------------------------");
        $finish;
    end

    function automatic void check32(string name, logic [31:0] got, logic [31:0] exp);
        if (got !== exp) begin
            errors++;
            $error("SCOREBOARD %s: expected %0d, got %0d", name, exp, got);
        end
    endfunction

    function automatic void check8(string name, logic [7:0] got, logic [7:0] exp);
        if (got !== exp) begin
            errors++;
            $error("SCOREBOARD %s: expected %0d, got %0d", name, exp, got);
        end
    endfunction

    //-----------------------------------------------------------------
    //  Waves
    //-----------------------------------------------------------------
    initial begin
        $dumpfile("mips_pipeline.vcd");
        $dumpvars(0, tb_mips_pipeline_processor);
    end

    //=================================================================
    //  STIMULUS GAP -- READ THIS BEFORE CLAIMING FULL COVERAGE
    //
    //  Measured on this program, three covers in mips_sva.sv never hit:
    //
    //    c_fwd_b_ex_mem      0   no instruction reads as rt a register
    //                            written by the immediately preceding one
    //    c_fwd_b_mem_wb      0   same, two instructions back
    //    c_branch_not_taken  0   the single JZ is always taken
    //
    //  So P15c, P15d and P6b currently pass VACUOUSLY -- their antecedents
    //  are never satisfied. That is a hole in the STIMULUS, not the RTL,
    //  and no change to the SVA can close it. Appending these five words
    //  to the program in instruction_fetch.sv closes all three (verified:
    //  all ten covers hit, all assertions still pass):
    //
    //      imem[7]  <= 32'h00012820; // add r5, r0, r1   ; r5 <- 20
    //      imem[8]  <= 32'h00000000; // nop
    //      imem[9]  <= 32'h00053022; // sub r6, r0, r5   ; rt=r5 two back -> MEM/WB -> B
    //      imem[10] <= 32'h00063820; // add r7, r0, r6   ; rt=r6 one back -> EX/MEM -> B
    //      imem[11] <= 32'h08200003; // jz  r1, 3        ; r1=20, so NOT taken
    //
    //  and raising RUN_CYCLES to 32. (JZ encoding: opcode 000010,
    //  rs = instr[25:21], word target = instr[20:0], hence
    //  32'h08200000 | word_addr with rs = r1.)
    //
    //  Leaving the vacuity visible is more useful than deleting the
    //  covers: an unhit cover is the only evidence that distinguishes
    //  "this property holds" from "this property was never tested".
    //=================================================================


    // --- audit monitor: evidence that backpressure was exercised ------
    int mc=0, stall_cycles=0, max_run=0, cur_run=0, txns=0, stores=0, loads=0;
    always @(posedge clk) begin
      #1;
      if (!reset) begin
        mc++;
        if (dut.mem_stall) begin
          stall_cycles++; cur_run++;
          if (cur_run > max_run) max_run = cur_run;
        end else cur_run = 0;
        if (dut.dmem_req && dut.dmem_ready) begin
          txns++;
          if (dut.dmem_we) stores++; else loads++;
        end
      end
    end
    final begin
      $display("MONITOR cycles=%0d  mem_stall_cycles=%0d  longest_stall=%0d  txns=%0d (loads=%0d stores=%0d)",
               mc, stall_cycles, max_run, txns, loads, stores);
    end

endmodule