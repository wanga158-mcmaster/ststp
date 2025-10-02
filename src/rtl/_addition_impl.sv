module _addition_impl ( // carry lookahead adder
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [32:0] aer
);  

    logic [31:0] G, P;
    logic [32:0] C;
    assign C[0] = 0;

    for (int i = 0; i < 32; ++i) begin
        assign G[i] = a[i] & b[i];
        assign P[i] = a[i] | b[i];
        assign C[i + 1] = G[i] | (P[i] & C[i]);
    end

    for (int i = 0; i < 32; ++i) begin
        assign aer[i] = a[i] ^ b[i] ^ c[i];
    end

endmodule