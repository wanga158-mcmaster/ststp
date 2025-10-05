`include "register_file.sv"
`include "signal_sel.sv"

module decode(
    input logic clk,
    input logic rst_n,

    input logic [31:0] instr_in,
    input logic [31:0] instr_addr_in, // address of current instruction

    output logic [31:0] instr_addr_out, // address of current instruction (unchanged)
    output logic [3:0] op_type,
    output logic [4:0] op_spec,

    output logic [4:0] rs1_ind,
    output logic [4:0] rs2_ind,
    output logic [4:0] rd_ind,
    output logic [31:0] rs1_dat,
    output logic [31:0] rs2_dat,
    output logic [31:0] imm,
    output logic r_type,
    
    /* data from writeback stage */
    input logic [4:0] rd_ind_in,
    input logic [31:0] rd_dat_in,
    input logic rd_dat_take,

    input logic [31:0] mem_dat,
    input logic mem_dat_take
);

    logic [3:0] op_type_t;
    logic [4:0] op_spec_t;
    logic [4:0] rs1_ind_t, rs2_ind_t, rd_ind_t;
    logic [31:0] imm_t;
    logic r_type_t;

    signal_sel ctrl_unit(
        .op(instr_in),

        .op_type(op_type_t),
        .op_spec(op_spec_t),
        .imm(imm_t),
        .r_type(r_type_t),

        .rs1_ind(rs1_ind_t),
        .rs2_ind(rs2_ind_t),
        .rd_ind(rd_ind_t)
    );

    logic [4:0] rs_indx[2];
    assign rs_indx[0] = rs1_ind_t;
    assign rs_indx[1] = rs2_ind_t;

    logic [31:0] rs_dat_t[2], rd_dat_t;
    logic rd_write_en;

    assign rd_dat_t = rd_dat_in & {32{rd_dat_take}} | mem_dat & {32{mem_dat_take}};
    assign rd_write_en = rd_dat_take | mem_dat_take;

    register_file regf(
        .clk(clk),
        .rst_n(rst_n),

        .read_en(1'b1),
        .read_addr(rs_indx),
        .read_data(rs_dat_t),

        .write_en(rd_write),
        .write_addr(rd_ind_in),
        .write_data(rd_dat_t)
    );

    d_register #(
        ._W(32)
    ) instr_addr_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(instr_addr_in),
        .dout(instr_addr_out)
    )

    d_register #(
        ._W(4)
    ) op_type (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(op_type_t),
        .dout(op_type)
    )

    d_register #(
        ._W(5)
    ) op_spec (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(op_spec_t),
        .dout(op_spec)
    )

    d_register #(
        ._W(5)
    ) rs1_ind_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(rs1_ind_t),
        .dout(rs1_ind)
    )

    d_register #(
        ._W(5)
    ) rs2_ind_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(rs2_ind_t),
        .dout(rs2_ind)
    )

    d_register #(
        ._W(5)
    ) rd_ind_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(rd_ind_t),
        .dout(rd_ind)
    )

    d_register #(
        ._W(32)
    ) rs1_dat_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(rs_dat_t[0]),
        .dout(rs1_dat)
    )

    d_register #(
        ._W(32)
    ) rs2_dat_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(rs_dat_t[1]),
        .dout(rs2_dat)
    )

    d_register #(
        ._W(32)
    ) rd_dat_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(rd_dat_t),
        .dout(rd_dat)
    )

    d_register #(
        ._W(32)
    ) imm_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(imm_t),
        .dout(imm)
    )

    d_ff r_type_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(r_type_t),
        .dout(r_type)
    )

endmodule;