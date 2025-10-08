module d_ff #(
    parameter logic rst_val = 0
) (
    input logic clk,
    input logic rst_n,

    input logic en,
    input logic flush,

    input logic din,
    output logic dout
);
    logic din_t, dout_t;
    assign din_t = (~flush & din);
    assign dout = (~flush & dout_t);

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            dout_t <= rst_val;
        end else if (en) begin
            dout_t <= din_t;
        end
    end

endmodule;