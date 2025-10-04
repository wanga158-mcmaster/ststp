module decode(
    input logic clk,
    input logic rst_n,

    input logic [31:0] instr_in,
    input logic [31:0] instr_addr,

    output logic [31:0] instr_addr,
    output logic instr_out,

    output logic [4:0] rs1_ind,
    output logic [4:0] rs2_ind,
    output logic [4:0] rs1_dat,
    output logic [4:0] rs2_dat,

    output logic [31:0] imm,

    output logic op
);

    signal_sel ctrl_unit(
        .op(instr_in),
    );

    register_file regf(

    );

endmodule;