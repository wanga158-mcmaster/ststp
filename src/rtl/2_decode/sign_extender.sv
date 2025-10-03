module sign_extender (
    input logic [24:0] imm_val, // non-extended input
    input logic [2:0] imm_type, // bit source
    output logic [31:0] ext_imm // extended output
)

    always_comb begin
        case (imm_type)
            3'b000: begin // i-type instructions
                ext_out = {{20{imm_val[24]}}, imm_val[24:13]};
            end
            3'b001: begin // s-type instructions
                ext_out = {{20{imm_val[24]}}, imm_val[24:18], imm_val[4:0]}
            end
            3'b010: begin // b-type instructions
                ext_out = {{20{imm_val[24]}}, imm_val[0], imm_val[23:18], imm_val[4:1], 1'b0}
            end
            3'b011: begin // j-type instructions
                ext_out = {{12{imm_val[24]}}, imm_val[12:5], imm_val[13], imm_val[23:14], 1'b0}
            end
            3'b100: begin // u-type instruction (load upper immediate (lui))
                ext_out = {imm_val[24:5], 12{1'b0}};
            end
            default: begin
                ext_out = 0;
            end
        endcase
    end

endmodule;