package mips_pkg;

    // Enums for strongly typed Opcodes
    typedef enum logic [5:0] {
        OP_RTYPE = 6'b000000,
        OP_LW    = 6'b100011,
        OP_SW    = 6'b101011,
        OP_JZ    = 6'b000010
    } opcode_t;

    // Enums for strongly typed Funct codes
    typedef enum logic [5:0] {
        FUNCT_ADD = 6'b100000,
        FUNCT_SUB = 6'b100010
    } funct_t;

    // Structs for Pipeline Registers
    typedef struct packed {
        logic [31:0] instr;
        logic [31:0] pc_plus4;
    } if_id_t;

    typedef struct packed {
        logic        reg_dst;
        logic        alu_src;
        logic        mem_to_reg;
        logic        reg_write;
        logic        mem_read;
        logic        mem_write;
        logic        branch_zero;
        logic [1:0]  alu_op;
        logic [31:0] rd1;
        logic [31:0] rd2;
        logic [31:0] imm32;
        logic [20:0] addr21;
        logic [4:0]  rs;
        logic [4:0]  rt;
        logic [4:0]  rd;
        funct_t      funct;
    } id_ex_t;

    typedef struct packed {
        logic        mem_to_reg;
        logic        reg_write;
        logic        mem_read;
        logic        mem_write;
        logic [31:0] alu_result;
        logic [31:0] write_data; // Data to store in mem
        logic [4:0]  dest_reg;
    } ex_mem_t;

    typedef struct packed {
        logic        mem_to_reg;
        logic        reg_write;
        logic [31:0] read_data; // Data loaded from mem
        logic [31:0] alu_result;
        logic [4:0]  dest_reg;
    } mem_wb_t;

endpackage
