module memory #( // main memory, one cycle write & read; assumes all addresses are aligned
    parameter WIDTH = 32,
    parameter DEPTH = 8
) (
    input logic clk,
    input logic rst_n,

    input logic read_en,
    input logic [31:0] read_addr, // assume address is aligned
    output logic [WIDTH - 1:0] read_data,
    
    input logic write_en,
    input logic [31:0] write_addr, // assume address is aligned
    input logic [WIDTH - 1:0] write_data
);

    logic [WIDTH - 1:0] mem [DEPTH];

    always @(posedge clk) begin

        if (!rst_n) begin
            for (int i = 0; i < DEPTH; ++i) begin
                mem[i] <= 0;
            end
        end else if (write_en) begin
            mem[write_addr] <= write_data;
        end

        if (read_en) begin
            read_data <= mem[read_addr];
        end
    end

endmodule;
