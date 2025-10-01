module alu_r (
    input logic [3:0] alu_op,

    input logic [31:0] src1,
    input logic [31:0] src2,

    output logic [31:0] d_out
);
    
    always_comb begin
        case (op_type)
            4'b0000: begin
            end
            4'b0001: begin
            end
            4'b0010: begin
            end
            4'b0011: begin
            end
            4'b0100: begin
            end
            4'b0101: begin
            end
            4'b0110: begin
            end
            4'b0111: begin
            end
            4'b1000: begin
            end
            4'b1001: begin
            end
            default: begin
            end
        endcase
    end

endmodule;

//to do: implement operations