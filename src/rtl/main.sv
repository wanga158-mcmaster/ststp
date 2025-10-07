`include "s1/fetch.sv"
`include "s2/decode.sv"
`include "s3/execute.sv"
`include "s4/writeback.sv"
`include "lib/memory.sv"

`ifndef _TYPES_H
`include "../lib/types.svh"
`endif


module main(
    input logic clk,
    input logic rst_n
);

    /* instruction memory & fetch interface */
    logic [31:0] instr_dat_m, instr_addr;

    /* fetch -> decode interface */
    f_d_WI f_d;
    logic [31:0] instr_dat_f;
    logic stall_f_out;

    /* decode -> execute interface */
    d_e_WI d_e;
    logic stall_d_out;

    /* execute -> writeback interface */
    e_w_WI e_w;
    logic stall_e_out;

    /* execute -> storage memory interface */
    logic [31:0] st_mem_addr, st_mem_dat_in;
    logic st_mem_read, st_mem_write;

    /* storage memory -> writeback interface */
    logic [31:0] st_mem_dat_out;

    /* writeback -> fetch interface */
    w_f_WI w_f;

    /* writeback -> decode interface */
    w_d_WI w_d;

    /* writeback -> execute interface */
    w_e_WI w_e;

    memory instr_mem( // immutable
        .clk(clk),
        .rst_n(rst_n),

        .read_en(1'b1),
        .read_addr(instr_addr),
        .read_data(instr_dat),

        .write_en(1'b0),
        .write_addr(1'b0),
        .write_data(1'b0)
    );

    fetch s1(
        .clk(clk),
        .rst_n(rst_n),

        .rst_addr({32{1'b0}}),
        
        .instr_dat_in(instr_dat),
        .instr_addr_out_m(instr_addr),

        .f_out(f_d),
        .instr_dat_out(instr_dat_f),

        .w_in(w_f),
        .stall_out(stall_f_out)

    );

    decode s2(
        .clk(clk),
        .rst_n(rst_n),

        .f_in(f_d),
        .instr_dat_in(instr_dat_f),

        .d_out(d_e),
        
        .w_in(w_d),

        .stall_in(stall_f_out),
        .stall_out(stall_d_out)
    );

    execute s3(
        .clk(clk),
        .rst_n(rst_n),

        .d_in(d_e),
        .e_out(e_w),

        .w_in(w_e),

        .mem_addr_out(st_mem_addr),
        .mem_dat_out(st_mem_dat_in),
        .mem_read_en(st_mem_read),
        .mem_write_en(st_mem_write),

        .stall_in(stall_d_out),
        .stall_out(stall_e_out)
    );

    memory storage_mem(
        .clk(clk),
        .rst_n(rst_n),

        .read_en(st_mem_read),
        .read_addr(st_mem_addr),
        .read_data(st_mem_dat_out),

        .write_en(st_mem_write),
        .write_addr(st_mem_addr),
        .write_data(st_mem_dat_in)
    );

    writeback s4(
        .clk(clk),
        .rst_n(rst_n),

        .e_in(e_w),
        .mem_dat(st_mem_dat_out),

        .w_f_out(w_f),
        .w_d_out(w_d),
        .w_e_out(w_e)

        .stall_in(stall_e_out)
    );

endmodule;