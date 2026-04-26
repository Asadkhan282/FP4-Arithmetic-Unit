// =================================================================
//  FP4 Top-Level - 200 MHz on Artix-7 xc7a35tcpg236-1
//  Supports: multiply (op=0), add (op=1), MAC (op=2)
// =================================================================

module fp4_top_200 (
    input  wire        clk,
    input  wire        rst,
    input  wire [1:0]  op,       // 0=mul  1=add  2=mac
    input  wire        valid_in,
    input  wire [3:0]  a,
    input  wire [3:0]  b,
    input  wire [3:0]  c,        // MAC addend (ignored for mul/add)
    output reg  [3:0]  result,
    output reg         valid_out
);
    wire [3:0] mul_r, add_r, mac_r;
    wire       mul_v, add_v, mac_v;

    fp4_mul_200 u_mul (
        .clk(clk), .rst(rst), .valid_in(valid_in),
        .a(a), .b(b), .result(mul_r), .valid_out(mul_v)
    );

    fp4_add_200 u_add (
        .clk(clk), .rst(rst), .valid_in(valid_in),
        .a(a), .b(b), .result(add_r), .valid_out(add_v)
    );

    fp4_mac_200 u_mac (
        .clk(clk), .rst(rst), .valid_in(valid_in),
        .a(a), .b(b), .c(c),
        .result(mac_r), .valid_out(mac_v)
    );

    // op selector - registered for clean timing
    reg [1:0] op_r1, op_r2;
    always @(posedge clk) begin
        if (rst) begin
            op_r1 <= 2'b00; op_r2 <= 2'b00;
        end else begin
            op_r1 <= op; op_r2 <= op_r1;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            result    <= 4'h0;
            valid_out <= 1'b0;
        end else begin
            case (op_r2)
                2'b00: begin result <= mul_r; valid_out <= mul_v; end
                2'b01: begin result <= add_r; valid_out <= add_v; end
                2'b10: begin result <= mac_r; valid_out <= mac_v; end
                default: begin result <= 4'h0; valid_out <= 1'b0; end
            endcase
        end
    end

endmodule