`include "s1/fetch.sv"
`include "s2/decode.sv"
`include "s3/execute.sv"
`include "s4/writeback.sv"
`include "lib/memory.sv"

module main(
    input logic clk,
    input logic rst_n
);

    /* instruction memory & fetch interface */
    logic [31:0] instr_dat, instr_addr_m;

    /* fetch & decode interface */
    logic [31:0] instr_addr_d, instr_dat_d;

    /* decode & execute interface */
    logic [31:0] instr_dat_e;
    logic [3:0] op_type;
    logic [4:0] op_spec;
    logic [4:0] rs1_ind, rs2_ind, rd_ind;
    logic [31:0] rs1_dat, rs2_dat, imm;
    logic [31:0] r_type;

    /* execute & writeback interface */
    logic [3:0] op_type_w;
    logic [4:0] op_spec_w;
    logic [4:0] rd_ind_w;
    logic [31:0] rd_dat_w;
    logic [31:0] jmp_addr;
    logic jmp_take;

    /* execute & storage memory interface */
    logic [31:0] st_mem_addr;
    logic [31:0] st_mem_dat;
    logic st_mem_read, st_mem_write;

    /* storage memory & writeback interface */
    logic [31:0] st_mem_dat_w;

    /* writeback & decode interface */
    logic [4:0] rd_ind_d;
    logic [31:0] rd_dat_d;
    logic rd_dat_take_d;

    logic [31:0] st_mem_dat_d;
    logic st_mem_dat_take;

    /* writeback & fetch interface */

    logic [31:0] jmp_addr_f;
    logic jmp_take_f;

    memory instr_mem( // immutable
        .clk(clk),
        .rst_n(rst_n),

        .read_en(1'b1),
        .read_addr(instr_addr_m),
        .read_data(instr_dat),

        .write_en(1'b0),
        .write_addr(1'b0),
        .write_data(1'b0)
    );

    memory storage_mem(
        .clk(clk),
        .rst_n(rst_n),

        .read_en(st_mem_write),
        .read_addr(st_mem_addr),
        .read_data(st_mem_dat_w),
        
        .write_en(st_mem_write),
        .write_addr(st_mem_addr),
        .write_data(st_mem_dat)
    );

    fetch s1(
        .clk(clk),
        .rst_n(rst_n),

        .rst_addr({32{1'b0}}),

        .instr_mem(instr_dat),

        .instr_mem_out(instr_dat_d),
        .instr_addr_to_mem(instr_addr_m),
        .instr_addr_to_decode(instr_addr_d),

        .jmp_addr(jmp_addr_f),
        .jmp_take(jmp_take_f)
    );

    decode s2(
        .clk(clk),
        .rst_n(rst_n),

        .instr_in(instr_dat_d),
        .instr_addr_in(instr_addr_d),

        .instr_addr_out(instr_dat_e),
        .op_type(op_type),
        .op_spec(op_spec),

        .rs1_ind(rs1_ind),
        .rs2_ind(rs2_ind),
        .rd_ind(rd_ind),
        .rs1_dat(rs1_dat),
        .rs2_dat(rs2_dat),
        .imm(imm),
        .r_type(r_type),

        .rd_ind_in(rd_ind_d),
        .rd_dat_in(rd_dat_d),
        .rd_dat_take(rd_dat_take_d),

        .mem_dat(st_mem_dat_d),
        .mem_dat_take(st_mem_dat_take)
    );

    execute s3(
        .clk(clk),
        .rst_n(rst_n),

        .instr_addr_in(instr_dat_e),
        .op_type(op_type),
        .op_spec(op_spec),

        .rs1_ind(rs1_ind),
        .rs2_ind(rs2_ind),
        .rd_ind(rd_ind),
        .rs1_dat(rs1_dat),
        .rs2_dat(rs2_dat),
        .imm(imm),
        .r_type(r_type),

        .op_type_out(op_type_w),
        .op_spec_out(op_spec_w),
        .rd_ind_out(rd),
        .rd_dat_out(rd_dat_w),
        .jmp_addr_out(jmp_addr),
        .jmp_take(jmp_take),

        .mem_addr_out(st_mem_addr),
        .mem_dat_out(st_mem_dat),
        .mem_read_en(st_mem_read),
        .mem_write_en(st_mem_write),
    );

    writeback s4(
        .clk(clk),
        .rst_n(rst_n),

        .op_type(op_type_w),
        .op_spec(op_spec_w),

        .rd_ind(rd_ind_w),
        .rd_dat(rd_dat_w),

        .jmp_addr(jmp_addr),
        .jmp_take(jmp_take),

        .mem_dat(st_mem_dat_w),

        .rd_ind_out(rd_ind_d),
        .rd_dat_out(rd_dat_d),
        .rd_dat_take(rd_dat_take_d),

        .mem_dat_out(st_mem_dat_d),
        .mem_dat_take(st_mem_dat_take),

        .jmp_addr_out(jmp_addr_f),
        .jmp_take_out(jmp_take)
    );

endmodule;