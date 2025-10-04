module _sltu_impl ( // instead of setting rd = 1 when rs1 < rs2, set to 32'b111..11
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] aer
); 

    logic [31:0] k1, k2; // less than found, greater than found

    always_comb begin
        k1[31] = b[31] & ~a[31];
        k2[31] = a[31] & ~b[31];
        for (int i = 30; i >= 0; --i) begin
            k1[i] = (~k2[i + 1]) & ((b[i] & ~a[i]) | k1[i + 1]); // b[i] is set and a[i] isn't set -> a is less than b if another mismatch hasn't been found
            k2[i] = (~k1[i + 1]) & ((a[i] & ~b[i]) | k2[i + 1]);
        end
        aer = 32{~k1[0]};
    end

endmodule;