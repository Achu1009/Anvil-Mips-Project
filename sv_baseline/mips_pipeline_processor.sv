import mips_pkg::*;

module mips_pipeline_processor #(
    parameter int DMEM_LATENCY   = 1,      // 1 == original single-cycle memory
    parameter bit DMEM_RANDOMISE = 1'b0
) (
    input logic clk,
    input logic reset,
    output logic [31:0] dummy_out
);
    // dmem now lives in u_dmem (data_memory.sv), behind a req/ready
    // interface.  `i` was only used by its reset loop and is gone with it.

    // --- IF STAGE WIRES ---
    logic [31:0] if_instr;
    logic [31:0] if_pc_plus4;

    // --- PIPELINE REGISTERS (Using Structs) ---
    if_id_t  if_id;
    id_ex_t  id_ex;
    ex_mem_t ex_mem;
    mem_wb_t mem_wb;

    // --- ID STAGE WIRES ---
    opcode_t     id_opcode;
    logic [4:0]  id_rs, id_rt, id_rd, id_shamt;
    funct_t      id_funct;
    logic [15:0] id_imm16;
    logic [20:0] id_addr21;
    
    logic        id_reg_dst, id_alu_src, id_mem_to_reg, id_reg_write;
    logic        id_mem_read, id_mem_write, id_branch_zero;
    logic [1:0]  id_alu_op;
    logic [31:0] id_imm32;
    logic [31:0] id_rd1_wire;
    logic [31:0] id_rd2_wire;

    // --- EX STAGE WIRES ---
    logic [1:0]  forward_a, forward_b;
    logic [31:0] ex_forward_a_data, ex_forward_b_data;
    logic [31:0] ex_alu_operand_b, ex_alu_result;
    logic [4:0]  ex_dest_reg;
    logic        ex_branch_taken;
    logic [31:0] ex_branch_target;

    // --- MEM STAGE WIRES ---
    logic [31:0] mem_read_data;

    // --- WB STAGE WIRES ---
    logic [31:0] wb_data;

    // --- HAZARD WIRES ---
    logic load_use_hazard, if_uses_rs, if_uses_rt, pc_write, if_id_write;

    // --- DATA-MEMORY INTERFACE + BACKPRESSURE ---
    logic        dmem_req, dmem_we, dmem_ready;
    logic [31:0] dmem_addr, dmem_wdata;
    logic        mem_stall;          // the one global stall
    logic        if_branch_taken;    // ex_branch_taken, qualified by the stall
    logic        wb_done;            // WB already committed this instruction
    logic        rf_write_en;        // register-file write enable

    // ==========================================
    // MODULE INSTANTIATIONS
    // ==========================================

    instruction_fetch u_if (
        .clk(clk),
        .reset(reset),
        .pc_write(pc_write),
        // u_if tests branch_taken BEFORE pc_write, so an unqualified
        // branch would move the PC while the rest of the pipe is frozen.
        .branch_taken(if_branch_taken),
        .branch_target(ex_branch_target),
        .instr(if_instr),
        .pc_plus4(if_pc_plus4)
    );

    instruction_decode u_id (
        .instr(if_id.instr),
        .opcode(id_opcode),
        .rs(id_rs),
        .rt(id_rt),
        .rd(id_rd),
        .shamt(id_shamt),
        .funct(id_funct),
        .imm16(id_imm16),
        .addr21(id_addr21),
        .reg_dst(id_reg_dst),
        .alu_src(id_alu_src),
        .mem_to_reg(id_mem_to_reg),
        .reg_write(id_reg_write),
        .mem_read(id_mem_read),
        .mem_write(id_mem_write),
        .branch_zero(id_branch_zero),
        .alu_op(id_alu_op)
    );

    register_file u_regfile (
        .clk(clk),
        .reset(reset),
        .reg_write(rf_write_en),
        .read_reg1(id_rs), 
        .read_reg2(id_rt),
        .write_reg(mem_wb.dest_reg),
        .write_data(wb_data),
        .read_data1(id_rd1_wire),
        .read_data2(id_rd2_wire)
    );

    forwarding_unit u_fwd (
        .ex_mem_regwrite(ex_mem.reg_write),
        .ex_mem_rd(ex_mem.dest_reg),
        .mem_wb_regwrite(mem_wb.reg_write),
        .mem_wb_rd(mem_wb.dest_reg),
        .id_ex_rs(id_ex.rs), 
        .id_ex_rt(id_ex.rt),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    // ==========================================
    // COMBINATIONAL LOGIC
    // ==========================================

    assign id_imm32 = {{16{id_imm16[15]}}, id_imm16}; // just sign extending the 16 bit imm value to 32 bits

    assign if_uses_rs = (id_opcode == OP_RTYPE) || (id_opcode == OP_LW) || (id_opcode == OP_SW) || (id_opcode == OP_JZ); // its actually always used so basically always 1
    assign if_uses_rt = (id_opcode == OP_RTYPE) || (id_opcode == OP_SW);

    // Load-Use Hazard Detection - results in stalling
    assign load_use_hazard = id_ex.mem_read && (
        ((id_ex.rt == id_rs) && if_uses_rs && (id_ex.rt != 5'd0)) ||
        ((id_ex.rt == id_rt) && if_uses_rt && (id_ex.rt != 5'd0)) // as reg 0 in mips is harwired to 0
    );

    // ---- data-memory request.  NOTE: NOT gated by dmem_ready or by
    // mem_stall -- that would close a combinational loop.  This also
    // makes ex_mem.mem_read live for the first time; the old design
    // read dmem unconditionally and ignored that bit entirely.
    assign dmem_req   = ex_mem.mem_read | ex_mem.mem_write;
    assign dmem_we    = ex_mem.mem_write;
    assign dmem_addr  = ex_mem.alu_result;
    assign dmem_wdata = ex_mem.write_data;

    // ---- the one global stall.  `dmem_req &` is load-bearing: without
    // it an idle memory that is not asserting ready would stall forever.
    assign mem_stall  = dmem_req & ~dmem_ready;

    // A memory stall dominates every other control decision.
    assign pc_write        = ~load_use_hazard & ~mem_stall;
    assign if_id_write     = ~load_use_hazard & ~mem_stall;
    assign if_branch_taken =  ex_branch_taken & ~mem_stall;

    // ---- WB commits exactly once, however long the memory stalls.
    // MEM/WB is FROZEN during a stall (it is a forwarding source and
    // must not be destroyed), so its write enable has to be suppressed
    // after the first commit instead.
    always_ff @(posedge clk or posedge reset) begin
        if (reset)          wb_done <= 1'b0;
        else if (mem_stall) wb_done <= 1'b1;
        else                wb_done <= 1'b0;
    end
    assign rf_write_en = mem_wb.reg_write & ~wb_done;

    assign wb_data = mem_wb.mem_to_reg ? mem_wb.read_data : mem_wb.alu_result;

    // Forwarding Multiplexers (EX Stage)
    always_comb begin
        case (forward_a) 
            2'b10: ex_forward_a_data = ex_mem.alu_result; //ex/mem forwarding
            2'b01: ex_forward_a_data = wb_data; // mem/wb forwarding
            default: ex_forward_a_data = id_ex.rd1;
        endcase

        case (forward_b) 
            2'b10: ex_forward_b_data = ex_mem.alu_result;
            2'b01: ex_forward_b_data = wb_data;
            default: ex_forward_b_data = id_ex.rd2;
        endcase
    end

    // ALU Logic (EX Stage)
    always_comb begin 
        if (id_ex.alu_src) begin //alu_src = 1 for memoery type and 0 for R type
            ex_alu_operand_b = id_ex.imm32;
        end 
        else begin
            ex_alu_operand_b = ex_forward_b_data;
        end
// operand a is always rs
        case (id_ex.alu_op)
            2'b10: begin 
                case (id_ex.funct)
                    FUNCT_SUB: ex_alu_result = ex_forward_a_data - ex_alu_operand_b;
                    default:   ex_alu_result = ex_forward_a_data + ex_alu_operand_b;
                endcase
            end
            default: begin 
                ex_alu_result = ex_forward_a_data + ex_alu_operand_b;
            end
        endcase

        ex_dest_reg = id_ex.reg_dst ? id_ex.rd : id_ex.rt;
        ex_branch_taken  = id_ex.branch_zero && (ex_forward_a_data == 32'd0);
        ex_branch_target = {9'd0, id_ex.addr21, 2'b00}; //last 2 bits 0 as all instr are 32 bits
    end

    // Data Memory (MEM stage), behind a req/ready backpressure interface.
    data_memory #(
        .DEPTH     (1024),
        .LATENCY   (DMEM_LATENCY),
        .RANDOMISE (DMEM_RANDOMISE)
    ) u_dmem (
        .clk   (clk),
        .reset (reset),
        .req   (dmem_req),
        .we    (dmem_we),
        .addr  (dmem_addr),
        .wdata (dmem_wdata),
        .ready (dmem_ready),
        .rdata (mem_read_data)
    );

    // ==========================================
    // PIPELINE REGISTERS (CLOCKED LOGIC)
    // ==========================================
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            if_id  <= '0;
            id_ex  <= '0;
            ex_mem <= '0;
            mem_wb <= '0;
            // (the dmem reset loop and dmem[3] <= 20 moved into u_dmem)
        end
        // ------------------------------------------------------------
        // A MEMORY STALL FREEZES THE ENTIRE PIPELINE.
        //
        // Unlike a load-use stall there is nothing to drain into: the
        // blockage is at the BACK of the pipe.  In particular MEM/WB
        // must hold, not bubble -- it is a forwarding source for EX, and
        // zeroing it silently drops a MEM/WB->EX bypass for an
        // instruction already in flight.  The repeated register-file
        // write that freezing would otherwise cause is suppressed by
        // wb_done (see rf_write_en above).
        // ------------------------------------------------------------
        else if (!mem_stall) begin
            
            // 1. IF/ID Register
            if (if_id_write) begin
                if_id.instr    <= if_instr;
                if_id.pc_plus4 <= if_pc_plus4;
            end
            if (ex_branch_taken) begin
                if_id <= '0; // Flush
            end

            // 2. ID/EX Register
            if (load_use_hazard || ex_branch_taken) begin
                id_ex <= '0; // Bubble
            end else begin
                id_ex.reg_dst     <= id_reg_dst;
                id_ex.alu_src     <= id_alu_src;
                id_ex.mem_to_reg  <= id_mem_to_reg;
                id_ex.reg_write   <= id_reg_write;
                id_ex.mem_read    <= id_mem_read;
                id_ex.mem_write   <= id_mem_write;
                id_ex.branch_zero <= id_branch_zero;
                id_ex.alu_op      <= id_alu_op;
                id_ex.imm32       <= id_imm32;
                id_ex.addr21      <= id_addr21;
                id_ex.rs          <= id_rs;
                id_ex.rt          <= id_rt;
                id_ex.rd          <= id_rd;
                id_ex.funct       <= id_funct;
                id_ex.rd1         <= id_rd1_wire;
                id_ex.rd2         <= id_rd2_wire;
            end

            // 3. EX/MEM Register
            ex_mem.mem_to_reg <= id_ex.mem_to_reg;
            ex_mem.reg_write  <= id_ex.reg_write;
            ex_mem.mem_read   <= id_ex.mem_read;
            ex_mem.mem_write  <= id_ex.mem_write;
            ex_mem.alu_result <= ex_alu_result;
            ex_mem.write_data <= ex_forward_b_data;
            ex_mem.dest_reg   <= ex_dest_reg;

            // (the dmem write block is DELETED -- u_dmem commits the
            //  store itself, exactly once, on its ready edge)

            // 4. MEM/WB Register
            mem_wb.mem_to_reg <= ex_mem.mem_to_reg;
            mem_wb.reg_write  <= ex_mem.reg_write;
            mem_wb.read_data  <= mem_read_data;
            mem_wb.alu_result <= ex_mem.alu_result;
            mem_wb.dest_reg   <= ex_mem.dest_reg;
        end
    end

    assign dummy_out = wb_data;
endmodule