module program_counter (
    input logic clk,
    input logic rst_n,

    input logic inc, // increment
    input logic ld, // load
    input logic stll, // stall

    input logic [31:0]  rst_addr,
    input logic [31:0] ld_dat, // load address (jumps)
    
    output logic [31:0] pc_out // program counter output address
);

    logic [31:0] nxt_pc, pc_inc;
    logic mode;
    assign mode = 0;
    assign pc_inc = mode ? nxt_pc + 2 : nxt_pc + 4;


    always_ff @(posedge clk) begin // to do: check for valid address
        if (!rst_n) nxt_pc <= rst_addr;
        else if (stll) nxt_pc <= nxt_pc;
        else if (ld) nxt_pc <= ld_dat;
        else if (inc) nxt_pc <= pc_inc;
        else nxt_pc <= 0;
    end

    assign pc_out = nxt_pc;

endmodule;
