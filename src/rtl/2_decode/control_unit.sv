module control_unit (
    input logic [31:0] op,

    output logic pc_src, // program counter source, 0 for default + 4, 1 for branch
    output logic rslt_src, // result source to write to register file, 0 for alu, 1 for memory
    output logic [2:0] imm_src, // immediate source type
    output logic alu_src, // second alu value, 0 for register, 1 for immediate

    output logic [3:0] alu_op,

    output logic mem_write,
    output logic mem_read;
    output logic reg_write
);

    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;

    assign opcode[6:0] = op[6:0];
    assign funct7[6:0] = op[31:25];
    assign funct3[2:0] = op[14:12];

    always_comb begin
        case (opcode)
            7'0110011: begin // r-type fmt, arithmetic
                pc_src = 0; // pc plus four
                rslt_src = 0; // result from alu
                imm_src = 0; // don't care, no immediate used
                alu_src = 0; // use register
                case (funct7)
                    7'b0000000: begin
                        case (funct3)
                            3'b000: begin // add
                                alu_op = 4'b0000;
                            end
                            3'b100: begin // xor
                                alu_op = 4'b0001;
                            end
                            3'b110: begin // or
                                alu_op = 4'b0010;
                            end
                            3'b111: begin // and
                                alu_op = 4'b0011;
                            end
                            3'b001: begin // sll
                                alu_op = 4'b0100;
                            end
                            3'b101: begin // srl
                                alu_op = 4'b0101;
                            end
                            3'b010: begin // slt
                                alu_op = 4'b0110;
                            end
                            3'b011: begin // sltu
                                alu_op = 4'b0111;
                            end
                        endcase
                    end
                    7'b0100000: begin
                        case (funct3)
                            3'b000: begin // sub
                                alu_op = 4'b1000;
                            end
                            3'b101: begin // sra
                                alu_op = 4'b1001;
                            end
                        endcase
                    end
                endcase
                mem_write = 0; // don't write to memory
                mem_read = 0; // don't read from memory
                reg_write = 1; // write to register
            end
            7'0010011: begin // i-type fmt, arithmetic immediate
                pc_src = 0;
                rslt_src = 0; // result from alu
                imm_src = 0; // i fmt instructions
                alu_src = 1; // use immediate
                case (funct3)
                    3'b000: begin // addi
                        alu_op = 4'b0000;
                    end
                    3'b100: begin // xori
                        alu_op = 4'b0001;
                    end
                    3'b110: begin // ori
                        alu_op = 4'b0010;
                    end
                    3'b111: begin // andi
                        alu_op = 4'b0011;
                    end
                    3'b001: begin // slli
                        alu_op = 4'b0100;
                    end
                    3'b101: begin // srli, srai
                        if (imm[31:25] == 6'b000000) begin // srli
                            alu_op = 4'b0101;
                        end else begin // srai
                            alu_op = 4'b1001;
                        end
                    end
                    3'b010: begin // slti
                        alu_op =  4'b0110;
                    end
                    3'b011: begin // sltiu
                        alu_op = 4'b1000;
                    end
                endcase
                mem_write = 0; // don't write to memory
                mem_read = 0; // don't read from memory
                reg_write = 1; // write to register
            end
            7'0000011: begin // i-type fmt, load
                pc_src = 0; // pc plus four
                rslt_src = 1; // load from memory
                imm_src = 0; // i fmt instructino
                alu_src = 1; // use immediate for alu
                alu_op = 0; // add
                mem_write = 0; // don't write to memory
                mem_read = 1; // read from memory
                reg_write = 1; // write to register
            end
            7'0100011: begin // s-type fmt, store
                pc_src = 0; // pc plus four
                rslt_src = 0; // no result from either alu or memory; don't care
                imm_src = 3'b001; // second immediate source type
                alu_src = 1; // use immediate for alu
                alu_op = 0; // add
                mem_write = 1; // write to memory
                mem_read = 0; // don't read from memory
                reg_write = 0; // don't write to register
            end
            7'b1100011: begin // b-type fmt, branch
                pc_src = 1; // pc plus immediate
                rslt_src = 0; // no result from either alu or memory needed
                imm_src = 3'b010; // b type immediate
                alu_src = 1; //
            end
            7'b1101111: begin // j-type fmt, jump and link
            end
            7'b1100111: begin // i-type fmt, 
            default: begin
            end
        endcase
    end

endmodule