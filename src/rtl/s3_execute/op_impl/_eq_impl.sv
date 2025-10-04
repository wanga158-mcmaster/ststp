module _eq_impl(
    input logic [31:0] a,
    input logic [31:0] b,

    input logic [31:0] aer
);

    logic [31:0] k;
    
    assign k[0] = ~(a[i] ^ b[i]);

    always_comb begin
        for (int i = 1; i < 32; ++i) begin
            k[i] = (~(a[i] ^ b[i])) & k[i - 1];
        end
    end
    
    assign aer = 32{k[31]};

endmodule;