module dff ( // non-synchronous reset
    input logic clk,
    input logic rst_n,

    input logic d,
    output logic q
)

    always_ff @(posedge clk) begin
        if (rst_n) begin
            q <= d;
        end else begin
            q <= 0;
        end
    end;

endmodule

module dff_sr ( // synchronous reset
    input logic clk,
    input logic rst_n,

    input logic d,
    output logic q
)

    always_ff @ (posedge clk, negedge rst_n) begin
        if (rst_n) begin
            q <= d;
        end else begin
            q <= 0;
        end
    end;

endmodule

module dff_nr (
    input logic clk,
    
    input logic d,
    input logic q
)

    always_ff @ (posedge clk) begin
        q <= d;
    end

endmodule