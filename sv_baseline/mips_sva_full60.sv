`timescale 1ns/1ps
//=====================================================================
//  mips_sva.sv  --  SVA suite for the 5-stage MIPS pipeline
//
//  Bound into mips_pipeline_processor (see tb_mips_pipeline_processor.sv).
//
//  Naming: property IDs keep the original P<n> numbering so the report
//  cross-references still work. New properties start at P28.
//
//  CATEGORIES follow the project brief's taxonomy, not an ad-hoc one:
//      A  local state .................. reset, stalls, bubbles, $zero
//      B  interface stability .......... PC, the IF->ID handoff, alignment
//      C  resource ownership/exclusion .. forwarding: who supplies an operand
//      D  transaction-level ............ branch squash as a whole transaction
//      E  end-to-end invariant ......... commit equivalence vs the single-cycle
//                                        reference -- lives in tb_equivalence.sv,
//                                        NOT here, because it needs two DUTs.
//  Bounds/alignment properties are grouped separately and deliberately: they
//  are environment assumptions this RTL does not enforce, not invariants.
//  Each block carries a RATIONALE and a VERDICT tag:
//     [PROVEN]     holds for all reachable states of this RTL
//     [BOUNDED]    holds only for the current test program / run length
//     [CHECKER]    guards a property the RTL does NOT implement (bug net)
//=====================================================================
import mips_pkg::*;

module mips_sva (
    input logic          clk,
    input logic          reset,

    // IF stage
    input logic [31:0]   pc,             // u_if.pc  (hierarchical)
    input logic [31:0]   if_instr,
    input logic [31:0]   if_pc_plus4,

    // IF/ID
    input if_id_t        if_id,

    // ID stage
    input id_ex_t        id_ex,
    input logic [4:0]    id_rs,
    input logic [4:0]    id_rt,
    input opcode_t       id_opcode,
    input logic [31:0]   id_rd1_wire,
    input logic [31:0]   id_rd2_wire,

    // Forwarding: selects and the resulting operand VALUES
    input logic [1:0]    forward_a,
    input logic [1:0]    forward_b,
    input logic [31:0]   ex_forward_a_data,
    input logic [31:0]   ex_forward_b_data,

    // Later stages
    input ex_mem_t       ex_mem,
    input mem_wb_t       mem_wb,
    input logic [31:0]   mem_read_data,   // dmem word addressed by ex_mem.alu_result
    input logic [31:0]   wb_data,         // value MEM/WB will write to the regfile

    // Control / hazard
    input logic          load_use_hazard,
    input logic          pc_write,
    input logic          if_id_write,
    input logic          ex_branch_taken,
    input logic [31:0]   ex_branch_target,

    // --- backpressure interface (Phase-1b) ---
    input logic          mem_stall,
    input logic          if_branch_taken,   // ex_branch_taken & ~mem_stall
    input logic          dmem_req,
    input logic          dmem_we,
    input logic          dmem_ready,
    input logic [31:0]   dmem_addr,
    input logic [31:0]   dmem_wdata,
    input logic          rf_write_en,
    input logic          wb_done
);

    //-----------------------------------------------------------------
    //  0.  SVA-local scaffolding
    //-----------------------------------------------------------------

    // $past() reaches across the reset boundary on the first active edge
    // and returns pre-reset garbage. sva_past_ok gates every $past-using
    // property so the first post-reset attempt is skipped, not falsified.
    logic sva_past_ok;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) sva_past_ok <= 1'b0;
        else       sva_past_ok <= 1'b1;
    end

    // Two-deep companion for properties that reach back two cycles.
    logic sva_past_ok2;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) sva_past_ok2 <= 1'b0;
        else       sva_past_ok2 <= sva_past_ok;
    end

    // Longest stall this memory configuration can produce.  Keep in sync
    // with data_memory's MAX_STALL = (LATENCY-1) + (RANDOMISE ? 3 : 0).
    localparam int MAX_STALL = 8;

    // Consecutive memory-stall cycles, saturating so it cannot wrap past
    // the bound and silently stop firing.
    logic [3:0] stall_cnt;
    always_ff @(posedge clk or posedge reset) begin
        if (reset)                               stall_cnt <= 4'd0;
        else if (mem_stall && stall_cnt != 4'hF) stall_cnt <= stall_cnt + 4'd1;
        else if (!mem_stall)                     stall_cnt <= 4'd0;
    end

    // Pipeline ADVANCES since the last taken branch, for P8b.  Counting
    // advances rather than clock cycles is what makes the squash window
    // immune to an arbitrarily long memory stall landing inside it.
    //   0 = idle, 1 = first post-branch advance, 2 = second
    logic [1:0] squash_age;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) squash_age <= 2'd0;
        else if (!mem_stall) begin
            if (if_branch_taken)         squash_age <= 2'd1;
            else if (squash_age == 2'd1) squash_age <= 2'd2;
            else                         squash_age <= 2'd0;
        end
    end

    // ---------------------------------------------------------------
    // INDEPENDENT decode model.
    // Deliberately NOT reused from instruction_decode / the DUT's
    // if_uses_rs/if_uses_rt wires: an assertion that imports the
    // implementation's own expression can only ever restate it.
    // These are re-derived from the raw instruction word in IF/ID.
    // ---------------------------------------------------------------
    localparam logic [5:0] OPC_RTYPE = 6'b000000;
    localparam logic [5:0] OPC_LW    = 6'b100011;
    localparam logic [5:0] OPC_SW    = 6'b101011;
    localparam logic [5:0] OPC_JZ    = 6'b000010;

    logic [5:0] m_opcode;
    logic [4:0] m_rs, m_rt;
    logic       m_uses_rs, m_uses_rt, m_load_use;

    assign m_opcode  = if_id.instr[31:26];
    assign m_rs      = if_id.instr[25:21];
    assign m_rt      = if_id.instr[20:16];

    // rs is a source for every opcode in this ISA subset;
    // rt is a source only for R-type (operand) and SW (store data).
    // For LW, rt is the DESTINATION, not a source.
    assign m_uses_rs = (m_opcode == OPC_RTYPE) || (m_opcode == OPC_LW) ||
                       (m_opcode == OPC_SW)    || (m_opcode == OPC_JZ);
    assign m_uses_rt = (m_opcode == OPC_RTYPE) || (m_opcode == OPC_SW);

    // A load in EX whose destination (rt, because LW has reg_dst=0)
    // is read by the instruction currently in ID.
    assign m_load_use = id_ex.mem_read && (id_ex.rt != 5'd0) &&
                        (((id_ex.rt == m_rs) && m_uses_rs) ||
                         ((id_ex.rt == m_rt) && m_uses_rt));

    // ---------------------------------------------------------------
    // EX-stage operand liveness.
    // The forwarding unit compares id_ex.rs / id_ex.rt unconditionally,
    // including for instructions that never consume that operand. Two
    // cases matter:
    //   * an unrecognised opcode decodes to all-zero control, so it sits
    //     in EX with a live rs field and no architectural effect;
    //   * LW carries rt as its DESTINATION, so a forward into operand B
    //     of an LW is selected and then discarded (alu_src picks imm32).
    // Both would make P29 fire on a harmless event. These predicates
    // scope P29 to the operands that are actually consumed.
    // ---------------------------------------------------------------
    logic ex_uses_a, ex_uses_b;
    assign ex_uses_a = id_ex.reg_write || id_ex.mem_write || id_ex.branch_zero;
    assign ex_uses_b = id_ex.mem_write || (!id_ex.alu_src && id_ex.reg_write);

    //=================================================================
    //  CATEGORY A.1 -- LOCAL STATE : RESET
    //=================================================================

    // -----------------------------------------------------------------
    // P20a -- Reset holds the pipeline at zero (synchronous view)
    // RATIONALE: while reset is asserted, every architectural register
    // sampled at a clock edge must read zero. This is the *synchronous*
    // half of an asynchronous reset: it proves reset dominates at edges.
    // LIMITATION (see P20c): a reset pulse narrower than one clock
    // period is never sampled here, so this property alone cannot
    // verify an async reset. That is a semantic gap, not a bug.
    // VERDICT: [PROVEN] -- no disable iff, reset is the antecedent.
    // -----------------------------------------------------------------
    property p_reset_state_sync;
        @(posedge clk)
        reset |-> (pc == 32'd0) && (if_id == '0) && (id_ex == '0) &&
                  (ex_mem == '0) && (mem_wb == '0);
    endproperty
    a_p20a_reset_state_sync: assert property (p_reset_state_sync)
        else $error("P20a Violated: pipeline state non-zero while reset asserted");

    // -----------------------------------------------------------------
    // P20b -- Reset release leaves a clean machine  [NEW]
    // RATIONALE: P20a says "zero while reset is high". It says nothing
    // about the first edge after release, which is exactly where a
    // mis-ordered async clear shows up. $fell(reset) pins that edge.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_reset_release_clean;
        @(posedge clk)
        $fell(reset) |-> (pc == 32'd0) && (if_id == '0) && (id_ex == '0) &&
                         (ex_mem == '0) && (mem_wb == '0);
    endproperty
    a_p20b_reset_release_clean: assert property (p_reset_release_clean)
        else $error("P20b Violated: state not clean on the reset-release edge");

    // -----------------------------------------------------------------
    // P20c -- Asynchronous reset takes effect immediately  [NEW, SIM-ONLY]
    // RATIONALE: the DUT uses `always_ff @(posedge clk or posedge reset)`.
    // A concurrent assertion cannot express "clears without a clock":
    // clocking it on `posedge reset` samples the PREPONED region, i.e.
    // the values *before* the clear, and would always fail. The only
    // sound formulation in simulation is an immediate assertion placed
    // after the NBA region of the reset edge -- hence the #1ps.
    // NOT synthesisable into a formal proof; in formal, reset is modelled
    // as a constraint instead. Kept because it is the only thing in the
    // suite that actually exercises the *asynchronous* path.
    // VERDICT: [PROVEN in simulation]
    // -----------------------------------------------------------------
    always @(posedge reset) begin
        #1ps;
        a_p20c_async_reset: assert ((pc === 32'd0) && (if_id === '0) &&
                                    (id_ex === '0) && (ex_mem === '0) &&
                                    (mem_wb === '0))
            else $error("P20c Violated: async reset did not clear state without a clock edge");
    end

    // -----------------------------------------------------------------
    // P21 -- Control-signal integrity (no X/Z on control)
    // RATIONALE: an X on a select line silently disables every other
    // property in this file (an X-valued antecedent is treated as false,
    // so assertions pass vacuously). P21 is the tripwire for that.
    // Extended beyond the original list to cover pc and the register
    // indices, which feed the forwarding comparators.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_control_integrity;
        @(posedge clk) disable iff (reset)
        !$isunknown({load_use_hazard, pc_write, if_id_write, ex_branch_taken,
                     forward_a, forward_b, pc,
                     id_ex.rs, id_ex.rt, ex_mem.dest_reg, mem_wb.dest_reg,
                     ex_mem.reg_write, mem_wb.reg_write,
                     mem_stall, dmem_req, dmem_ready, rf_write_en, wb_done});
    endproperty
    a_p21_control_integrity: assert property (p_control_integrity)
        else $error("P21 Violated: a critical control signal is X or Z");

    //=================================================================
    //  CATEGORY A.2 -- LOCAL STATE : STALLS AND BUBBLES
    //=================================================================

    // -----------------------------------------------------------------
    // P1 -- Load-use detection is exactly right  [REWRITTEN]
    //
    // WHAT IT PROTECTS
    //   That the hazard unit fires on exactly the right cycles. Not one
    //   fewer, and not one more.
    //
    // WHY THE ORIGINAL WAS REPLACED
    //   The original wrote the hazard equation out again inside this file
    //   and then checked
    //         (that equation)  |->  load_use_hazard
    //   That tests ONE direction only. If the design fails to stall when
    //   it should, the left side is true and the right side is false, so
    //   it fires -- good. But if the design stalls when it should NOT,
    //   the left side is false and the property passes without checking
    //   anything at all.
    //
    //   That gap is real, not theoretical. Measured: a design changed to
    //   stall after EVERY load, dependency or not, does not trigger the
    //   original P1 once. The new P1 catches it immediately.
    //
    //   The original also read the DUT's own decoder outputs (id_opcode,
    //   id_rs, id_rt). A decoder that swapped rs and rt would hand the
    //   same wrong values to the design and to the assertion, and the two
    //   would agree with each other while both being wrong.
    //
    // WHAT REPLACES IT
    //   m_load_use is rebuilt from if_id.instr -- the raw 32-bit
    //   instruction word -- using an opcode table written here rather
    //   than taken from instruction_decode. Checking equality (==)
    //   instead of implication tests both directions at once.
    //
    // HOW A VIOLATION SHOWS UP
    //   Fires on the cycle the hazard unit and the model disagree, so it
    //   points straight at the hazard logic. Left to the testbench, a
    //   missed stall appears as a wrong register value two or three
    //   cycles later, and an extra stall does not appear at all -- the
    //   program just quietly runs slower.
    //
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_load_use_detect;
        @(posedge clk) disable iff (reset)
        load_use_hazard == m_load_use;
    endproperty
    a_p1_load_use_detect: assert property (p_load_use_detect)
        else $error("P1 Violated: hazard unit disagrees with the independent decode model");

    // -----------------------------------------------------------------
    // P1b -- A detected hazard actually drives the stall controls
    // RATIONALE: separates "did we notice?" (P1) from "did we act?" (P1b)
    // so a failure localises immediately. |-> because pc_write and
    // if_id_write are combinational functions of load_use_hazard.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_stall_drives_controls;
        @(posedge clk) disable iff (reset)
        load_use_hazard |-> (!pc_write && !if_id_write);
    endproperty
    a_p1b_stall_drives_controls: assert property (p_stall_drives_controls)
        else $error("P1b Violated: hazard asserted but pc_write/if_id_write not deasserted");

    // -----------------------------------------------------------------
    // P2 -- Stall injects a full bubble  [STRENGTHENED]
    // RATIONALE: original checked only reg_write/mem_write/mem_read.
    // A partial flush that zeroed the control bits but left rs/rt/rd1
    // intact would pass the original and still corrupt the forwarding
    // comparators in the next cycle. The RTL does `id_ex <= '0`, so the
    // assertion should say exactly that.
    // |=> is correct: id_ex is a non-blocking register update, visible
    // on the NEXT sampling edge.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_stall_bubble;
        @(posedge clk) disable iff (reset)
        (load_use_hazard && !mem_stall) |=> (id_ex == '0);
    endproperty
    a_p2_stall_bubble: assert property (p_stall_bubble)
        else $error("P2 Violated: ID/EX not fully bubbled on stall");

    // -----------------------------------------------------------------
    // P3 -- Stall does not drop the instruction in IF/ID  [FIXED]
    //
    // WHAT IT PROTECTS
    //   While the pipeline is stalled, the instruction waiting in IF/ID
    //   must stay where it is. If something overwrote it, that
    //   instruction would be lost and would never execute.
    //
    // WHAT WAS WRONG WITH THE ORIGINAL
    //   It never mentioned branches. In the DUT the IF/ID flush is
    //   written AFTER the write-enable, so it wins:
    //      if (if_id_write)      if_id <= {if_instr, if_pc_plus4};
    //      if (ex_branch_taken)  if_id <= '0;        // this one wins
    //   If a stall and a taken branch ever landed on the same cycle,
    //   IF/ID would be zeroed and the original P3 would fire -- even
    //   though zeroing is the CORRECT thing to do there. A flush should
    //   beat a stall.
    //
    //   Can that actually happen? Only if the instruction in EX is both a
    //   load and a branch, which this decoder cannot produce. So the
    //   original property was leaning on an assumption it never wrote
    //   down. A simulator never reaches that state, so it never
    //   complains. A formal tool has no idea the decoder is restricted --
    //   it will happily set id_ex.mem_read and id_ex.branch_zero both to
    //   1 and hand back a counterexample on the first step.
    //
    // THE FIX
    //   Say the assumption out loud (guard with !ex_branch_taken) and
    //   prove it separately in P3b. Also widened from if_id.instr to the
    //   whole struct, so a stale pc_plus4 cannot slip through unnoticed.
    //
    // HOW A VIOLATION SHOWS UP
    //   Fires the cycle after a stall, and the waveform shows
    //   if_id.instr changing while pc_write was low. The underlying bug
    //   -- a dropped instruction -- would otherwise surface much later
    //   as a register write that simply never happened.
    //
    // VERDICT: [PROVEN] given P3b
    // -----------------------------------------------------------------
    property p_stall_freeze_if_id;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (load_use_hazard && !ex_branch_taken) |=> (if_id == $past(if_id));
    endproperty
    a_p3_stall_freeze_if_id: assert property (p_stall_freeze_if_id)
        else $error("P3 Violated: IF/ID not frozen during stall");

    // -----------------------------------------------------------------
    // P3b -- Stall and branch are mutually exclusive  [NEW]
    // RATIONALE: this is the assumption P3 and P4 lean on, promoted to a
    // checked property. mem_read and branch_zero are both fields of the
    // SAME id_ex register, so this is really "the control decode is
    // one-hot across LW and JZ". If someone later adds a load-with-
    // branch opcode, this fires FIRST and tells you why P3/P4 are now
    // unsound -- instead of P3/P4 failing mysteriously.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_no_stall_and_branch;
        @(posedge clk) disable iff (reset)
        !(id_ex.mem_read && id_ex.branch_zero);
    endproperty
    a_p3b_no_stall_and_branch: assert property (p_no_stall_and_branch)
        else $error("P3b Violated: load and branch simultaneously in EX -- P3/P4 guards are now unsound");

    // -----------------------------------------------------------------
    // P5 -- A stall lasts exactly one cycle (no livelock)
    // RATIONALE: after the bubble, id_ex.mem_read == 0, so the hazard
    // term is unsatisfiable next cycle. This is the liveness/progress
    // property of the interlock -- the only thing standing between a
    // correct stall and a deadlocked machine.
    // VERDICT: [PROVEN] -- follows directly from P2.
    // -----------------------------------------------------------------
    property p_stall_duration;
        @(posedge clk) disable iff (reset)
        (load_use_hazard && !mem_stall) |=> !load_use_hazard;
    endproperty
    a_p5_stall_duration: assert property (p_stall_duration)
        else $error("P5 Violated: stall persisted for more than one cycle");

    //=================================================================
    //  CATEGORY B -- INTERFACE STABILITY
    //=================================================================

    // -----------------------------------------------------------------
    // P18 -- Normal PC increment
    // RATIONALE: with neither a stall nor a taken branch, the PC must
    // advance by exactly one word. Antecedent correctly excludes both
    // overriding conditions in the u_if priority chain.
    // |=> is mandatory here: pc is a register, so its new value is only
    // visible at the next sampling edge. An overlapping |-> would
    // compare the OLD pc against $past and fail every cycle.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_pc_normal_increment;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (!load_use_hazard && !ex_branch_taken && !mem_stall) |=> (pc == $past(pc) + 32'd4);
    endproperty
    a_p18_pc_normal_increment: assert property (p_pc_normal_increment)
        else $error("P18 Violated: PC did not increment by 4 on a normal cycle");

    // -----------------------------------------------------------------
    // P4 -- PC frozen during a stall  [FIXED]
    //
    // BUG IN THE ORIGINAL: no branch guard. The DUT's own comment says
    // it outright -- `pc <= branch_target;  // Jump always overrides a
    // stall`. branch_taken is tested FIRST in u_if, so on a coincident
    // stall+branch the PC moves and the original P4 fires. Same class of
    // defect as P3, same fix: guard here, prove the exclusion in P3b.
    // VERDICT: [PROVEN] given P3b
    // -----------------------------------------------------------------
    property p_pc_frozen_stall;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (load_use_hazard && !ex_branch_taken) |=> (pc == $past(pc));
    endproperty
    a_p4_pc_frozen_stall: assert property (p_pc_frozen_stall)
        else $error("P4 Violated: PC moved during a stall");

    // -----------------------------------------------------------------
    // P23 -- Taken branch redirects the PC
    // RATIONALE: branch_taken has top priority in u_if, so it must win
    // over both the stall and the increment. $past(ex_branch_target)
    // is required, not ex_branch_target: by the time the new pc is
    // observable, id_ex has already been bubbled and the live
    // ex_branch_target has collapsed to zero.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_branch_jump;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (ex_branch_taken && !mem_stall) |=> (pc == $past(ex_branch_target));
    endproperty
    a_p23_branch_jump: assert property (p_branch_jump)
        else $error("P23 Violated: PC did not take the branch target");

    // -----------------------------------------------------------------
    // P28 -- IF/ID advances: no instruction dropped or duplicated  [NEW]
    //
    // WHY IT WAS MISSING AND WHY IT MATTERS: the original suite had P3
    // ("IF/ID freezes when stalled") but no positive counterpart. A DUT
    // that simply never updated IF/ID at all would satisfy P3, P4, P5
    // and the whole forwarding category. This is the property that
    // pins the fetch->decode handoff: on every non-stalled, non-squashed
    // cycle IF/ID must capture EXACTLY what IF presented, once.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_if_id_progress;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (!load_use_hazard && !ex_branch_taken && !mem_stall) |=>
            (if_id.instr    == $past(if_instr)) &&
            (if_id.pc_plus4 == $past(if_pc_plus4));
    endproperty
    a_p28_if_id_progress: assert property (p_if_id_progress)
        else $error("P28 Violated: IF/ID did not capture the fetched instruction");

    //=================================================================
    //  CATEGORY C -- RESOURCE OWNERSHIP AND EXCLUSION
    //  (who is entitled to supply an operand, and with what value)
    //=================================================================

    // -----------------------------------------------------------------
    // P15 -- Forwarding activation (4 sub-properties)
    // RATIONALE: these mirror forwarding_unit.sv's if/else-if chain.
    // They ARE close to structural restatements -- but unlike the old
    // P1, the mirrored logic lives in a DIFFERENT module than the
    // assertion, so they check the top-level wiring (right rd compared
    // against the right rs/rt, right stage) rather than an expression
    // against itself. Kept for that reason; the real architectural
    // content is in P30 below.
    // |-> is correct: forward_a/b are combinational, same cycle.
    //
    // AUDIT NOTE on the MEM/WB variants: the exclusion clause omits
    // `ex_mem.dest_reg != 0`, so it is nominally STRONGER than the RTL's
    // else-if. It is nevertheless sound: the antecedent already requires
    // mem_wb.dest_reg == id_ex.rs and mem_wb.dest_reg != 0, hence
    // id_ex.rs != 0, hence ex_mem.dest_reg == id_ex.rs implies
    // ex_mem.dest_reg != 0. The term is added below anyway so the
    // property does not depend on that chain of reasoning.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_fwd_a_ex_mem;
        @(posedge clk) disable iff (reset)
        (ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) &&
         (ex_mem.dest_reg == id_ex.rs)) |-> (forward_a == 2'b10);
    endproperty
    a_p15a_fwd_a_ex_mem: assert property (p_fwd_a_ex_mem)
        else $error("P15 Violated: EX/MEM -> A forward not selected");

    property p_fwd_a_mem_wb;
        @(posedge clk) disable iff (reset)
        (mem_wb.reg_write && (mem_wb.dest_reg != 5'd0) &&
         (mem_wb.dest_reg == id_ex.rs) &&
         !(ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) &&
           (ex_mem.dest_reg == id_ex.rs))) |-> (forward_a == 2'b01);
    endproperty
    a_p15b_fwd_a_mem_wb: assert property (p_fwd_a_mem_wb)
        else $error("P15 Violated: MEM/WB -> A forward not selected");

    property p_fwd_b_ex_mem;
        @(posedge clk) disable iff (reset)
        (ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) &&
         (ex_mem.dest_reg == id_ex.rt)) |-> (forward_b == 2'b10);
    endproperty
    a_p15c_fwd_b_ex_mem: assert property (p_fwd_b_ex_mem)
        else $error("P15 Violated: EX/MEM -> B forward not selected");

    property p_fwd_b_mem_wb;
        @(posedge clk) disable iff (reset)
        (mem_wb.reg_write && (mem_wb.dest_reg != 5'd0) &&
         (mem_wb.dest_reg == id_ex.rt) &&
         !(ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) &&
           (ex_mem.dest_reg == id_ex.rt))) |-> (forward_b == 2'b01);
    endproperty
    a_p15d_fwd_b_mem_wb: assert property (p_fwd_b_mem_wb)
        else $error("P15 Violated: MEM/WB -> B forward not selected");

    // -----------------------------------------------------------------
    // P6 -- Forwarding priority: EX/MEM beats MEM/WB
    // RATIONALE: when two in-flight instructions both write the source
    // register, the YOUNGER one (EX/MEM) holds the architecturally
    // current value. Getting this backwards is the classic
    // write-after-write forwarding bug and produces a value that is one
    // instruction stale -- undetectable by P15 alone.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_fwd_a_priority;
        @(posedge clk) disable iff (reset)
        (ex_mem.reg_write && mem_wb.reg_write &&
         (ex_mem.dest_reg == id_ex.rs) && (mem_wb.dest_reg == id_ex.rs) &&
         (id_ex.rs != 5'd0)) |-> (forward_a == 2'b10);
    endproperty
    a_p6a_fwd_a_priority: assert property (p_fwd_a_priority)
        else $error("P6 Violated: A forwarding priority inverted");

    property p_fwd_b_priority;
        @(posedge clk) disable iff (reset)
        (ex_mem.reg_write && mem_wb.reg_write &&
         (ex_mem.dest_reg == id_ex.rt) && (mem_wb.dest_reg == id_ex.rt) &&
         (id_ex.rt != 5'd0)) |-> (forward_b == 2'b10);
    endproperty
    a_p6b_fwd_b_priority: assert property (p_fwd_b_priority)
        else $error("P6 Violated: B forwarding priority inverted");

    // -----------------------------------------------------------------
    // P22 -- Negative forwarding: never forward from a non-writer
    // RATIONALE: SW and JZ carry a dest_reg field that is simply
    // meaningless. Forwarding from them injects an address or an
    // unrelated ALU result into a later operand. reg_write is the only
    // thing that makes dest_reg trustworthy.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_fwd_a_negative_ex_mem;
        @(posedge clk) disable iff (reset)
        !ex_mem.reg_write |-> (forward_a != 2'b10);
    endproperty
    a_p22a: assert property (p_fwd_a_negative_ex_mem)
        else $error("P22 Violated: A forwarded from EX/MEM with reg_write=0");

    property p_fwd_a_negative_mem_wb;
        @(posedge clk) disable iff (reset)
        !mem_wb.reg_write |-> (forward_a != 2'b01);
    endproperty
    a_p22b: assert property (p_fwd_a_negative_mem_wb)
        else $error("P22 Violated: A forwarded from MEM/WB with reg_write=0");

    property p_fwd_b_negative_ex_mem;
        @(posedge clk) disable iff (reset)
        !ex_mem.reg_write |-> (forward_b != 2'b10);
    endproperty
    a_p22c: assert property (p_fwd_b_negative_ex_mem)
        else $error("P22 Violated: B forwarded from EX/MEM with reg_write=0");

    property p_fwd_b_negative_mem_wb;
        @(posedge clk) disable iff (reset)
        !mem_wb.reg_write |-> (forward_b != 2'b01);
    endproperty
    a_p22d: assert property (p_fwd_b_negative_mem_wb)
        else $error("P22 Violated: B forwarded from MEM/WB with reg_write=0");

    // -----------------------------------------------------------------
    // P24 -- $zero forwarding trap
    // RATIONALE: dest_reg == 0 happens constantly in this design --
    // a flushed IF/ID reads 32'h0, which decodes as R-type `add r0,r0,r0`
    // with reg_write=1. Without the dest_reg!=0 guard those phantom NOPs
    // would forward zero over live operands. This property is what makes
    // "flush by writing 32'h0" a safe idiom.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_fwd_zero_ex_mem;
        @(posedge clk) disable iff (reset)
        (ex_mem.dest_reg == 5'd0) |-> (forward_a != 2'b10 && forward_b != 2'b10);
    endproperty
    a_p24a: assert property (p_fwd_zero_ex_mem)
        else $error("P24 Violated: forwarding $zero from EX/MEM");

    property p_fwd_zero_mem_wb;
        @(posedge clk) disable iff (reset)
        (mem_wb.dest_reg == 5'd0) |-> (forward_a != 2'b01 && forward_b != 2'b01);
    endproperty
    a_p24b: assert property (p_fwd_zero_mem_wb)
        else $error("P24 Violated: forwarding $zero from MEM/WB");

    // -----------------------------------------------------------------
    // P29 -- Never forward a load result out of EX/MEM  [NEW]
    //
    // THE MOST IMPORTANT PROPERTY IN THIS FILE, and it was absent.
    //
    // EX/MEM carries alu_result, which for a load is the ADDRESS. The
    // loaded word does not exist until MEM/WB. If the load-use interlock
    // ever fails to fire, the forwarding unit will happily select
    // forward_* = 2'b10 and hand the dependent instruction an address
    // where it expects data -- silently, with no X and no bounds error.
    //
    // Every other hazard property here (P1..P5) checks the DETECTION
    // logic. This one checks the CONSEQUENCE the detection logic exists
    // to guarantee, and it does so without referencing load_use_hazard
    // at all. It is the single assertion that would survive someone
    // deleting the hazard unit and rewriting P1 to match.
    // VERDICT: [PROVEN] -- guaranteed by the one-cycle interlock.
    // -----------------------------------------------------------------
    // Split by operand and guarded by liveness (see ex_uses_a/ex_uses_b).
    // SOUNDNESS ARGUMENT: suppose forward_a == 2'b10 while a load sits in
    // MEM. Then ex_mem.dest_reg == id_ex.rs and is non-zero. One cycle
    // earlier that instruction was in ID with the load in EX; every
    // opcode in this ISA reads rs, so the hazard term was satisfied and
    // the instruction was bubbled -- making ex_uses_a false. The two
    // cannot hold together. The same argument runs for operand B via
    // m_uses_rt, which is true exactly for R-type and SW, which is
    // exactly when ex_uses_b is true.
    property p_no_fwd_load_a;
        @(posedge clk) disable iff (reset)
        (ex_mem.mem_to_reg && ex_uses_a) |-> (forward_a != 2'b10);
    endproperty
    a_p29a_no_fwd_load_a: assert property (p_no_fwd_load_a)
        else $error("P29 Violated: operand A took a load ADDRESS from EX/MEM -- interlock has a hole");

    property p_no_fwd_load_b;
        @(posedge clk) disable iff (reset)
        (ex_mem.mem_to_reg && ex_uses_b) |-> (forward_b != 2'b10);
    endproperty
    a_p29b_no_fwd_load_b: assert property (p_no_fwd_load_b)
        else $error("P29 Violated: operand B took a load ADDRESS from EX/MEM -- interlock has a hole");

    // -----------------------------------------------------------------
    // P30 -- No stale operand: a pending write MUST be forwarded  [NEW]
    //
    // WHY IT WAS MISSING AND WHY IT MATTERS: P15/P6/P22/P24 all describe
    // the forwarding unit's structure -- "given these comparator inputs,
    // produce this select". None of them state the REQUIREMENT the unit
    // exists to satisfy: an instruction in EX must never consume the
    // register-file copy of a register that an in-flight instruction is
    // still going to write. P30 is that requirement, expressed as
    // negative space (forward != 00), so it holds no matter how the
    // forwarding unit is restructured.
    //
    // This is also the property that generalises: it is exactly the
    // obligation Anvil's type system is meant to discharge statically,
    // which makes it the right one to cite in the Part-C comparison.
    //
    // FULL DISCLOSURE: for THIS forwarding unit, P30 is logically implied
    // by P15a/P15b -- it cannot fail unless P15 already has. It is kept
    // anyway because the implication runs one way only: P15 is phrased in
    // terms of the unit's comparator structure and dies the moment that
    // structure changes, whereas P30 is phrased purely in terms of
    // in-flight writes and survives any reimplementation. It is the
    // requirement; P15 is one implementation of it.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_no_stale_operand_a;
        @(posedge clk) disable iff (reset)
        ((id_ex.rs != 5'd0) &&
         ((ex_mem.reg_write && (ex_mem.dest_reg == id_ex.rs)) ||
          (mem_wb.reg_write && (mem_wb.dest_reg == id_ex.rs))))
        |-> (forward_a != 2'b00);
    endproperty
    a_p30a_no_stale_operand_a: assert property (p_no_stale_operand_a)
        else $error("P30 Violated: operand A read stale regfile value with a write in flight");

    property p_no_stale_operand_b;
        @(posedge clk) disable iff (reset)
        ((id_ex.rt != 5'd0) &&
         ((ex_mem.reg_write && (ex_mem.dest_reg == id_ex.rt)) ||
          (mem_wb.reg_write && (mem_wb.dest_reg == id_ex.rt))))
        |-> (forward_b != 2'b00);
    endproperty
    a_p30b_no_stale_operand_b: assert property (p_no_stale_operand_b)
        else $error("P30 Violated: operand B read stale regfile value with a write in flight");

    // -----------------------------------------------------------------
    // P33 -- A forwarded operand equals the value the register file
    //        will eventually hold for that instruction          [NEW]
    //
    // This is the project brief's FIRST suggested property, and neither the
    // original suite nor P15/P22/P24/P29/P30 contained it. Every one of those
    // reasons about the forwarding SELECT -- which mux input is chosen. None
    // reasons about the VALUE that arrives at the ALU.
    //
    // WHAT IT PROTECTS: the actual dataflow contract of forwarding. The
    // architecturally correct operand is the value the youngest older producer
    // will write to the register file. For EX/MEM that value is NOT
    // ex_mem.alu_result in general -- for a load it is the word coming back
    // from memory -- so this property is written in terms of the eventual
    // writeback value and lets the mux be wrong.
    //
    // WHAT SLIPS PAST WITHOUT IT: any defect between the select and the ALU
    // input -- a mux arm wired to the wrong stage, EX/MEM forwarding the
    // address of a load rather than its data, a sign/width mismatch on the
    // bypass path, or a correct select feeding a stale register. P15 would
    // still pass on all of them, because P15 only ever looks at forward_a/b.
    //
    // HOW A VIOLATION SHOWS UP: the assertion fires in EX, one to two cycles
    // BEFORE the wrong value is committed, naming the operand. Without it the
    // symptom is a wrong architectural register several cycles later, or
    // nothing at all until the end-to-end equivalence check in
    // tb_equivalence.sv reports a mismatched final state with no cycle to
    // blame.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------

    // The value EX/MEM will eventually write to the register file.
    // Deliberately reconstructed here rather than taken from the DUT: for a
    // load this is the memory word, while the forwarding mux offers the
    // address. That difference is the whole point of the property.
    logic [31:0] ex_mem_wb_value;
    assign ex_mem_wb_value = ex_mem.mem_to_reg ? mem_read_data : ex_mem.alu_result;

    // P33 AS SHIPPED IS UNSOUND -- retired, replaced by the guarded P38
    // in the AUDIT ADDITIONS block below.  Formal counterexample (BMC
    // k=5, symbolic program) and the reasoning are recorded there.  The
    // missing term is the ex_uses_a / ex_uses_b liveness guard that P29
    // already carries.

    // -----------------------------------------------------------------
    // P25 -- Negative bubble: no spurious flush  [STRENGTHENED]
    // RATIONALE: the dual of P2. Without it, a DUT that bubbled every
    // cycle would satisfy P1..P5 and P8 and simply never execute
    // anything. Extended from rs/rt to the captured operand values so it
    // also covers the register-file read path into ID/EX.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_negative_bubble;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (!load_use_hazard && !ex_branch_taken && !mem_stall) |=>
            (id_ex.rs  == $past(id_rs))       &&
            (id_ex.rt  == $past(id_rt))       &&
            (id_ex.rd1 == $past(id_rd1_wire)) &&
            (id_ex.rd2 == $past(id_rd2_wire));
    endproperty
    a_p25_negative_bubble: assert property (p_negative_bubble)
        else $error("P25 Violated: spurious bubble or lost operand capture in ID/EX");

    // -----------------------------------------------------------------
    // P26 -- $zero reads as zero into ID/EX
    // RATIONALE: split into two independent assertions. The original
    // combined them with the property-level `and`, which is legal but
    // reports a single failure for either half -- worse debug, no
    // semantic gain.
    // NOTE: this covers the READ path only. The architectural invariant
    // (regs[0] is never written) is checked separately by P31 in
    // mips_regfile_sva, bound into register_file.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_zero_rs;
        @(posedge clk) disable iff (reset)
        (id_ex.rs == 5'd0) |-> (id_ex.rd1 == 32'd0);
    endproperty
    a_p26a_zero_rs: assert property (p_zero_rs)
        else $error("P26 Violated: rs==$zero but rd1 != 0");

    property p_zero_rt;
        @(posedge clk) disable iff (reset)
        (id_ex.rt == 5'd0) |-> (id_ex.rd2 == 32'd0);
    endproperty
    a_p26b_zero_rt: assert property (p_zero_rt)
        else $error("P26 Violated: rt==$zero but rd2 != 0");

    //=================================================================
    //  CATEGORY D -- TRANSACTION-LEVEL : BRANCH SQUASH
    //=================================================================

    // -----------------------------------------------------------------
    // P8 -- Branch squash clears both wrong-path slots  [STRENGTHENED]
    //
    // TIMING DERIVATION (why exactly two slots, no delay slot):
    //   cycle t   : branch B resolves in EX (id_ex holds B).
    //               IF/ID holds B+4 (wrong path). PC is at B+8.
    //   cycle t+1 : if_id <= '0    kills B+4
    //               id_ex <= '0    kills the decode of B+4
    //               pc    <= target
    // So exactly the one wrong-path instruction that was fetched is
    // killed, in both the registers it occupies. This ISA has NO
    // architectural delay slot -- squash is total, not partial.
    //
    // Strengthened from `if_id.instr == 32'd0` to `if_id == '0`: leaving
    // a stale pc_plus4 behind is invisible today only because nothing
    // consumes it, which is exactly the kind of latent coupling an
    // assertion should pin down.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_branch_squash;
        @(posedge clk) disable iff (reset)
        (ex_branch_taken && !mem_stall) |=> (id_ex == '0) && (if_id == '0);
    endproperty
    a_p8_branch_squash: assert property (p_branch_squash)
        else $error("P8 Violated: pipeline not fully squashed after a taken branch");

    // -----------------------------------------------------------------
    // P8b -- A squashed instruction has no architectural side effect [NEW]
    //
    // WHY IT MATTERS: P8 checks that the pipeline registers were zeroed.
    // That is a statement about the FLUSH MECHANISM. P8b checks the thing
    // you actually care about -- that nothing on the wrong path ever
    // reaches the register file or data memory. It holds two cycles
    // deep because the zeroed id_ex has to drain through EX/MEM.
    // A flush that zeroed if_id but not id_ex would pass a weakened P8
    // and still commit a wrong-path store; P8b catches that directly.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    // [REWRITTEN for backpressure] The obligation is two PIPELINE
    // ADVANCES deep, not two clock cycles.  With a memory stall inside
    // the squash window the old `bt |=> X ##1 X` form checks the wrong
    // cycles and fires on a frozen, perfectly legitimate EX/MEM.
    // squash_age counts advances, so the window stretches with the stall
    // instead of sliding off it.  Side benefit: no `##N`, so it runs
    // under Verilator, which does not implement cycle delays in
    // sequences through at least 5.036.
    property p_squash_no_side_effect;
        @(posedge clk) disable iff (reset)
        (squash_age != 2'd0) |-> (!ex_mem.reg_write && !ex_mem.mem_write);
    endproperty
    a_p8b_squash_no_side_effect: assert property (p_squash_no_side_effect)
        else $error("P8b Violated: a wrong-path instruction reached MEM/WB after a branch");

    //=================================================================
    //  ENVIRONMENT ASSUMPTIONS -- BOUNDS AND ALIGNMENT
    //  (checkers, NOT invariants of this RTL -- read the note below)
    //=================================================================
    //
    //  READ THIS BEFORE QUOTING THE PROPERTIES BELOW.
    //
    //  P19, P17 and P27 are NOT invariants of this RTL. The design
    //  contains no bounds logic, no alignment logic and no exception
    //  mechanism. They pass in the supplied 22-cycle simulation because
    //  the test program happens to stay inside the legal ranges. Under a
    //  formal tool with an unconstrained instruction memory every one of
    //  them produces a counterexample in a handful of steps.
    //
    //  They are kept, and deliberately labelled [CHECKER], because that
    //  is precisely their value for this project: they mark the exact
    //  boundary where the hand-written specification stops being a proof
    //  and starts being a test. That boundary is the subject of the
    //  Part-C comparison, so it should be visible in the code, not
    //  buried in a report.
    //=================================================================

    localparam int IMEM_BYTES = 1024;   // imem[0:255] words
    localparam int DMEM_BYTES = 1024;   // dmem[0:1023] bytes

    // -----------------------------------------------------------------
    // P19 -- PC stays inside instruction memory
    // STATUS: [CHECKER] -- NOT provable. Two independent reasons:
    //   (1) u_if increments the PC forever; nothing wraps or halts it.
    //       This run only reaches ~0x50 because it is 22 cycles long.
    //   (2) ex_branch_target = {9'd0, id_ex.addr21, 2'b00} spans 23 bits,
    //       i.e. up to 0x7FFFFC -- 8192x the size of imem. A single JZ
    //       with a large immediate leaves the array immediately.
    // FETCH INDEX: FIXED, AND WHY P19 STILL MATTERS.  The fetch used to
    // read `imem[pc[31:2]]` -- a 30-bit index into a 256-entry array,
    // i.e. an out-of-range access for any PC >= 1 KiB (X in simulation,
    // undefined in synthesis).  It is now `imem[pc[IAW+1:2]]`, the
    // array's own address width.
    //   That makes fetch TOTAL, not CORRECT.  Neither reason (1) nor (2)
    // above has gone away; what changed is the CONSEQUENCE.  A runaway
    // PC no longer returns X -- it silently ALIASES back into the
    // program and executes whatever word it lands on.  An X would at
    // least have propagated somewhere visible; aliasing propagates
    // nothing.  So P19 is now the ONLY thing in the suite that can
    // detect a PC leaving the program, and it is a stronger reason to
    // keep the property than the one it replaced.
    // REMAINING RTL FIX: a trap or a halt.  This ISA subset has no
    // exception mechanism to hang one on, which is the honest reason it
    // is not implemented rather than an oversight.
    // -----------------------------------------------------------------
    property p_pc_bounds;
        @(posedge clk) disable iff (reset)
        pc < IMEM_BYTES;
    endproperty
    a_p19_pc_bounds: assert property (p_pc_bounds)
        else $error("P19 Violated: PC left instruction memory (design has no bound -- see notes)");

    // -----------------------------------------------------------------
    // P19b -- Branch target is inside instruction memory  [NEW]
    // RATIONALE: isolates cause (2) above from cause (1). When P19 fires,
    // P19b tells you instantly whether an immediate field or plain
    // run-off-the-end is responsible. Without it, the two failure modes
    // are indistinguishable from the assertion log.
    // STATUS: [CHECKER]
    // -----------------------------------------------------------------
    property p_branch_target_bounds;
        @(posedge clk) disable iff (reset)
        ex_branch_taken |-> (ex_branch_target < IMEM_BYTES);
    endproperty
    a_p19b_branch_target_bounds: assert property (p_branch_target_bounds)
        else $error("P19b Violated: branch target outside imem (addr21 is 21 bits wide, imem is 8)");

    // -----------------------------------------------------------------
    // P12 -- PC is word aligned
    // STATUS: [PROVEN] -- and it is the one bounds-family property that
    // genuinely is. Every writer of pc contributes alignment: reset gives
    // 0, the increment adds 4, and the branch target is built as
    // {..., 2'b00}. Alignment is structural here, unlike range.
    // -----------------------------------------------------------------
    property p_pc_alignment;
        @(posedge clk) disable iff (reset)
        pc[1:0] == 2'b00;
    endproperty
    a_p12_pc_alignment: assert property (p_pc_alignment)
        else $error("P12 Violated: PC is not 4-byte aligned");

    // -----------------------------------------------------------------
    // P17 -- Data memory access is in range
    // STATUS: [CHECKER]. The threshold 1021 is correct (a word access
    // touches alu_result .. alu_result+3, last legal byte is 1023).
    //
    // THE RTL DEFECT THIS PROPERTY USED TO EXPOSE IS NOW FIXED.  The
    // MEM stage used to index `dmem[ex_mem.alu_result[11:0]]` -- a
    // TWELVE-bit index (0..4095) into a 1024-byte array, with the
    // +1/+2/+3 terms computed in 12-bit arithmetic so they wrapped at
    // 4096.  data_memory now derives its lanes from addr[AW-1:0] with
    // AW = $clog2(DEPTH), so the access is in range by construction.
    // As with P19, that makes the access TOTAL rather than CORRECT: an
    // out-of-range effective address now aliases silently instead of
    // reading off the end, and P17 is what flags it.  The guard is
    // `dmem_req`, the actual transaction, rather than the old
    // `mem_read || mem_write` -- the pre-backpressure design read dmem
    // unconditionally every cycle, so the old guard did not cover the
    // access it was written for.
    // -----------------------------------------------------------------
    property p_mem_bounds;
        @(posedge clk) disable iff (reset)
        dmem_req |-> (ex_mem.alu_result < (DMEM_BYTES - 3));
    endproperty
    a_p17_mem_bounds: assert property (p_mem_bounds)
        else $error("P17 Violated: data memory access out of bounds");

    // -----------------------------------------------------------------
    // P27 -- Data memory access is word aligned
    // STATUS: [CHECKER]. The effective address is rs + sign-extended
    // imm16 with no alignment check anywhere, and this ISA subset has no
    // misaligned-access exception. `lw r1, 1(r0)` is legal to write and
    // produces a silently misaligned 4-byte read. The property is the
    // only thing that would flag it.
    // -----------------------------------------------------------------
    property p_mem_alignment;
        @(posedge clk) disable iff (reset)
        dmem_req |-> (ex_mem.alu_result[1:0] == 2'b00);
    endproperty
    a_p27_mem_alignment: assert property (p_mem_alignment)
        else $error("P27 Violated: data memory access is not word aligned");


    //=================================================================
    //  BACKPRESSURE INTERFACE  (P41 -- P44)
    //  These four turn "backpressure declared" into "backpressure
    //  specified".  They are the interface-stability and resource-
    //  ownership half of the new memory contract.
    //=================================================================

    // -----------------------------------------------------------------
    // P41 -- A memory stall dominates the front-end controls
    // The dual of P1b for the other stall source.  The if_branch_taken
    // term is the one that matters: u_if tests branch_taken BEFORE
    // pc_write, so a coincident stall and taken branch would move the PC
    // while IF/ID is frozen and the wrong-path instruction survives.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_mem_stall_drives_controls;
        @(posedge clk) disable iff (reset)
        mem_stall |-> (!pc_write && !if_id_write && !if_branch_taken);
    endproperty
    a_p41_mem_stall_controls: assert property (p_mem_stall_drives_controls)
        else $error("P41 Violated: memory stall did not hold the front end");

    // -----------------------------------------------------------------
    // P42 -- A request holds stable until it is accepted
    // The classic valid/ready obligation the requester owes the memory.
    // A requester that re-drove addr or wdata mid-flight would have the
    // store land at the wrong address with no symptom until the value is
    // read back, possibly never.  It also pins the no-combinational-loop
    // rule behaviourally: req cannot withdraw in response to ready.
    // VERDICT: [PROVEN] -- follows from EX/MEM being frozen
    // -----------------------------------------------------------------
    property p_req_stable_until_ready;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (dmem_req && !dmem_ready) |=>
            (dmem_req && (dmem_we    == $past(dmem_we))   &&
                         (dmem_addr  == $past(dmem_addr)) &&
                         (dmem_wdata == $past(dmem_wdata)));
    endproperty
    a_p42_req_stable: assert property (p_req_stable_until_ready)
        else $error("P42 Violated: request changed while in flight");

    // -----------------------------------------------------------------
    // P43 -- A memory stall freezes the whole pipeline
    // The entire correctness argument for backpressure, in one property.
    // Stated over the architectural registers rather than the enable
    // terms, so it survives any rewrite of the stall logic -- and so it
    // catches the specific bug of BUBBLING MEM/WB instead of freezing
    // it, which silently drops a MEM/WB->EX bypass for an instruction
    // already in flight.  That defect is invisible to P30 and P38,
    // because those read mem_wb too and go wrong with it.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_stall_freezes_pipeline;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        mem_stall |=> (pc     == $past(pc))     &&
                      (if_id  == $past(if_id))  &&
                      (id_ex  == $past(id_ex))  &&
                      (ex_mem == $past(ex_mem)) &&
                      (mem_wb == $past(mem_wb));
    endproperty
    a_p43_stall_freezes: assert property (p_stall_freezes_pipeline)
        else $error("P43 Violated: pipeline state moved during a memory stall");

    // -----------------------------------------------------------------
    // P44 -- A memory stall is bounded (no deadlock)
    // The liveness property of the interface, and the only one here that
    // distinguishes a working handshake from one that has locked up.  A
    // design computing mem_stall as ~dmem_ready instead of
    // dmem_req & ~dmem_ready deadlocks the first time the memory is idle
    // and not asserting ready; every safety property in this file stays
    // silent, because a frozen pipeline violates none of them.
    // VERDICT: [PROVEN] for the bundled data_memory.  If the memory ever
    // becomes external this becomes an ASSUME on the environment and the
    // matching assertion lives on the memory side (P44m).
    // -----------------------------------------------------------------
    property p_bounded_stall;
        @(posedge clk) disable iff (reset)
        (stall_cnt <= MAX_STALL);
    endproperty
    a_p44_bounded_stall: assert property (p_bounded_stall)
        else $error("P44 Violated: memory stall exceeded the contract bound -- deadlock");

    //=================================================================
    //  DATA PLANE  (P34 -- P39a)
    //  The suite specifies the control plane completely and says almost
    //  nothing about a value once it has left EX.  Measured: eight
    //  single-line RTL mutations in the MEM/WB/store path are invisible
    //  to the original set even under unbounded formal with a symbolic
    //  program.  None of these restates an RTL line: each crosses a
    //  stage boundary and reconstructs its reference rather than reading
    //  back the mux it is meant to police.
    //=================================================================

    // Architecturally current value of rs / rt: the value the youngest
    // older producer will write to the register file.
    logic [31:0] arch_rs_value, arch_rt_value;
    assign arch_rs_value =
        (ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) &&
         (ex_mem.dest_reg == id_ex.rs)) ? ex_mem_wb_value :
        (mem_wb.reg_write && (mem_wb.dest_reg != 5'd0) &&
         (mem_wb.dest_reg == id_ex.rs)) ? wb_data : id_ex.rd1;
    assign arch_rt_value =
        (ex_mem.reg_write && (ex_mem.dest_reg != 5'd0) &&
         (ex_mem.dest_reg == id_ex.rt)) ? ex_mem_wb_value :
        (mem_wb.reg_write && (mem_wb.dest_reg != 5'd0) &&
         (mem_wb.dest_reg == id_ex.rt)) ? wb_data : id_ex.rd2;

    // -----------------------------------------------------------------
    // P34a -- MEM->WB neither drops, duplicates nor re-tags a commit
    // The back-end counterpart of P28, which the suite had for IF->ID
    // and for nothing else.  Only meaningful on an ADVANCE: during a
    // stall MEM/WB deliberately holds while EX/MEM also holds.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_mem_wb_handoff;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        !$past(mem_stall) |->
            (mem_wb.reg_write == $past(ex_mem.reg_write)) &&
            (!mem_wb.reg_write || (mem_wb.dest_reg == $past(ex_mem.dest_reg)));
    endproperty
    a_p34a_mem_wb_handoff: assert property (p_mem_wb_handoff)
        else $error("P34a Violated: MEM->WB dropped, duplicated or re-tagged a commit");

    // -----------------------------------------------------------------
    // P34b -- A commit happens exactly once, however long memory stalls
    // MEM/WB is frozen across a stall rather than bubbled, so without
    // wb_done the register file would be written once per stall cycle.
    // Today that write is idempotent and therefore invisible; it stops
    // being idempotent the moment WB gains any other side effect (a CSR,
    // a perf counter, a scoreboard pop).  This is the transaction-level
    // property that makes the freeze safe rather than accidentally safe.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_commit_exactly_once;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        $past(mem_stall) |-> !rf_write_en;
    endproperty
    a_p34b_commit_once: assert property (p_commit_exactly_once)
        else $error("P34b Violated: a writeback committed twice across a memory stall");

    // -----------------------------------------------------------------
    // P35 / P35b -- a load commits memory, an ALU op commits the ALU
    // P38 uses wb_data as its reference and therefore cannot police
    // wb_data itself; this pair is what does.  Guarded on the advance:
    // across a stall ex_mem holds the in-flight memory op while mem_wb
    // holds an older, already-committed instruction, so $past(ex_mem)
    // and the current mem_wb belong to different instructions.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_load_commit_value;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (!$past(mem_stall) && $past(ex_mem.reg_write) && $past(ex_mem.mem_to_reg))
            |-> (wb_data == $past(mem_read_data));
    endproperty
    a_p35_load_commit_value: assert property (p_load_commit_value)
        else $error("P35 Violated: a load did not commit the word at its own address");

    property p_alu_commit_value;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        (!$past(mem_stall) && $past(ex_mem.reg_write) && !$past(ex_mem.mem_to_reg))
            |-> (wb_data == $past(ex_mem.alu_result));
    endproperty
    a_p35b_alu_commit_value: assert property (p_alu_commit_value)
        else $error("P35b Violated: an ALU instruction did not commit its ALU result");

    // -----------------------------------------------------------------
    // P36 -- The branch decision uses the architecturally current rs
    // The only control decision that depends on a data value, in a
    // machine with no misprediction recovery.  !mem_stall is required,
    // not cosmetic: ex_mem_wb_value reads mem_read_data, which the
    // memory drives to X while a load is in flight.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_branch_on_arch_value;
        @(posedge clk) disable iff (reset)
        (id_ex.branch_zero && !mem_stall) |->
            (ex_branch_taken == (arch_rs_value == 32'd0));
    endproperty
    a_p36_branch_on_arch_value: assert property (p_branch_on_arch_value)
        else $error("P36 Violated: branch resolved on a stale (un-forwarded) rs");

    // -----------------------------------------------------------------
    // P37 -- Nothing undefined ever reaches architectural state
    // Was a [CHECKER] for the old 12-bit dmem index.  That defect is
    // fixed by construction in data_memory, but the property has a new
    // and sharper job: u_dmem drives rdata to X while a read is in
    // flight, so P37 fires on any path that consumes read data before
    // the handshake completes.  4-state tools only -- Verilator and the
    // open-source formal image are 2-state and this is a no-op there.
    // VERDICT: [CHECKER]
    // -----------------------------------------------------------------
    property p_commit_defined;
        @(posedge clk) disable iff (reset)
        rf_write_en |-> !$isunknown({wb_data, mem_wb.dest_reg});
    endproperty
    a_p37_commit_defined: assert property (p_commit_defined)
        else $error("P37 Violated: an X/Z value is about to be written to the register file");

    // -----------------------------------------------------------------
    // P38 -- P33, repaired and stall-guarded
    // P33 as shipped lacks the ex_uses_a / ex_uses_b liveness guard that
    // P29 carries, and fires at BMC k=5 on an operand that is never
    // consumed: an unrecognised opcode in EX (all control bits zero, but
    // a live rs field), a load in MEM, forward_a=2'b10 selecting the
    // load's ADDRESS while the property's reference is the memory word.
    // Guarded it is sound: when the EX/MEM arm is selected and the
    // operand is live, P29 forces mem_to_reg=0, so ex_mem_wb_value ==
    // ex_mem.alu_result == what the RTL forwards.
    // VERDICT: [PROVEN] -- the unguarded form fails at k=5
    // -----------------------------------------------------------------
    property p_fwd_a_value_live;
        @(posedge clk) disable iff (reset)
        (ex_uses_a && !mem_stall) |-> (ex_forward_a_data == arch_rs_value);
    endproperty
    a_p38a_fwd_a_value_live: assert property (p_fwd_a_value_live)
        else $error("P38 Violated: live operand A is not the architectural value of rs");

    property p_fwd_b_value_live;
        @(posedge clk) disable iff (reset)
        (ex_uses_b && !mem_stall) |-> (ex_forward_b_data == arch_rt_value);
    endproperty
    a_p38b_fwd_b_value_live: assert property (p_fwd_b_value_live)
        else $error("P38 Violated: live operand B is not the architectural value of rt");

    // -----------------------------------------------------------------
    // P39a -- A store carries the architectural rt value into MEM
    // The requester half of the store path.  Split from the memory-side
    // check (P39b, in mips_dmem_sva) because with backpressure a store
    // may sit in EX/MEM for an arbitrary number of cycles, so no single
    // fixed-offset $past can span EX -> dmem any more.
    // Catches store data taken un-forwarded.  Nothing else in the suite
    // follows store data at all, and the scoreboard misses it whenever
    // the forwarded and un-forwarded values coincide -- which they do on
    // the current test program.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_store_data_arch;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        ($past(id_ex.mem_write) && !$past(mem_stall)) |->
            (ex_mem.write_data == $past(arch_rt_value));
    endproperty
    a_p39a_store_data_arch: assert property (p_store_data_arch)
        else $error("P39a Violated: store carried a stale (un-forwarded) rt");

    //=================================================================
    //  COVERAGE -- NON-VACUITY WITNESSES
    //=================================================================
    //  An implication whose antecedent never becomes true PASSES.
    //  In a 22-cycle run most of the forwarding properties above are at
    //  serious risk of passing vacuously, which would make "20/20 assertions
    //  passed" a meaningless claim in the report. These covers are the
    //  evidence that each interesting antecedent was actually reached.
    //  Any cover that does not hit is a hole in the STIMULUS, not the RTL.
    //=================================================================
    c_load_use_stall:   cover property (@(posedge clk) disable iff (reset) load_use_hazard);
    c_branch_taken:     cover property (@(posedge clk) disable iff (reset) ex_branch_taken);
    c_branch_not_taken: cover property (@(posedge clk) disable iff (reset)
                                        id_ex.branch_zero && !ex_branch_taken);
    c_fwd_a_ex_mem:     cover property (@(posedge clk) disable iff (reset) forward_a == 2'b10);
    c_fwd_a_mem_wb:     cover property (@(posedge clk) disable iff (reset) forward_a == 2'b01);
    c_fwd_b_ex_mem:     cover property (@(posedge clk) disable iff (reset) forward_b == 2'b10);
    c_fwd_b_mem_wb:     cover property (@(posedge clk) disable iff (reset) forward_b == 2'b01);
    c_fwd_priority:     cover property (@(posedge clk) disable iff (reset)
                                        ex_mem.reg_write && mem_wb.reg_write &&
                                        (ex_mem.dest_reg == id_ex.rs) &&
                                        (mem_wb.dest_reg == id_ex.rs) && (id_ex.rs != 5'd0));
    c_mem_write:        cover property (@(posedge clk) disable iff (reset) ex_mem.mem_write);
    c_mem_read:         cover property (@(posedge clk) disable iff (reset) ex_mem.mem_read);
    // The load-use pattern end to end: stall, then the dependent
    // instruction consumes the value from MEM/WB one cycle later.
    c_load_use_resolved: cover property (@(posedge clk) disable iff (reset)
                                         load_use_hazard ##2 (forward_a == 2'b01 || forward_b == 2'b01));

endmodule : mips_sva


//=====================================================================
//  mips_regfile_sva -- bound into register_file
//
//  P31 needs to see regs[0], which is a local variable of register_file
//  and therefore not reachable from a bind into mips_pipeline_processor
//  without an unpacked-array hierarchical select in a port expression.
//  Binding a second, tiny checker into register_file resolves the name
//  in the scope where it is declared -- portable and unambiguous.
//=====================================================================
module mips_regfile_sva (
    input logic        clk,
    input logic        reset,
    input logic        reg_write,
    input logic [4:0]  write_reg,
    input logic [31:0] zero_val,     // regs[0]
    // --- read ports, for P40 ---
    input logic [4:0]  read_reg1,
    input logic [4:0]  read_reg2,
    input logic [31:0] write_data,
    input logic [31:0] read_data1,
    input logic [31:0] read_data2
);

    // -----------------------------------------------------------------
    // P31 -- $zero is architecturally immutable  [NEW]
    //
    // WHY IT WAS MISSING: P26 checks that a READ of $zero returns zero,
    // but register_file has two independent mechanisms that could each
    // hide a bug in the other -- a read-port mux forcing 0 for index 0,
    // AND a write path that both guards `write_reg != 0` and
    // unconditionally re-writes `regs[0] <= 0` every cycle. With the
    // read mux in place, regs[0] could be corrupted and no existing
    // property would ever notice. P31 checks the state itself.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_zero_immutable;
        @(posedge clk) disable iff (reset)
        zero_val == 32'd0;
    endproperty
    a_p31_zero_immutable: assert property (p_zero_immutable)
        else $error("P31 Violated: register $zero has been corrupted");

    // -----------------------------------------------------------------
    // P32 -- $zero is never selected as a write destination  [NEW]
    // RATIONALE: the dual of P31 -- P31 checks the state, P32 checks the
    // attempt. Together they distinguish "the guard works" from "the
    // guard is never exercised". Note this asserts the DUT's own guard,
    // so it is a contract check on the write port, not a proof.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_no_write_to_zero;
        @(posedge clk) disable iff (reset)
        (reg_write && (write_reg == 5'd0)) |=> (zero_val == 32'd0);
    endproperty
    a_p32_no_write_to_zero: assert property (p_no_write_to_zero)
        else $error("P32 Violated: a write to $zero took effect");


    // -----------------------------------------------------------------
    // P40 -- The read port returns the value the file will hold
    // This pipeline REQUIRES write-through: an instruction that reads
    // stale in ID gets no second chance, because by the time it reaches
    // EX the MEM/WB producer has retired and no forwarding path covers
    // it.  ENABLE_BYPASS=0 is therefore an architectural defect, and it
    // is invisible to every other property in the suite -- confirmed:
    // that mutation survives symbolic-program formal against the whole
    // set.  Nothing else watches this port.
    // Unaffected by mem_stall: a pure combinational property of the
    // register file, on whatever cycle it is read.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_rf_bypass_rs;
        @(posedge clk) disable iff (reset)
        (reg_write && (write_reg != 5'd0) && (write_reg == read_reg1)) |->
            (read_data1 == write_data);
    endproperty
    a_p40a_rf_bypass_rs: assert property (p_rf_bypass_rs)
        else $error("P40 Violated: read port 1 returned a stale value across a write");

    property p_rf_bypass_rt;
        @(posedge clk) disable iff (reset)
        (reg_write && (write_reg != 5'd0) && (write_reg == read_reg2)) |->
            (read_data2 == write_data);
    endproperty
    a_p40b_rf_bypass_rt: assert property (p_rf_bypass_rt)
        else $error("P40 Violated: read port 2 returned a stale value across a write");

endmodule : mips_regfile_sva


//=====================================================================
//  mips_dmem_sva -- bound into data_memory.
//
//  The memory's half of the interface contract.  Stated here rather
//  than in mips_sva for the same reason P31 is: `mem` is a local
//  unpacked array and cannot be sliced in a bind port expression from
//  the processor's scope.
//=====================================================================
module mips_dmem_sva #(
    parameter int DEPTH = 1024
) (
    input logic        clk,
    input logic        reset,
    input logic        req,
    input logic        we,
    input logic        ready,
    input logic [31:0] addr,
    input logic [31:0] wdata,
    input logic [7:0]  mem_i [0:DEPTH-1]
);
    localparam int AW = $clog2(DEPTH);

    logic sva_past_ok;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) sva_past_ok <= 1'b0;
        else       sva_past_ok <= 1'b1;
    end

    function automatic logic [31:0] word_at(input logic [31:0] a);
        logic [AW-1:0] b;
        b = a[AW-1:0];
        word_at = {mem_i[b], mem_i[b + AW'(1)], mem_i[b + AW'(2)], mem_i[b + AW'(3)]};
    endfunction

    // -----------------------------------------------------------------
    // P39b -- An accepted store lands, whole and in the right lanes
    // The longest reach in the suite: from the accepted request into the
    // byte array, across the 32-to-4x8 lane split.  Catches a byte-lane
    // swap or an endianness error, and a write that lands at the wrong
    // address.  Measured: the shipped test program stores 0x00000014, so
    // swapping the two high (zero) lanes is invisible to the end-to-end
    // scoreboard.  Nothing but this property sees it.
    // Restricted to in-range addresses -- an out-of-range store wraps
    // (P17's subject), and this should report a store-path defect, not
    // that one a second time.
    // VERDICT: [PROVEN] for in-range stores
    // -----------------------------------------------------------------
    property p_store_lands;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        ($past(req) && $past(we) && $past(ready) &&
         ($past(addr) < (DEPTH - 3))) |->
            (word_at($past(addr)) == $past(wdata));
    endproperty
    a_p39b_store_lands: assert property (p_store_lands)
        else $error("P39b Violated: accepted store wrote the wrong data, lanes or address");

    // -----------------------------------------------------------------
    // P39c -- An in-flight store does not touch memory
    // The exactly-once half.  A memory that committed the write on every
    // cycle of a multi-cycle transaction is functionally invisible today
    // -- same address, same data -- and becomes a real bug the moment
    // the store path gains a read-modify-write (sub-word stores) or the
    // memory becomes a cache with dirty tracking.  It also catches a
    // write that commits BEFORE ready, which is a protocol violation
    // rather than an idempotent repeat.
    // VERDICT: [PROVEN]
    // -----------------------------------------------------------------
    property p_no_write_in_flight;
        @(posedge clk) disable iff (reset || !sva_past_ok)
        ($past(req) && $past(we) && !$past(ready) &&
         ($past(addr) < (DEPTH - 3))) |->
            (word_at($past(addr)) == $past(word_at(addr)));
    endproperty
    a_p39c_no_write_in_flight: assert property (p_no_write_in_flight)
        else $error("P39c Violated: memory changed before the transaction was accepted");

    // -----------------------------------------------------------------
    // P44m -- The memory grants every request within its contract bound
    // The memory's side of P44.  If the memory ever becomes external
    // this assertion stays with the model and P44 in mips_sva becomes
    // the matching assume on the environment.
    // VERDICT: [PROVEN] for this latency model
    // -----------------------------------------------------------------
    logic [3:0] grant_cnt;
    always_ff @(posedge clk or posedge reset) begin
        if (reset)                                   grant_cnt <= 4'd0;
        else if (req && !ready && grant_cnt != 4'hF) grant_cnt <= grant_cnt + 4'd1;
        else if (ready || !req)                      grant_cnt <= 4'd0;
    end

    property p_memory_grants;
        @(posedge clk) disable iff (reset)
        (grant_cnt <= 8);
    endproperty
    a_p44m_memory_grants: assert property (p_memory_grants)
        else $error("P44m Violated: memory did not grant a request within its contract bound");

endmodule : mips_dmem_sva
