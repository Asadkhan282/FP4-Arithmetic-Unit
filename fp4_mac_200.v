// =================================================================
//  FP4 MAC - multiply then add, fully pipelined @ 200 MHz
//  Latency: 4 cycles  |  Throughput: 1/cycle
// =================================================================

(* KEEP_HIERARCHY = "yes" *)
module fp4_mac_200 (
    input  wire        clk,
    input  wire        rst,
    input  wire        valid_in,
    input  wire [3:0]  a,        // multiplicand
    input  wire [3:0]  b,        // multiplier
    input  wire [3:0]  c,        // addend (accumulate)
    output wire [3:0]  result,
    output wire        valid_out
);
    wire [3:0] mul_result;
    wire       mul_valid;

    // Stage 1-2: Multiply (2-cycle latency)
    fp4_mul_200 u_mul (
        .clk(clk), .rst(rst),
        .valid_in(valid_in),
        .a(a), .b(b),
        .result(mul_result),
        .valid_out(mul_valid)
    );

    // Delay c to align with mul_result (2 cycle delay to match mul latency)
    reg [3:0] c_d1, c_d2;
    reg       v_d1, v_d2;
    always @(posedge clk) begin
        if (rst) begin
            c_d1 <= 4'h0; c_d2 <= 4'h0;
            v_d1 <= 1'b0; v_d2 <= 1'b0;
        end else begin
            c_d1 <= c;         v_d1 <= valid_in;
            c_d2 <= c_d1;      v_d2 <= v_d1;
        end
    end

    // Stage 3-4: Add (2-cycle latency)
    fp4_add_200 u_add (
        .clk(clk), .rst(rst),
        .valid_in(mul_valid),
        .a(mul_result), .b(c_d2),
        .result(result),
        .valid_out(valid_out)
    );

endmodule