`include "../../rtl/s1_fetch/fetch.sv"
`include "../../rtl/lib/memory.sv"

module tb;

    logic clk;
    logic rst_n_mem, rst_n_fetch;

    logic read_en, write_en;
    logic [31:0] instr_addr_out_m, read_dat;
    logic [31:0] write_addr, write_dat;

    memory im (
        .clk(clk),
        .rst_n(rst_n_mem),

        .read_en(read_en),
        .read_addr(instr_addr_out_m),
        .read_dat(read_dat),
        .r_v(),

        .write_en(write_en),
        .write_addr(write_addr),
        .write_dat(write_dat),
        .w_v()
    );

    logic [31:0] instr_dat_out;
    logic stall_out_ft;
    f_d_WI f_out;
    w_f_WI w_in;

    fetch fet(
        .clk(clk),
        .rst_n(rst_n_fetch),
        .rst_addr('0),
        .instr_dat_in(read_dat),
        .instr_dat_v(1),
        .instr_addr_out_m(instr_addr_out_m),
        .f_out(f_out),
        .instr_dat_out(instr_dat_out),
        .w_in(w_in),
        .stall_out_ft(stall_out_ft)
    );

    initial begin : clk_gen // set clock
        clk = 1;
        forever #2 clk = ~clk;
    end

    initial begin
        rst_n_mem = 1;
        rst_n_fetch = 0;
        write_en = 0;
        @(posedge clk);
        rst_n_mem = 0;
        @(posedge clk);
        rst_n_mem = 1;
        write_addr = 0;
        write_dat = 0;
        write_en = 1;
        for (int i = 0; i < 128; ++i) begin
            write_dat = i * 4;
            @(posedge clk);
            ++write_addr;
        end
        write_addr = 256;
        for (int i = 256; i < 512; ++i) begin
            write_dat = i + 1;
            @(posedge clk);
            ++write_addr;
        end
        @(posedge clk);
        write_en = 0;
        read_en = 1;

        @(posedge clk);
        rst_n_fetch = 1;
        w_in.jmp_addr = 0;
        w_in.jmp_tk = 0;
        $display("RST AND REGULAR OPERATION");
        for (int i = 0; i < 32; ++i) begin
            $display("time = %0t, stall_out_ft = %d,  instr_addr_out_m = %d,  instr_dat = %d, f_out.instr_addr = %d", 
                $time, stall_out_ft, instr_addr_out_m, instr_dat_out, f_out.instr_addr);
            @(posedge clk);
        end;
        w_in.jmp_addr = 256;
        w_in.jmp_tk = 1;
        @(posedge clk);
        w_in.jmp_tk = 0;
        $display("JUMP");
        for (int i = 0; i < 32; ++i) begin
            $display("time = %0t, stall_out_ft = %d,  instr_addr_out_m = %d,  instr_dat = %d, f_out.instr_addr = %d", 
                $time, stall_out_ft, instr_addr_out_m, instr_dat_out, f_out.instr_addr);
            @(posedge clk);
        end
        #10;
        $finish;
    end

endmodule;