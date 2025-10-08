module mux_gen #( // general mux
    parameter _W = 32,
    parameter _N = $clog2(_W)
) (
    input logic clk,
    
    input logic [_W - 1:0] A[2**_N],

    input logic [_N - 1:0] s,
    
    output logic [_W - 1:0] aer
);

    always_comb begin
        aer = A[s];
    end

endmodule;