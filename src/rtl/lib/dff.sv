module d_register #( // synchronous reset d register with flush and enable
    parameter integer W = 32,
    parameter logic [31:0] rst_vect = '0,
) (
    input logic clk,
    input logic rst_n,

    input logic en,
    input logic flush,

    input logic [W - 1:0] din,
    output logic [W - 1:0] dout
);
    
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            dout <= rst_vect;
        end else if (flush) begin
            dout <= {W{1'b0}};
        end else if (en) begin
            dout <= din;
        end
    end

endmodule;

module d_ff #(
    parameter logic rst_val = 0;
) (
    input logic clk,
    input logic rst_n,

    input logic en,
    input logic flush,

    input logic [31:0] din,
    output logic [31:0] dout
);

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            dout <= rst_val;
        end else if (flush) begin
            dout <= 0;
        end else if (en) begin
            dout <= din;
        end
    end

endmodule;