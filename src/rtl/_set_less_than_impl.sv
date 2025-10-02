module _slt_impl ( // instead of setting rd = 1 when rs1 < rs2, set to 32'b111..11
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] aer
); 

    logic [1:0] neg;
    assign neg = {a[31], b[31]};
    logic [31:0] k1, k2; // less than found, greater than found

    always_comb begin
        case(neg)
            2'b00: begin // both positive
                k1[31] = 0;
                k2[31] = 0;
                for (int i = 30; i >= 0; --i) begin
                    k1[i] = (~k2[i + 1]) & ((b[i] & ~a[i]) | k1[i + 1]); // b[i] is set and a[i] isn't set -> a is less than b if another mismatch hasn't been found
                    k2[i] = (~k1[i + 1]) & ((a[i] & ~b[i]) | k2[i + 1]);
                end
                aer = 32{k1[0]};
            end
            2'b01: begin // a positive, b negative
                aer = 32{1'b0};
            end
            2'b10: begin // a negative, b positive
                aer = 32{1'b1};
            end
            2'b11: begin // both negative
                k1[31] = 0;
                k2[31] = 0;
                for (int i = 30; i >= 0; --i) begin
                        k1[i] = (~k2[i + 1]) & ((b[i] & ~a[i]) | k1[i + 1]); // b[i] is set and a[i] isn't set -> a is less than b if another mismatch hasn't been found
                        k2[i] = (~k1[i + 1]) & ((a[i] & ~b[i]) | k2[i + 1]);
                end
                aer = 32{k2[0]}; // if a is greater in magnitude it is less than b since the sign is negative
            end
            default: begin // impossible
            end
        endcase
    end

endmodule;