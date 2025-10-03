module _slr_impl (
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] aer
); 

    logic [31:0] b_t; // b truncated
    assign b_t = {27{1'b0}, b[4:0]};
    for (int i = 0; i < 32; ++i) begin
        if ((i + int'(b_t)) > 31) begin
            assign aer[i] = 0;
        end else begin
            assign aer[i] = a[i + int'(b)];
        end
    end

endmodule;