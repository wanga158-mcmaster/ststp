module register_file (
    input logic clk,
    input logic rst_n,

    input logic read_en,
    input logic [4:0] read_addr [2],
    output logic [31:0] read_dat [2],

    input logic write_en,
    input logic [4:0] write_addr,
    input logic [31:0] write_dat
);
    
    logic [31:0] registers[32];

    assign registers[0] = '0;

    always @(posedge clk) begin
        if (~rst_n) begin
            for (int i = 1; i < 31; ++i) begin
                registers[i] <= 0;
            end
        end else if (write_en) begin
            if (write_addr !== 5'b0000) begin // x0 always stores 0
                registers[write_addr] <= write_dat;
            end
        end
    end

    always_comb begin
        if (rst_n | ~read_en) begin // if reset or read enable is not on
            read_dat[0] = 0;
            read_dat[1] = 0;
        end else begin
            for (int i = 0; i < 2; ++i) begin
                if (write_en && write_addr === read_addr[i]) begin // forward data from writeback
                    read_dat[i] = write_dat;
                end else begin
                    read_dat[i] = registers[read_addr[i]];
                end
            end
        end
    end

endmodule;
