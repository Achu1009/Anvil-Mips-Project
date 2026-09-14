import mips_pkg::*;

module instruction_decode (
    input  logic [31:0] instr,
    output opcode_t     opcode,
    output logic [4:0]  rs,
    output logic [4:0]  rt,
    output logic [4:0]  rd,
    output logic [4:0]  shamt,
    output funct_t      funct,
    output logic [15:0] imm16,
    output logic [20:0] addr21,
    output logic        reg_dst,
    output logic        alu_src,
    output logic        mem_to_reg,
    output logic        reg_write,
    output logic        mem_read,
    output logic        mem_write,
    output logic        branch_zero,
    output logic [1:0]  alu_op
);
    assign opcode = opcode_t'(instr[31:26]);
    assign rs     = instr[25:21];
    assign rt     = instr[20:16];
    assign rd     = instr[15:11];
    assign shamt  = instr[10:6];
    assign funct  = funct_t'(instr[5:0]);
    assign imm16  = instr[15:0];
    assign addr21 = instr[20:0];

    always_comb begin
        reg_dst     = 1'b0;
        alu_src     = 1'b0;
        mem_to_reg  = 1'b0;
        reg_write   = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        branch_zero = 1'b0;
        alu_op      = 2'b00;

        case (opcode)
            OP_RTYPE: begin
                reg_dst    = 1'b1;
                alu_src    = 1'b0;
                reg_write  = 1'b1;
                alu_op     = 2'b10;
            end
            OP_LW: begin
                reg_dst    = 1'b0;
                alu_src    = 1'b1;
                mem_to_reg = 1'b1;
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                alu_op     = 2'b00;
            end
            OP_SW: begin
                alu_src    = 1'b1;
                mem_write  = 1'b1;
                alu_op     = 2'b00;
            end
            OP_JZ: begin
                branch_zero = 1'b1;
                alu_op      = 2'b00;
            end
            default: begin
            end
        endcase
    end

endmodule
