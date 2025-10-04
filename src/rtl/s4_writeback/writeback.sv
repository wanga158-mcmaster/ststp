module writeback(
    input logic clk,
    input logic rst_n,

    input logic [3:0] op_type, // operation type out, unchanged
    input logic [4:0] op_spec, // operation spec out, unchanged

    input logic [4:0] rd_ind, // rd index out, unchanged
    input logic [31:0] rd_dat, // rd data

    input logic [31:0] jmp_addr, // jump pc address data
    input logic jmp_take, // jump or not

    input logic [31:0] mem_dat, // data from memory

    output logic [4:0] rd_ind_out, // rd index out, unchanged, forward to decode stage
    output logic [31:0] rd_dat_out, // rd data, forward to decode stage
    output logic rd_dat_take, // take rd data

    output logic [31:0] mem_dat_out, // memory data out
    output logic mem_dat_take, // take memory data

    output logic [31:0] jmp_addr_out, // jump pc address data, forward to fetch stage
    output logic jmp_take_out // jump or not, forward to fetch stage
);

    logic rd_dat_take_t, mem_dat_take_t, jmp_take_t;

    always_comb begin
        case (op_type)
            3'b000: begin // basic math
                rd_dat_take_t = 1;
                mem_dat_take_t = 0;
                jmp_take_t = 0;
            end
            3'b001: begin // load store
                rd_dat_take = 0;
                jmp_take_t = 0;
                case (op_spec)
                    4'b0101: mem_dat_take_t = 0; // sb
                    4'b0110: mem_dat_take_t = 0; // sh
                    4'b0111: mem_dat_take_t = 0; // sw
                    default: mem_dat_take_t = 1; // load
                endcase
            end
            3'b010: begin // branch
                rd_dat_take = 0;
                mem_dat_take_t = 0;
                jmp_take_t = jmp_take;
            end
            3'b011: begin
                rd_dat_take = 1;
                mem_dat_take_t = 0;
                jmp_take_t = 1; // assert (jmp_take_t = jmp_take)
            end
            3'b100: begin
                rd_dat_take = 1;
                mem_dat_take_t = 0;
                jmp_take_t = 0;
            end
            default: begin
            end
        endcase
    end

    d_register #(
        ._W(5)
    ) rd_ind_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),

        .din(rd_ind),
        .dout(rd_ind_out)
    );
    
    d_register rd_dat_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(rd_dat),
        .dout(rd_dat_out)
    );

    d_register rd_dat_take_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(rd_dat_take_t),
        .dout(rd_dat_take)
    );

    d_register mem_dat_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(mem_dat),
        .dout(mem_dat_out)
    );

    d_register mem_dat_take_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(mem_dat_take_t),
        .dout(mem_dat_take)
    );

    d_register jmp_addr_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(jmp_addr),
        .dout(jmp_addr_out)
    );

    d_register jmp_take_s(
        .clk(clk),
        .rst_n(rst_n),

        .en(),
        .flush(),
        
        .din(jmp_take_t),
        .dout(jmp_take_out)
    );

endmodule;