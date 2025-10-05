`include "program_counter.sv"

module fetch(
    input logic clk,
    input logic rst_n,

    input logic [31:0] rst_addr, // pc reset address

    input logic [31:0] instr_mem, // instruction memory
    
    output logic [31:0] instr_mem_out, // instruction memory unchanged
    output logic [31:0] instr_addr_to_mem, // instruction address sent to instruction memory
    output logic [31:0] instr_addr_to_decode, // instruction address sent to decode

    input logic [31:0] jmp_addr, // jump address from writeback
    input logic jmp_take // jump take from writeback
);

    logic [31:0] instr_addr;

    program_counter pc(
        .clk(clk),
        .rst_n(rst_n),
        .inc(~jmp_take),
        .load(jmp_take),
        .stll(),

        .ld_addr(jmp_addr),
        .rst_addr(rst_addr),

        .pc_out(instr_addr)
    );

    assign instr_addr_to_mem = instr_addr;
    assign instr_mem_out = instr_mem;

    d_register s_instr (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(instr_addr),
        .dout(instr_addr_out_to_decode),
    )
    
    

endmodule;