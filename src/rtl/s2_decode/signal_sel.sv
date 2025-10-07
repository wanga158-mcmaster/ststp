`include "../lib/types.svh"

module signal_sel (
    input logic [31:0] op,

    output logic [4:0] op_type, // 0 -> math, 1 -> load/store, 2 -> branch, 3 -> load
    output logic [6:0] op_spec, // specific operation of type
    output logic [31:0] imm, // assembled immediate
    
    output logic [31:0] rs1_ind,
    output logic [31:0] rs2_ind,
    output logic [31:0] rd_ind

);

    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;

    assign opcode[6:0] = op[6:0];
    assign funct7[6:0] = op[31:25];
    assign funct3[2:0] = op[14:12];

    logic [24:0] raw_imm;
    assign raw_imm = op[31:7];

    assign rd = op[11:7];
    assign rs1 = op[19:15];
    assign rs2 = op[24:20];

    always_comb begin
        case (opcode)
            7'0110011: begin // r-type fmt, arithmetic
                op_type = ARITHMETIC;
                op_spec[6] = 0; // 7th bit used to determine immediate or register value
                case (funct7)
                    7'b0000000: begin
                        case (funct3)
                            3'b000: begin // add
                                op_spec[5:0] = ADD;
                            end
                            3'b100: begin // xor
                                op_spec[5:0] = XOR;
                            end
                            3'b110: begin // or
                                op_spec[5:0] = OR;
                            end
                            3'b111: begin // and
                                op_spec[5:0] = AND;
                            end
                            3'b001: begin // sll
                                op_spec[5:0] = SLL;
                            end
                            3'b101: begin // srl
                                op_spec[5:0] = SRL;
                            end
                            3'b010: begin // slt
                                op_spec[5:0] = SLT;
                            end
                            3'b011: begin // sltu
                                op_spec[5:0] = SLTU;
                            end
                        endcase
                    end
                    7'b0100000: begin
                        case (funct3)
                            3'b000: begin // sub
                                op_spec[5:0] = SUB;
                            end
                            3'b101: begin // sra
                                op_spec[5:0] = SRA;
                            end
                        endcase
                    end
                endcase
                imm = 1'b0;
                r_type = 1'b0;
            end
            7'0010011: begin // i-type fmt, arithmetic immediate
                op_type = ARITHMETIC;
                op_spec[6] = 1;
                case (funct3)
                    3'b000: begin // addi
                        op_spec[5:0] = ADD;
                    end
                    3'b100: begin // xori
                        op_spec[5:0] = XOR;
                    end
                    3'b110: begin // ori
                        op_spec[5:0] = OR;
                    end
                    3'b111: begin // andi
                        op_spec[5:0] = AND;
                    end
                    3'b001: begin // slli
                        op_spec[5:0] = SLL;
                    end
                    3'b101: begin // srli, srai
                        if (imm[31:25] == 7'b0000000) begin // srli
                            op_spec[5:0] = SRL;
                        end else begin // srai
                            op_spec[5:0] = SRA;
                        end
                    end
                    3'b010: begin // slti
                        op_spec[5:0] = SLT;
                    end
                    3'b011: begin // sltui
                        op_spec[5:0] = SLTU;
                    end
                endcase
                imm = {{20{raw_imm[24]}}, raw_imm[24:13]};
                r_type = 1'b1;
            end
            7'0000011: begin // i-type fmt, load
                op_type = MEMORY;
                case(funct3)
                    3'b000: op_spec = LB; // lb
                    3'b001: op_spec = LH; // lh
                    3'b010: op_spec = LW; // lw
                    3'b100: op_spec = LBU; // lbu
                    3'b101: op_spec = LHU; // lhu
                endcase
                imm = {{20{raw_imm[24]}}, raw_imm[24:13]};
            end
            7'0100011: begin // s-type fmt, store
                op_type = MEMORY;
                case(funct3)
                    3'b000: op_spec = SB; // sb
                    3'b001: op_spec = SH; // sh
                    3'b010: op_spec = SW; // sw
                endcase
                imm = {{20{raw_imm[24]}}, raw_imm[24:18], raw_imm[4:0]}
            end
            7'b1100011: begin // b-type fmt, branch
                op_type = BRANCH;
                case(funct3)
                    3'b000: op_spec = BEQ; // beq
                    3'b001: op_spec = BNE; // bne
                    3'b100: op_spec = BLT; // blt
                    3'b101: op_spec = BGE; // bge
                    3'b110: op_spec = BLTU; // bltu
                    3'b111: op_spec = BGEU; // bgeu
                endcase
                imm = {{20{raw_imm[24]}}, raw_imm[0], raw_imm[23:18], raw_imm[4:1], 1'b0}
            end
            7'b1101111: begin // j-type fmt, jump and link
                op_type = JUMP;
                op_spec = JAL;
                imm = {{12{raw_imm[24]}}, raw_imm[12:5], raw_imm[13], raw_imm[23:14], 1'b0}
            end
            7'b1100111: begin // i-type fmt, jump and link reg
                op_type = JUMP;
                op_spec = JAL;
                imm = {{20{raw_imm[24]}}, raw_imm[24:13]};
            end
            7'b0110111: begin // u-type fmt, load upper immediate
                op_type = ARITHMETIC;
                op_spec = {1, ADD};
                imm = {imm_val[24:5], 12{1'b0}};
            end
            7'b0010111: begin // u-type fmt, add upper imm to pc
                op_type = 3'b000;
                op_spec = {1, AUIPC};
                imm = {imm_val[24:5], 12{1'b0}};
            end
            default: begin
                imm = {32{1'b1}};
            end
        endcase
    end

endmodule;
