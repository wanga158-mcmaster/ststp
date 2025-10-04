module program_counter (
    input logic clk,
    input logic rst_n,

    input logic inc, // increment
    input logic ld, // load
    input logic stll, // stall

    input logic [31:0] rst_addr, // reset address
    input logic [31:0] ld_addr, // load address (jumps)
    
    output logic [31:0] pc_out // program counter output address
);

    logic [31:0] nxt_pc;

    logic [31:0] pc_inc;
    
    pc_adder nxt_inc(
        .addr(nxt_pc),
        .mode(1'b0),

        .addr_inc(pc_inc)
    )

    always_ff @(posedge clk) begin // to do: check for valid address
        if (!rst_n) nxt_pc <= rst_addr;
        else if (ld) nxt_pc <= ld_addr;
        else if (inc) nxt_pc <= pc_inc;
        else if (stll) nxt_pc <= nxt_pc;
    end

    assign pc_out = nxt_pc;

endmodule;

module pc_adder (
    input logic [31:0] addr,
    input logic mode, // 0 for uncompressed, 1 for compressed

    output logic [31:0] addr_inc;
);
    
    always_comb begin
        if (mode) nxt_pc = nxt_pc + 2;
        else nxt_pc = nxt_pc + 4;
    end

endmodule;