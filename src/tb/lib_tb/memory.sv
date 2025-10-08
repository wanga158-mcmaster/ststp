module memory #( // main memory, one cycle write & read; assumes all addresses are aligned
    parameter _W = 32,
    parameter _D = 1024
) (
    input logic clk,
    input logic rst_n,

    input logic read_en,
    input logic [31:0] read_addr, // assume address is aligned
    output logic [_W - 1:0] read_data,
    
    input logic write_en,
    input logic [31:0] write_addr, // assume address is aligned
    input logic [_W - 1:0] write_data
);

    logic [_W - 1:0] mem [_D];

    always @(posedge clk) begin

        if (!rst_n) begin
            for (int i = 0; i < _D; ++i) begin
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
