module alu_r (
    input logic [3:0] alu_op,

    input logic [31:0] src1,
    input logic [31:0] src2,

    output logic [31:0] d_out
);
    
    logic op_en[16];
    
    always_comb begin
        for (int i = 0; i < 16; ++i) {
            if (int'(op_type) == i) begin
                op_en[i] = 1;
            end else begin
                op_en[i] = 0;
            end
        }
    end

    logic [31:0] rslt[16];

    _add op000(
        .a(src1),
        .b(src2),
        .en(op_en[0]),

        .aer(rslt[0])
    );
    _sub op001(
        .a(src1),
        .b(src2),
        .en(op_en[1]),

        .aer(rslt[1])
    );
    _xor op002(
        .a(src1),
        .b(src2),
        .en(op_en[2]),

        .aer(rslt[2])
    );
    _or op003(
        .a(src1),
        .b(src2),
        .en(op_en[3]),

        .aer(rslt[3])
    );
    _and op004(
        .a(src1),
        .b(src2),
        .en(op_en[4]),

        .aer(rslt[4])
    );
    _sll op005(
        .a(src1),
        .b(src2),
        .en(op_en[5]),

        .aer(rslt[5])
    );
    _srl op006(
        .a(src1),
        .b(src2),
        .en(op_en[6]),

        .aer(rslt[6])
    );
    _sra op007(
        .a(src1),
        .b(src2),
        .en(op_en[7]),

        .aer(rslt[7])
    );
    _slt op008(
        .a(src1),
        .b(src2),
        .en(op_en[8]),

        .aer(rslt[8])
    );
    _sltu op009(
        .a(src1),
        .b(src2),
        .en(op_en[9]),

        .aer(rslt[9])
    );

    mux_gen #(
        .WIDTH(16),
        .N(4)
    ) (
        .arr(rslt),
        .s(op_type),
        .aer(d_out)
    );
    
endmodule;

