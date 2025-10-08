module mux #( // 2 input mux
    parameter _W = 32
) (
    input clk,
    
    input logic [_W - 1:0] a,
    input logic [_W - 1:0] b,

    input logic s,
    
    output logic [_W - 1:0] aer
);

    always_comb begin
        case(s)
            1'b0: aer = a;
            1'b1: aer = b;
            default: aer = 0;
        endcase
    end

endmodule;
