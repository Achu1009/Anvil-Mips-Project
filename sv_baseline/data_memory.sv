`timescale 1ns/1ps
//=====================================================================
//  data_memory.sv -- byte-addressed data memory with a req/ready
//                    backpressure interface.
//
//  CONTRACT AT THE COMPONENT BOUNDARY
//    * The requester raises `req` when a load or a store occupies MEM.
//      `req` MUST NOT be a function of `ready`: gating it would close a
//      combinational loop through the requester's mem_stall.
//    * While `req` is high and `ready` is low the transaction is IN
//      FLIGHT.  The requester must hold `we`, `addr` and `wdata` stable
//      for its whole duration (checked by P42 on the requester side).
//    * `ready` high means the transaction completes ON THIS EDGE: a
//      store commits exactly once, and `rdata` carries the loaded word.
//    * `rdata` is 32'hDEAD_BEEF while a read is in flight and 0 while idle.  It is
//      deliberately NOT the array contents before completion -- with a
//      transparent read, a pipeline that ignored `ready` would still
//      appear to work and the backpressure would be declared rather
//      than exercised.
//    * A transaction completes within MAX_STALL+1 cycles (P44).
//
//  LATENCY == 1 with RANDOMISE == 0 reproduces the original
//  single-cycle memory exactly (`ready` degenerates to `req`), so the
//  existing 22-cycle regression still passes bit-for-bit.
//=====================================================================
module data_memory #(
    parameter int DEPTH     = 1024,     // bytes
    parameter int LATENCY   = 1,        // cycles a transaction occupies the memory
    parameter bit RANDOMISE = 1'b0      // add a pseudo-random 0..3 extra cycles
) (
    input  logic        clk,
    input  logic        reset,

    input  logic        req,            // load or store present in MEM
    input  logic        we,             // 1 = store, 0 = load
    input  logic [31:0] addr,           // byte address
    input  logic [31:0] wdata,

    output logic        ready,          // transaction completes this edge
    output logic [31:0] rdata           // valid only when (req && ready)
);
    localparam int AW = $clog2(DEPTH);

    // Longest stall this configuration can produce.  The SVA mirrors it.
    localparam int MAX_STALL = (LATENCY - 1) + (RANDOMISE ? 3 : 0);

    logic [7:0] mem [0:DEPTH-1];
    integer     i;

    // ---- the four byte lanes of the word (big-endian, as before) -------
    logic [AW-1:0] a0, a1, a2, a3;
    assign a0 = addr[AW-1:0];
    assign a1 = a0 + AW'(1);
    assign a2 = a0 + AW'(2);
    assign a3 = a0 + AW'(3);

    // ---- pseudo-random extra delay (simulation stimulus, not logic) ----
    logic [7:0] lfsr;
    always_ff @(posedge clk or posedge reset)
        if (reset) lfsr <= 8'hA5;
        else       lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
// the bottom two bits of the LFSR lfsr[1:0] are used to add 0..3 extra cycles to the latency when RANDOMISE is set.
    // ---- latency model -------------------------------------------------
    // cnt    : cycles already spent on the current transaction
    // need_q : cycles this transaction needs, sampled once at its start so
    //          that `ready` cannot jitter mid-transaction
    logic [3:0] cnt, need_q, need_now;

    assign need_now = (cnt == 4'd0)
                    ? (4'(LATENCY - 1) + (RANDOMISE ? {2'b00, lfsr[1:0]} : 4'd0))
                    : need_q;

    assign ready = req && (cnt >= need_now);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt <= 4'd0;  need_q <= 4'd0;
        end else if (req && !ready) begin
            if (cnt == 4'd0) need_q <= need_now;
            cnt <= cnt + 4'd1;
        end else begin
            cnt <= 4'd0;
        end
    end

    // ---- array: the store commits exactly once, on the ready edge ------
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < DEPTH; i = i + 1) mem[i] <= 8'd0;
            mem[3] <= 8'd20;                    // word at address 0 = 20
        end else if (req && we && ready) begin
            mem[a0] <= wdata[31:24];
            mem[a1] <= wdata[23:16];
            mem[a2] <= wdata[15:8];
            mem[a3] <= wdata[7:0];
        end
    end

    // ---- read data ------------------------------------------------------
    // Output a poison value (DEAD_BEEF) while stalled. If the CPU pipeline 
    // is broken and ignores the stall, it will ingest this poison and the 
    // testbench will instantly catch the bug!
    assign rdata = !req  ? 32'd0
                 : ready ? {mem[a0], mem[a1], mem[a2], mem[a3]}
                         : 32'hDEAD_BEEF;
endmodule
