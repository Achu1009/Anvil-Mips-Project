import mips_pkg::*;

module instruction_fetch #(
    parameter int IMEM_WORDS = 256          // 256 words == 1 KiB
) (
    input  logic        clk,
    input  logic        reset,
    input  logic        pc_write,
    input  logic        branch_taken,
    input  logic [31:0] branch_target,
    output logic [31:0] instr,
    output logic [31:0] pc_plus4
);
    // Fetch index width.  pc[IAW+1:2] is exactly wide enough to address
    // imem and no wider -- see the note on `instr` below.
    localparam int IAW = $clog2(IMEM_WORDS);

    logic [31:0] pc;
    logic [31:0] imem [0:IMEM_WORDS-1];
    integer i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'd0;

            for (i = 0; i < IMEM_WORDS; i = i + 1) begin
                imem[i] <= 32'd0;
            end

            imem[0] <= 32'h8C010000; // lw  r1, 0(r0)
            imem[1] <= 32'h00201020; // add r2, r1, r0
            imem[2] <= 32'h00411022; // sub r2, r2, r1
            imem[3] <= 32'h08400005; // jz  r2, L (L at word address 5)
            imem[4] <= 32'h00411820; // add r3, r2, r1
            imem[5] <= 32'h00412020; // L: add r4, r2, r1
            imem[6] <= 32'hAC810000; // sw  r1, 0(r4)
        end else if (branch_taken) begin
            pc <= branch_target;       // Jump always overrides a stall
        end else if (pc_write) begin
            pc <= pc + 32'd4;          // Normal PC increment (only if not stalled)
        end
    end

    // Fetch index.  Was pc[31:2] -- a 30-bit index into a 256-entry
    // array, i.e. an out-of-range access for any PC >= 1 KiB: X in
    // simulation, undefined in synthesis.  Narrowed to the array's own
    // address width, the same fix data_memory applies on the data side.
    //
    // WHAT THIS DOES AND DOES NOT FIX.  Fetch is now TOTAL: every PC
    // produces a defined instruction.  It is not CORRECT: the PC can
    // still leave the program (nothing halts the increment, and
    // ex_branch_target spans 23 bits), and the access now silently
    // ALIASES back into imem instead of returning X.  That trades an
    // X-propagation bug for an address-aliasing bug -- better for
    // synthesis, worse for debug, and it makes P19 the only thing left
    // that flags a runaway PC.  A trap or a halt is the real fix; this
    // ISA subset has no exception mechanism to hang one on.
    assign instr      = imem[pc[IAW+1:2]];
    assign pc_plus4   = pc + 32'd4;

endmodule
