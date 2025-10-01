module mux ( // most common 2 input mux
    parameter WIDTH = 32
) (
    input logic [WIDTH - 1:0] a,
    input logic [WIDTH - 1:0] b,

    input logic s,
    
    output logic [WIDTH - 1:0] aer
)

    always_comb begin
        case(s)
            1'b0: aer = a;
            1'b1: aer = b;
            default: aer = 0;
        endcase
    end

endmodule;

module mux_gen ( // general mux
    parameter WIDTH = 32,
    parameter N = 1
) (
    input logic [WIDTH - 1:0] arr[2**N],

    input logic [N - 1:0] s,
    
    output logic[WIDTH - 1:0] aer;
)

    assign aer = arr[s];

endmodule;