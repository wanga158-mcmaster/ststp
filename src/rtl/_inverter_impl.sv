module _inverter_impl (
    input logic [31:0] a,
    output logic [31:0] aer
);

    for (int i = 0; i < 32; ++i) begin
        assign aer[i] = ~(a[i]);
    end

endmodule