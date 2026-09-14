import mips_pkg::*;

module register_file #(
    parameter ENABLE_BYPASS = 1
) (
    input  logic        clk,
    input  logic        reset,
    input  logic        reg_write,
    input  logic [4:0]  read_reg1,
    input  logic [4:0]  read_reg2,
    input  logic [4:0]  write_reg,
    input  logic [31:0] write_data,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);
    logic [31:0] regs [0:31];
    integer i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'd0;
            end
        end else begin
            if (reg_write && (write_reg != 5'd0)) begin
                regs[write_reg] <= write_data;
            end
            // Hardwire R0 to always be 0
            regs[5'd0] <= 32'd0;
        end
    end

    always_comb begin
        if (read_reg1 == 5'd0) begin
            read_data1 = 32'd0;
        end else if (ENABLE_BYPASS && reg_write && (write_reg != 5'd0) && (write_reg == read_reg1)) begin
            read_data1 = write_data; // Write-through bypass
        end else begin
            read_data1 = regs[read_reg1];
        end

        if (read_reg2 == 5'd0) begin
            read_data2 = 32'd0;
        end else if (ENABLE_BYPASS && reg_write && (write_reg != 5'd0) && (write_reg == read_reg2)) begin
            read_data2 = write_data; // Write-through bypass
        end else begin
            read_data2 = regs[read_reg2];
        end
    end

endmodule