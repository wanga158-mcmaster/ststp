`include "../../rtl/s2_decode/signal_sel.sv"

module signal_sel_tb;

    logic [31:0] op;

    logic [4:0] op_type;
    logic [6:0] op_spec;
 
    logic [31:0] imm;
    logic [4:0] rs1_ind;
    logic [4:0] rs2_ind;
    logic [4:0] rd_ind;

    signal_sel dut(
        .(*)
    );

    initial begin
        
    end

endmodule;