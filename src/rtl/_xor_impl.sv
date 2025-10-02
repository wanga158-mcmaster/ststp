module _xor_impl (
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] aer
); 

    for (int i = 0; i < 32; ++i) begin
        assign aer[i] = a[i] ^ b[i];
    end

endmodule;