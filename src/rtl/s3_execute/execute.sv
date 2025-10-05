module execute (
    input logic clk,
    input logic rst_n,

    input logic [31:0] instr_addr_in, // address of current instruction
    input logic [3:0] op_type,
    input logic [4:0] op_spec,

    input logic [4:0] rs1_ind,
    input logic [4:0] rs2_ind,
    input logic [4:0] rd_ind,
    input logic [31:0] rs1_dat,
    input logic [31:0] rs2_dat,
    input logic [31:0] imm,
    input logic r_type,

    output logic [3:0] op_type_out, // operation type out, unchanged
    output logic [4:0] op_spec_out, // operation spec out, unchanged
    output logic [4:0] rd_ind_out, // rd index out, unchanged
    output logic [31:0] rd_dat_out, // rd data
    output logic [31:0] jmp_addr_out, // jump pc address data
    output logic jmp_take // jump or not

    /* forwarded to memory unit in advance before clk posedge */
    output logic [31:0] mem_addr_out, // memory address data
    output logic [31:0] mem_dat_out, // store memory data
    output logic [31:0] mem_read_en, // data section read enable
    output logic [31:0] mem_write_en // data section write enable
);
    
    logic op_en[32];

    logic [31:0] rslt[32], src1[32], src2[32];
    logic [31:0] calc_addr;

    _add add1(
        .a(src1[0]),
        .b(src2[0]),
        .en(op_en[0]),

        .aer(rslt[0])
    );
    _add add2(
        .a(src1[11]),
        .b(src2[11]),
        .en(op_en[11]),

        .aer(rslt[11])
    );
    _sub sub1(
        .a(src1[1]),
        .b(src2[1]),
        .en(op_en[1]),

        .aer(rslt[1])
    );
    _xor xor1(
        .a(src1[2]),
        .b(src2[2]),
        .en(op_en[2]),

        .aer(rslt[2])
    );
    _or or1(
        .a(src1[3]),
        .b(src2[3]),
        .en(op_en[3]),

        .aer(rslt[3])
    );
    _and and1(
        .a(src1[4]),
        .b(src2[4]),
        .en(op_en[4]),

        .aer(rslt[4])
    );
    _sll sll1(
        .a(src1[5]),
        .b(src2[5]),
        .en(op_en[5]),

        .aer(rslt[5])
    );
    _srl srl1(
        .a(src1[6]),
        .b(src2[6]),
        .en(op_en[6]),

        .aer(rslt[6])
    );
    _sra sra1(
        .a(src1[7]),
        .b(src2[7]),
        .en(op_en[7]),

        .aer(rslt[7])
    );
    _slt slt1(
        .a(src1[8]),
        .b(src2[8]),
        .en(op_en[8]),

        .aer(rslt[8])
    );
    _sltu sltu1(
        .a(src1[9]),
        .b(src2[9]),
        .en(op_en[9]),

        .aer(rslt[9])
    );
    _eq eq1(
        .a(src1[10]),
        .b(src2[10]),
        .en(op_en[10]),

        .aer(rslt[10])
    );

    logic [31:0] rd_dat_out_t, jmp_addr_out_t;
    logic jmp_take_t;

    always_comb begin
        for (int i = 0; i < 32; ++i) begin // reset all ops and sources
                    op_en[i] = 0;
                    src1[i] = 0;
                    src2[i] = 0;
        end
        mem_read_en = 0; // reset mem write and read
        mem_write_en = 0;
        case (op_type)           
            3'b000: begin // basic math
                case (op_spec):
                    4'b0000: begin
                        op_en[0] = 1;
                        src1[0] = rs1_dat;
                        src2[0] = (~r_type) ? rs2_dat : imm;
                    end
                    4'b0001: begin
                        op_en[1] = 1;
                        src1[1] = rs1_dat;
                        src2[1] = (~r_type) ? rs2_dat : imm;
                    end
                    4'b0010: begin
                        op_en[2] = 1;
                        src1[2] = rs1_dat;
                        src2[2] = (~r_type) ? rs2_dat : imm;
                    end
                    4'b0011: begin
                        op_en[3] = 1;
                        src1[3] = rs1_dat;
                        src2[3] = (~r_type) ? rs2_dat : imm;
                    end
                    4'b0100: begin
                        op_en[4] = 1;
                        src1[4] = rs1_dat;
                        src2[4] = (~r_type) ? rs2_dat : imm;
                    end
                    4'b0101: begin
                        op_en[5] = 1;
                        src1[5] = rs1_dat;
                        src2[5] = (~r_type) ? rs2_dat : imm;
                    end
                    4'b0110: begin
                        op_en[6] = 1;
                        src1[6] = rs1_dat;
                        src2[6] = (~r_type) ? rs2_dat : imm;
                    end
                    4'b0111: begin
                        op_en[7] = 1;
                        src1[7] = rs1_dat;
                        src2[7] = (~r_type) ? rs2_dat : imm;
                    end
                    4'b1000: begin
                        op_en[8] = 1;
                        src1[8] = rs1_dat;
                        src2[8] = (~r_type) ? rs2_dat : imm;
                    end
                    default: begin
                    end
                endcase
            end
            3'b001: begin // load and store
                src1[0] = rs1_dat;
                src2[0] = imm;
                op_en[0] = 1;
                mem_addr_out = rslt[0];
                case(op_spec)
                    4'b0000: begin // lb
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    4'b0001: begin // lh
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    4'b0010: begin // lw
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    4'b0011: begin // lbu
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    4'b0100: begin // lhu
                        mem_read_en = 1;
                        mem_write_en = 0;
                    end
                    4'b0101: begin // sb
                        mem_read_en = 0;
                        mem_write_en = 1;
                        mem_dat_out = {24{1'b0}, rs2_dat[7:0]};
                    end
                    4'b0110: begin // sh
                        mem_read_en = 0;
                        mem_write_en = 1;
                        mem_dat_out = {16{1'b0}, rs2_dat[15:0]};
                    end
                    4'b0111: begin // sw
                        mem_read_en = 0;
                        mem_write_en = 1;
                        mem_dat_out = rs2_dat;
                    end
                    default: begin
                    end
                endcase
            end
            3'b010: begin // branch
                src1[0] = instr_addr_in;
                src2[0] = imm;
                op_en[0] = 1;
                jmp_addr_out_t = rslt[0];
                case (op_spec):
                    4'b0000: begin
                        src1[10] = rs1_dat;
                        src2[10] = rs2_dat;
                        op_en[10] = 1;
                        jmp_take_t = (&rslt[10]);
                    end
                    4'b0001: begin
                        src1[10] = rs1_dat;
                        src2[10] = rs2_dat;
                        op_en[10] = 1;
                        jmp_take_t = ~(&rslt[10]);
                    end
                    4'b0010: begin
                        src1[8] = rs1_dat;
                        src2[8] = rs2_dat;
                        op_en[8] = 1;
                        jmp_take_t = (&rslt[8]);
                    end
                    4'b0011: begin
                        src1[8] = rs1_dat;
                        src2[8] = rs2_dat;
                        op_en[8] = 1;
                        jmp_take_t = ~(&rslt[8]);
                    end
                    4'b0100: begin
                        src1[9] = rs1_dat;
                        src2[9] = rs2_dat;
                        op_en[9] = 1;
                        jmp_take_t = ~(&rslt[9]);
                    end
                    4'b0101: begin
                        src1[9] = rs1_dat;
                        src2[9] = rs2_dat;
                        op_en[9] = 1;
                        jmp_take_t = ~(&rslt[9]);
                    end
                    default: begin
                    end
                endcase
            end
            3'b011: begin // jump
                src1[0] = 3'b100;
                src2[0] = instr_addr_in;
                op_en[0] = 1;
                rd_dat_out_t = rslt[0];
                jmp_take_t = 1;
                case (op_spec):
                    3'b000: begin
                        src1[11] = instr_addr_in;
                        src2[11] = imm;
                        op_en[11] = 1;
                        jmp_addr_out_t = rslt[11];
                    end
                    3'b001: begin
                        src1[11] = rs1_dat;
                        rsc2[11] = imm;
                        op_en[11] = 1;
                        jmp_addr_out_t = rslt[11];
                    end
                    default: begin
                    end
                endcase
            end
            3'b100: begin // upper immediates
                case (op_spec)
                    3'b000: begin
                        src1[0] = 0;
                        src2[0] = imm;
                        op_en[0] = 1;
                        rd_dat_out_t = rslt[0];
                    end
                    3'b001: begin
                        src1[0] = instr_addr_in;
                        src2[0] = imm;
                        op_en[0] = 1;
                        rd_dat_out_t = rslt[0];
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
        ._W(4)
    ) op_type_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(op_type),
        .dout(op_type_out),
    );

    d_register #(
        ._W(5)
    ) op_spec_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(op_spec),
        .dout(op_spec_out),
    );

    d_register #(
        ._W(5)
    ) rd_ind_out_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(rd_ind),
        .dout(rd_ind_out),
    );

    d_register rd_dat_out_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),

        .din(rd_dat_out_t),
        .dout(rd_dat_out)
    );
    
    // d_register mem_addr_out_s(
    //     .clk(clk),
    //     .rst_n(rst_n),

    //     .en(),
    //     .flush(),

    //     .din(mem_addr_out_t),
    //     .dout(mem_addr_out)
    // );
    
    // d_register mem_dat_out_s(
    //     .clk(clk),
    //     .rst_n(rst_n),

    //     .en(),
    //     .flush(),

    //     .din(mem_dat_out_t),
    //     .dout(mem_dat_out)
    // );

    d_register jmp_addr_out_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),

        .din(jmp_addr_out_t),
        .dout(jmp_addr_out)
    );

    d_ff jmp_take_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),

        .din(jmp_take_t),
        .dout(jmp_take)
    );

endmodule;

