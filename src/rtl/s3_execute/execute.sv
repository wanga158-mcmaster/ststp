`include "op_set.sv"

`ifndef _TYPES_H
`include "../lib/types.svh"
`endif

`include "../lib/dff.sv"


module execute (
    input logic clk,
    input logic rst_n,

    /* decode and execute interface */
    input d_e_WI d_in,

    /* execute and writeback interface */
    output e_w_WI e_out,

    /* writeback and execute interface, to be used in the future */
    input w_e_WI w_in,

    /* execute and data memory interface; forwarded to memory unit in advance */
    output logic [31:0] mem_addr_out, // memory address data
    output logic [31:0] mem_dat_out, //  memory data for sb, sh, sw etc
    output logic mem_read_en, // storage section read enable
    output logic mem_write_en, // storage section write enable

    input logic stall_in, // previous stage stall
    output logic stall_out // signal to next stage stall
);
    
    e_w_WI e_t;
    assign e_t.rd_ind = d_in.rd_ind;

    logic op_en1[128], op_en2[128];
    logic [31:0] rslt1[128], rslt2[128], src1[2], src2[2];
    logic [31:0] calc_addr;

    _add add1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[ADD]),

        .aer(rslt1[ADD])
    );
    _add add2(
        .a(src1[1]),
        .b(src2[1]),
        .en(op_en2[ADD]),

        .aer(rslt2[ADD])
    );
    _sub sub1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[SUB]),

        .aer(rslt1[SUB])
    );
    _xor xor1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[XOR]),

        .aer(rslt1[XOR])
    );
    _or or1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[OR]),

        .aer(rslt1[OR])
    );
    _and and1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[AND]),

        .aer(rslt1[AND])
    );
    _sll sll1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[SLL]),

        .aer(rslt1[SLL])
    );
    _srl srl1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[SRL]),

        .aer(rslt1[SRL])
    );
    _sra sra1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[SRA]),

        .aer(rslt1[SRA])
    );
    _slt slt1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[SLT]),

        .aer(rslt1[SLT])
    );
    _sltu sltu1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[SLTU]),

        .aer(rslt1[SLTU])
    );
    _eq eq1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[EQ]),

        .aer(rslt1[EQ])
    );
    _mul mul1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[MUL]),

        .aer(rslt1[MUL])
    );
    _div div1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[DIV]),

        .aer(rslt1[DIV]),
    );
    _rem rem1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en1[REM]),

        .aer(rslt1[REM])
    )

    logic r_tk;
    assign r_tk = op_spec[6];

    always_comb begin
        for (int i = 0; i < 2; ++i) begin
            src1[i] = 0;
            src2[i] = 0;
        end
        for (int i = 0; i < 128; ++i) begin
            op_en1[i] = 0;
            op_en2[i] = 0;
        end
        mem_addr_out = 0;
        mem_dat_out = 0;
        mem_read_en = 0; // reset mem write and read
        mem_write_en = 0;
        case (op_type)
            ARITHMETIC: begin // basic math
                case (op_spec[5:0]):
                    ADD: begin
                        op_en1[ADD] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[ADD];
                    end
                    SUB: begin
                        op_en1[SUB] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[SUB];
                    end
                    XOR: begin
                        op_en1[XOR] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[XOR];
                    end
                    OR: begin
                        op_en1[OR] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[OR];

                    end
                    AND: begin
                        op_en1[AND] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[AND];

                    end
                    SLL: begin
                        op_en1[SLL] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[SLL];

                    end
                    SRL: begin
                        op_en1[SRL] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[SRL];

                    end
                    SRA: begin
                        op_en1[SRA] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[SRA];

                    end
                    SLT: begin
                        op_en1[SLT] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[SLT];

                    end
                    SLTU: begin
                        op_en1[SLTU] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[SLTU];

                    end
                    MUL: begin
                        op_en1[MUL] = 1;
                        src1[8] = d_in.rs1_dat;
                        src2[8] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[MUL];

                    end
                    DIV: begin
                        op_en1[DIV] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[DIV];

                    end
                    REM: begin
                        op_en1[REM] = 1;
                        src1[0] = d_in.rs1_dat;
                        src2[0] = (~r_tk) ? d_in.rs2_dat : d_in.imm_val;
                        e_t.reg_dat = rslt1[REM];
                    end
                    default: begin
                    end
                endcase
            end
            MEMORY: begin // load and store
                src1[0] = d_in.rs1_dat;
                src2[0] = d_in.imm_val;
                op_en1[ADD] = 1;
                mem_addr_out = rslt1[0];
                case(op_spec)
                    LB: begin // lb
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    LH: begin // lh
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    LW: begin // lw
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    LBU: begin // lbu
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    LHU: begin // lhu
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    SB: begin // sb
                        mem_read_en = 0;
                        mem_write_en = 1;
                        mem_dat_out = {24{1'b0}, d_in.rs2_dat[7:0]};
                    end
                    SH: begin // sh
                        mem_read_en = 0;
                        mem_write_en = 1;
                        mem_dat_out = {16{1'b0}, d_in.rs2_dat[15:0]};
                    end
                    SW: begin // sw
                        mem_read_en = 0;
                        mem_write_en = 1;
                        mem_dat_out = d_in.rs2_dat;
                    end
                    default: begin
                    end
                endcase
            end
            BRANCH: begin // branch
                src1[1] = d_in.instr_addr;
                src2[1] = d_in.imm_val;
                op_en2[ADD] = 1;
                e_t.jmp_addr = rslt2[ADD];
                case (op_spec):
                    BEQ: begin
                        src1[0] = d_in.rs1_dat;
                        src2[0] = d_in.rs2_dat;
                        op_en1[EQ] = 1;
                        e_t.jmp_take = (&rslt1[EQ]);
                    end
                    BNE: begin
                        src1[0] = d_in.rs1_dat;
                        src2[0] = d_in.rs2_dat;
                        op_en1[EQ] = 1;
                        e_t.jmp_take = ~(&rslt1[EQ]);
                    end
                    BLT: begin
                        src1[0] = d_in.rs1_dat;
                        src2[0] = d_in.rs2_dat;
                        op_en1[SLT] = 1;
                        e_t.jmp_take = (&rslt1[SLT]);
                    end
                    BGE: begin
                        src1[0] = d_in.rs1_dat;
                        src2[0] = d_in.rs2_dat;
                        op_en1[SLT] = 1;
                        e_t.jmp_take = ~(&rslt1[SLT]);
                    end
                    BLTU: begin
                        src1[0] = d_in.rs1_dat;
                        src2[0] = d_in.rs2_dat;
                        op_en1[SLTU] = 1;
                        e_t.jmp_take = (&rslt1[SLTU]);
                    end
                    BGEU: begin
                        src1[0] = d_in.rs1_dat;
                        src2[0] = d_in.rs2_dat;
                        op_en1[SLTU] = 1;
                        e_t.jmp_take = ~(&rslt1[SLTU]);
                    end
                    default: begin
                    end
                endcase
            end
            JUMP: begin // jump
                src1[0] = 3'b100;
                src2[0] = d_in.instr_addr;
                op_en1[ADD] = 1;
                e_t.reg_dat = rslt1[0];
                e_t.jmp_tk = 1;
                case (op_spec):
                    JAL: begin
                        src1[1] = d_in.instr_addr;
                        src2[1] = d_in.imm_val;
                        op_en2[ADD] = 1;
                        e_t.jmp_addr = rslt2[ADD];
                    end
                    JALR: begin
                        src1[1] = d_in.rs1_dat;
                        rsc2[1] = d_in.imm_val;
                        op_en2[ADD] = 1;
                        e_t.jmp_addr = rslt2[ADD];
                    end
                    default: begin
                    end
                endcase
            end
            default: begin
            end
        endcase
    end

    d_register #(
        _W.($bits(e_w_WI))
    ) e_out_s (
        .clk(clk),
        .rst_n(rst_n),

        .flush(w_e.flush),
        .en(~stall_in),

        .din(e_t),
        .dout(e_out)
    );
    
    d_ff stall_out_s(
        .clk(clk),
        .rst_n(rst_n),
        
        .flush(0),
        .en(1),

        .din(stall_in | w_e.flush),
        .dout(stall_out)
    );

endmodule;

