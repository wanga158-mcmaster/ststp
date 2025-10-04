module fetch(
    input logic clk,
    input logic rst_n,

    input logic [31:0] rst_addr,

    input logic [31:0] instr_mem_in,
    output logic [31:0] instr_mem_out,
    output logic [31:0] instr_addr,
);

    program_counter pc(
        .clk(clk),
        .rst_n(rst_n),
        .load(1'b0),
        .stall(1'b0),
        .inc(1'b1),

        .ld_addr({32{1'b0}}),
        .rst_addr(rst_addr),

        .pc_out(instr)
    );

    d_register pc_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0)

        .din(pc_out),
        .dout(instr_addr)
    )

    d_register s_instr (
        .clk(clk),
        .rst_n(rst_n),

        .en(1'b1),
        .flush(1'b0),

        .din(instr_mem_in),
        .dout(instr_mem_out),
    )

endmodule;