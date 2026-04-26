// =================================================================
//  FP4 E2M1 Adder - Optimised for 200 MHz on Artix-7
//  Identical pipeline structure to fp4_mul_200
// =================================================================

(* KEEP_HIERARCHY = "yes" *)
module fp4_add_200 (
    input  wire        clk,
    input  wire        rst,
    input  wire        valid_in,
    input  wire [3:0]  a,
    input  wire [3:0]  b,
    output reg  [3:0]  result,
    output reg         valid_out
);

    (* ram_style = "distributed" *)
    reg [3:0] add_lut [0:255];

    initial $readmemh("fp4_add_lut.mem", add_lut);

    (* KEEP = "true" *) reg [7:0] addr_s1;
    (* KEEP = "true" *) reg       valid_s1;

    always @(posedge clk) begin
        if (rst) begin
            addr_s1  <= 8'h00;
            valid_s1 <= 1'b0;
        end else begin
            addr_s1  <= {a, b};
            valid_s1 <= valid_in;
        end
    end

    wire [3:0] lut_data = add_lut[addr_s1];

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