module _mul_impl (
    input logic [31:0] a,
    input logic [31:0] b,

    output logic [63:0] aer
);
    // fix later
    assign aer = a * b;
    
endmodule;