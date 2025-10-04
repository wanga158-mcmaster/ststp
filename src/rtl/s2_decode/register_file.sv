module register_file (
    input logic clk,
    input logic rst_n,

    input logic read_en,
    input logic [4:0] read_addr [2],
    output logic [31:0] read_data [2],

    input logic write_en,
    input logic [4:0] write_addr,
    input logic [31:0] write_data
)
    
    logic [31:0] registers[32];
    
    always @(posedge clk) begin
        if (!rst_n) begin
            for (int i = 0; i < 31; ++i) begin
                registers[i] <= 0;
            end
        end else if (write_en) begin
            registers[write_addr] <= write_data;
        end
    end
    
    logic [31:0] chk;
    
    assign chk = {32{read_en}};
    assign read_data[0] = registers[read-addr[0]] & chk;
    assign read_data[1] = registers[read_addr[1]] & chk;

endmodule;
