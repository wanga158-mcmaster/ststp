module _add(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _add_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _sub(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _sub_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _xor(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _xor_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _or(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _or_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _and(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _and_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _sll(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _sll_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _srl(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _srl_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _sra(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _sra_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _slt(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _slt_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _sltu(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _sltu_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _eq(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _eq_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _ge(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _ge_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;

module _geu(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic en,

    input logic [31:0] aer
);

    logic [31:0] rslt;

    _geu_impl(
        .a(a),
        .b(b),
        .aer(rslt)
    );

    assign aer = rslt & {32{en}};

endmodule;