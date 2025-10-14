`include "program_counter.sv"

`ifndef _TYPES_H
`include "../lib/types.svh"
`endif

`include "../lib/dff.sv"

module fetch (
    input logic clk,
    input logic rst_n,

    input logic [31:0] rst_addr,
    /* fetch and instruction memory interface */
    input logic [31:0] instr_dat_in, // instruction data from instruction memory
    input logic instr_dat_v, // instruction valid
    output logic [31:0] instr_addr_out_m, // instruction address to instruction memory

    /* fetch and decode interface */
    output f_d_WI f_out,
    output logic [31:0] instr_dat_out,

    /* writeback and fetch interface */
    input w_f_WI w_in,
    
    input logic stall_in_ft, // stall in, backwards from decode
    output logic stall_out_ft // stall out, forwards to decode
);

    f_d_WI f_t;
    logic [31:0] instr_addr;

    assign f_t.instr_addr = instr_addr;
    assign instr_addr_out_m = instr_addr;
    assign instr_dat_out = instr_dat_in;

    program_counter pc(
        .clk(clk),
        .rst_n(rst_n),

        .inc(~w_in.jmp_tk),
        .ld(w_in.jmp_tk),
        .stll(stall_in_ft),
        
        .ld_dat(w_in.jmp_addr),
        .rst_addr(0),

        .pc_out(instr_addr)
    );
    
    d_register #(
        ._W($bits(f_d_WI))
    ) f_out_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(~stall_in_ft),
        .flush(w_in.jmp_tk),

        .din(f_t),
        .dout(f_out)
    );

    d_ff stall_out_ft_s( // stall for one cycle after jump/reset
        .clk(clk),
        .rst_n(1'b1),

        .en(1'b1),
        .flush(1'b0),

        .din(w_in.jmp_tk | ~rst_n | ~instr_dat_v),
        .dout(stall_out_ft)
    );


endmodule;