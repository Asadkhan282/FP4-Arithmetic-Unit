// =================================================================
//  FP4 E2M1 Multiplier - Optimised for 200 MHz on Artix-7
//  Format : [3]=sign  [2:1]=exponent(bias=1)  [0]=mantissa
//  Strategy: 3-stage pipeline around a 256-entry LUTRAM
//  Latency : 2 clock cycles
//  Throughput: 1 result per clock cycle
// =================================================================

(* KEEP_HIERARCHY = "yes" *)
module fp4_mul_200 (
    input  wire        clk,
    input  wire        rst,      // synchronous active-high reset
    input  wire        valid_in,
    input  wire [3:0]  a,
    input  wire [3:0]  b,
    output reg  [3:0]  result,
    output reg         valid_out
);

    // ?? LUTRAM: all 256 FP4×FP4 results precomputed ??????????????
    // Attribute forces Vivado to use distributed RAM (1-cycle read)
    (* ram_style = "distributed" *)
    reg [3:0] mul_lut [0:255];

    initial $readmemh("fp4_mul_lut.mem", mul_lut);

    // ?? Stage 1 registers: latch inputs and form address ?????????
    (* KEEP = "true" *) reg [7:0] addr_s1;
    (* KEEP = "true" *) reg       valid_s1;

    always @(posedge clk) begin
        if (rst) begin
            addr_s1  <= 8'h00;
            valid_s1 <= 1'b0;
        end else begin
            addr_s1  <= {a, b};     // 8-bit index into 256-entry LUT
            valid_s1 <= valid_in;
        end
    end

    // ?? Stage 2: LUTRAM read (combinational within this stage) ???
    // LUTRAM output is registered in stage 3 - gives full cycle
    // for routing between LUTRAM output and output FF
    wire [3:0] lut_data = mul_lut[addr_s1];

    // ?? Stage 3: output register ?????????????????????????????????
    always @(posedge clk) begin
        if (rst) begin
            result    <= 4'h0;
            valid_out <= 1'b0;
        end else begin
            result    <= lut_data;
            valid_out <= valid_s1;
        end
    end

endmodule