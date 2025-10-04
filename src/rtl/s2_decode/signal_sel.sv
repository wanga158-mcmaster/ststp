module signal_sel (
    input logic [31:0] op,

    output logic [3:0] op_type, // 0 -> math, 1 -> load/store, 2 -> branch, 3 -> load
    output logic [4:0] op_spec, // specific operation of type
    output logic [31:0] imm // assembled immediate
);

    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;

    assign opcode[6:0] = op[6:0];
    assign funct7[6:0] = op[31:25];
    assign funct3[2:0] = op[14:12];

    logic [24:0] raw_imm;
    assign raw_imm = op[31:7];

    always_comb begin
        case (opcode)
            7'0110011: begin // r-type fmt, arithmetic
                op_type = 3'b000;
                case (funct7)
                    7'b0000000: begin
                        case (funct3)
                            3'b000: begin // add
                                op_spec = 4'b0000;
                            end
                            3'b100: begin // xor
                                op_spec = 4'b0010;
                            end
                            3'b110: begin // or
                                op_spec = 4'b0011;
                            end
                            3'b111: begin // and
                                op_spec = 4'b0100;
                            end
                            3'b001: begin // sll
                                op_spec = 4'b0101;
                            end
                            3'b101: begin // srl
                                op_spec = 4'b0110;
                            end
                            3'b010: begin // slt
                                op_spec = 4'b1000;
                            end
                            3'b011: begin // sltu
                                op_spec = 4'b1001;
                            end
                        endcase
                    end
                    7'b0100000: begin
                        case (funct3)
                            3'b000: begin // sub
                                op_spec = 4'b0001;
                            end
                            3'b101: begin // sra
                                op_spec = 4'b0111;
                            end
                        endcase
                    end
                endcase
                imm = 0;
            end
            7'0010011: begin // i-type fmt, arithmetic immediate
                op_type = 3'b000;
                case (funct3)
                    3'b000: begin // addi
                        op_spec = 4'b0000;
                    end
                    3'b100: begin // xori
                        op_spec = 4'b0010;
                    end
                    3'b110: begin // ori
                        op_spec = 4'b0011;
                    end
                    3'b111: begin // andi
                        op_spec = 4'b0100;
                    end
                    3'b001: begin // slli
                        op_spec = 4'b0101;
                    end
                    3'b101: begin // srli, srai
                        if (imm[31:25] == 7'b0000000) begin // srli
                            op_spec = 4'b0110;
                        end else begin // srai
                            op_spec = 4'b0111;
                        end
                    end
                    3'b010: begin // slti
                        op_spec =  4'b1000;
                    end
                    3'b011: begin // sltiu
                        op_spec = 4'b1001;
                    end
                endcase
                imm = {{20{raw_imm[24]}}, raw_imm[24:13]};
            end
            7'0000011: begin // i-type fmt, load
                op_type = 3'b001;
                case(funct3)
                    3'b000: op_spec = 4'b0000; // lb
                    3'b001: op_spec = 4'b0001; // lh
                    3'b010: op_spec = 4'b0010; // lw
                    3'b100: op_spec = 4'b0011; // lbu
                    3'b101: op_spec = 4'b0100; // lhu
                endcase
                imm = {{20{raw_imm[24]}}, raw_imm[24:13]};
            end
            7'0100011: begin // s-type fmt, store
                op_type = 3'b001;
                case(funct3)
                    3'b000: op_spec = 4'b0101; // sb
                    3'b001: op_spec = 4'b0110; // sh
                    3'b010: op_spec = 4'b0111; // sw
                endcase
                imm = {{20{raw_imm[24]}}, raw_imm[24:18], raw_imm[4:0]}
            end
            7'b1100011: begin // b-type fmt, branch
                op_type = 3'b010;
                case(funct3)
                    3'b000: op_spec = 4'b0000; // beq
                    3'b001: op_spec = 4'b0001; // bne
                    3'b100: op_spec = 4'b0010; // blt
                    3'b101: op_spec = 4'b0011; // bge
                    3'b110: op_spec = 4'b0100; // bltu
                    3'b111: op_spec = 4'b0101; // bgeu
                endcase
                imm = {{20{raw_imm[24]}}, raw_imm[0], raw_imm[23:18], raw_imm[4:1], 1'b0}
            end
            7'b1101111: begin // j-type fmt, jump and link
                op_type = 3'b010;
                op_spec = 0;
                imm = {{12{raw_imm[24]}}, raw_imm[12:5], raw_imm[13], raw_imm[23:14], 1'b0}

            end
            7'b1100111: begin // i-type fmt, jump and link reg
                op_type = 3'b010;
                op_spec = 0;
                imm = {{20{raw_imm[24]}}, raw_imm[24:13]};
            end
            default: begin
            end
        endcase
    end

endmodule;
