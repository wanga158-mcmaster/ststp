module program_count (
    input logic clk,
    input logic rst_n,

    input logic [31:0] nxt_inst_addr;
    output logic [31:0] inst_addr
)
    
    always @(posedge clk) begin
        if (!rst_n) begin
            inst_addr <= 0;
        end else begin
            inst_addr <= nxt_inst_addr;
        end
    end

endmodule;