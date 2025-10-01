module main (
    input logic clk,
    input logic rst
)

    // program counter
    logic pc_rst_n;
    assign pc_rst_n = ~rst;

    logic [31:0] nxt_pc;
    logic [31:0] cur_pc;

    program_counter pc(
        .clk(clk),
        .rst_n(pc_rst_n),

        .nxt_inst_addr(nxt_pc);
        .inst_addr(cur_pc);
    );

    logic [31:0] nxt_pc1, cur_inst; // next instruction type 1, current instruction
    
    memory inst_mem(
        .clk(clk),
        .rst_n(1'b1),

        .read_en(1'b1), // always read
        .read_addr(cur_pc),
        .read_data(cur_inst),

        .write_en(1'b0), // never write
        .write_addr(),
        .write_data(),
    );

    // control unit
    logic pc_src;
    logic rslt_src;
    logic [1:0] imm_src; // immediate source
    logic alu_src;

    logic [3:0] alu_op;

    logic mem_write;
    logic reg_write;

    control_unit dcd(
        .op(cur_inst),

        .pc_src(pc_src),
        .rslt_src(rslt_src),
        .imm_src(imm_src),
        .alu_src(alu_src),

        .alu_op(alu_op),

        .mem_write(mem_write),
        .reg_write(reg_write)
    );

    // registers

    logic reg_rst_n;

    assign reg_rst_n = rst_n;

    logic [4:0] rs1_ind, rs2_ind, rd_ind;
    assign rs1_ind = cur_inst[19:15];
    assign rs2_ind = cur_inst[24:20];
    assign rd_ind = cur_inst[11:7];

    logic [31:0] rs1_data, rs2_data;

    logic [4:0] rs_inds[2];
    logic [31:0] rs_data[2];

    logic reg_write_en;

    assign rs_ind[0] = rs1_ind;
    assign rs_ind[1] = rs2_ind;
    
    assign rs1_data = rs_data[0];
    assign rs2_data = rs_data[1];

    register_file regs(
        .clk(clk),
        .rst_n(reg_rst_n),

        .read_en(1'b1),
        .read_addr(rs_inds),
        .read_data(rs_data),

        .write_en(reg_write),
        .write_addr(rd_ind),
        .write_data(rd_data)
    );

    // sign extender
    logic [24:0] imm_val;
    assign imm_val = inst[31:7];

    logic [31:0] ext_imm_val;

    sign_extender(
        .imm_val(imm_val),
        .imm_type(imm_src),
        .ext_imm(ext_imm_val)
    );

    // alu source mux

    logic [31:0] src2;

    mux alu_src2(
        .a(rs_data[1]),
        .b(ext_imm_val),
        
        .s(imm_src),

        .aer(src2)
    );

    // main alu
    logic [31:0] src1, alu_out;
    assign src1 = rs_data[0];

    alu_i alu_main(
        .alu_op(alu_op),

        .src1(src1),
        .src2(src2),

        .d_out(alu_out)
    );

    // main memory

    logic main_memory_rst_n;
    assign main_memory_rst_n = ~rst;
    
    logic [31:0] memory_data;

    memory main_memory(
        .clk(clk),
        .rst_n(main_memory_rst_n),

        .read_en(mem_read),
        .read_addr(alu_out),
        .read_data(memory_data),

        .write_en(mem_write),
        .write_addr(alu_out),
        .write_data(rs2_data)
    );

endmodule;
