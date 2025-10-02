module _or_impl (
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] aer
); 

    for (int i = 0; i < 31; ++i) begin
        assign aer[i] = a[i] | b[i];
    end

endmodule;