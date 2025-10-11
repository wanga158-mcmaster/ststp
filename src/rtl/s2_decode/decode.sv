`include "register_file.sv"
`include "signal_sel.sv"

`ifndef _TYPES_H
`include "../lib/types.svh"
`endif

`include "../lib/dff.sv"

module decode(
    input logic clk,
    input logic rst_n,

    /* fetch and decode interface */
    input f_d_WI f_in,
    input logic [31:0] instr_dat_in,

    /* decode and execute interface */
    output d_e_WI d_out,
    
    /* data from writeback stage */
    input w_d_WI w_in,

    input logic stall_in, // previous stage stall
    output logic stall_out // signal to next stage stall
);

    d_e_WI d_t;
    assign d_t.instr_dat = instr_dat_in;
    assign d_t.instr_addr = f_in.instr_addr;

    signal_sel ctrl_unit(
        .op(instr_dat_in),

        .op_type(d_t.op_type),
        .op_spec(d_t.op_spec),
        .imm(d_t.imm_val),

        .rs1_ind(d_t.rs1_ind),
        .rs2_ind(d_t.rs2_ind),
        .rd_ind(d_t.rd_ind)
    );

    logic [4:0] rs_indx[2];
    assign rs_indx[0] = d_t.rs1_ind;
    assign rs_indx[1] = d_t.rs2_ind;
    logic [31:0] rs_datx[2];
    assign d_t.rs1_dat = rs_datx[0];
    assign d_t.rs2_dat = rs_datx[1];

    logic [31:0] rd_dat;
    logic rd_write_en;

    assign rd_dat = w_in.reg_dat & {32{w_in.reg_tk}} | w_in.mem_dat & {32{w_in.mem_tk}};
    assign rd_write_en = w_in.reg_tk | w_in.mem_tk;

    register_file regf(
        .clk(clk),
        .rst_n(rst_n),

        .read_en(1'b1),
        .read_addr(rs_indx),
        .read_data(rs_datx),

        .write_en(rd_write_en & ~w_in.st),
        .write_addr(w_in.rd_ind),
        .write_data(rd_dat)
    );

    d_register #(
        ._W($bits(d_e_WI))
    ) d_out_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(~stall_in),
        .flush(w_d.flush),

        .din(d_t),
        .dout(d_out)
    );

    d_ff stall_out_s(
        .clk(clk),
        .rst_n(rst_n),
        
        .en(1),
        .flush(0),

        .din(stall_in | w_in.flush),
        .dout(stall_out)
    );


endmodule;