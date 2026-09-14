import mips_pkg::*;

module forwarding_unit (
    input  logic       ex_mem_regwrite,
    input  logic [4:0] ex_mem_rd,
    input  logic       mem_wb_regwrite,
    input  logic [4:0] mem_wb_rd,
    input  logic [4:0] id_ex_rs,
    input  logic [4:0] id_ex_rt,
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);
    always_comb begin
        forward_a = 2'b00;
        forward_b = 2'b00;

        if (ex_mem_regwrite && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs)) begin
            forward_a = 2'b10;
        end else if (mem_wb_regwrite && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs)) begin
            forward_a = 2'b01;
        end

        if (ex_mem_regwrite && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rt)) begin
            forward_b = 2'b10;
        end else if (mem_wb_regwrite && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rt)) begin
            forward_b = 2'b01;
        end
    end

endmodule
