`ifndef _TYPES_H
`include "../lib/types.svh"
`endif

`include "../lib/dff.sv"

module writeback(
    input logic clk,
    input logic rst_n,

    input e_w_WI e_in,
    input [31:0] mem_dat,

    output w_f_WI w_f_out,
    output w_d_WI w_d_out,
    output w_e_WI w_e_out,
    
    input logic stall_in, // previous stage stall
);

    w_d_WI w_d_t;
    w_f_WI w_f_t;
    w_e_WI w_e_t;

    assign w_d_t.reg_dat = e_in.reg_dat;
    assign w_f_t.jmp_addr = e_in.jmp_addr;

    always_comb begin
        case (op_type)
            ARITHMETIC: begin // basic math
                w_d_t.reg_tk = 1;
                w_d_t.mem_tk = 0;
                w_f_t.jmp_tk = 0;
            end
            MEMORY: begin // load store
                w_d_t.reg_tk = 0;
                w_d_t.jmp_tk = 0;
                case (op_spec)
                    4'b0000: begin // lb
                        w_d_t.mem_dat = {24{mem_dat[7]}, mem_dat[7:0]};
                        w_d_t.mem_tk = 1;
                    end
                    4'b0001: begin // lh
                        w_d_t.mem_dat = {16{mem_dat[15]}, mem_dat[15:0]};
                        w_d_t.mem_tk = 1;
                    end
                    4'b0010: begin // lw
                        w_d_t.mem_dat = mem_dat;
                        w_d_t.mem_tk = 1;
                    end
                    4'b0011: begin // lbu
                        w_d_t.mem_dat = {24{1'b0}, mem_dat[7:0]};
                        w_d_t.mem_tk = 1;
                    end
                    4'b0100: begin // lhu
                        w_d_t.mem_dat = {16{1'b0}, mem_dat[15:0]};
                        mem-dat_take_t = 1;
                    end
                    4'b0101: begin // sb
                        w_d_t.mem_dat = 0;
                        w_d_t.mem_tk = 0;
                    end
                    4'b0110: begin
                        w_d_t.mem_dat = 0;
                        w_d_t.mem_tk = 0; // sh
                    end
                    4'b0111: begin
                        w_d_t.mem_dat = 0;
                        w_d_t.mem_tk = 0; // sw
                    end
                endcase
            end
            BRANCH: begin // branch
                w_d_t.reg_tk = 0;
                w_d_t.mem_tk = 0;
                w_f_t.jmp_tk = jmp_take;
            end
            JUMP: begin
                w_d_t.reg_tk = 1;
                w_d_t.mem_tk = 0;
                w_f_t.jmp_tk = 1; // assert (w_d_t.jmp_tk = jmp_take)
            end
            default: begin
            end
        endcase
    end

    assign w_d_t.flush = w_f_t.jmp_tk;
    assign w_e_t.flush = w_f_t.jmp_tk;
    
    logic flush_t;
    dff flush_s(
        .clk(clk),
        .rst_n(rst_n),
        
        .en(1),
        .flush(0),

        .din(w_f_t.jmp_tk),
        .dout(flush_t)
    );
    
    d_register #(
        ._W($bits(w_d_WI))
    ) w_d_s (
        .clk(clk),
        .rst_n(rst_n),

        .en(stall_in),
        .flush(flush_t),

        .din(w_d_t),
        .dout(w_d_out)
    );
    d_register #(
        ._W($bits(w_f_WI))
    ) w_f_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(stall_in),
        .flush(flush),

        .din(w_f_t),
        .dout(w_f_out)
    );
    d_register #(
        ._W($bits(w_e_WI))
    ) w_e_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(stall_in),
        .flush(flush),

        .din(w_f_t),
        .dout(w_f_out)
    );


endmodule;