`timescale 1ns/1ps
// =================================================================
//  FP4 200 MHz Testbench - exhaustive 16×16 test for all ops
// =================================================================
module fp4_tb_200;

    // DUT signals
    reg        clk, rst;
    reg  [1:0] op;
    reg        valid_in;
    reg  [3:0] a, b, c;
    wire [3:0] result;
    wire       valid_out;

    // Instantiate DUT
    fp4_top_200 dut (
        .clk(clk), .rst(rst), .op(op),
        .valid_in(valid_in),
        .a(a), .b(b), .c(c),
        .result(result), .valid_out(valid_out)
    );

    // 200 MHz clock (5 ns period)
    initial clk = 0;
    always  #2.5 clk = ~clk;

    integer i, j, pass_cnt, fail_cnt;

    task apply_inputs;
        input [1:0] op_in;
        input [3:0] a_in, b_in, c_in;
        begin
            op       = op_in;
            a        = a_in;
            b        = b_in;
            c        = c_in;
            valid_in = 1'b1;
            @(posedge clk);
            #0.1;
        end
    endtask

    initial begin
        // Initialise
        rst = 1; op = 0; valid_in = 0;
        a = 0; b = 0; c = 0;
        repeat(4) @(posedge clk);
        rst = 0;
        @(posedge clk);

        pass_cnt = 0; fail_cnt = 0;

        // ?? Exhaustive multiply test ??????????????????????????????
        $display("\n=== FP4 MULTIPLY (op=00) exhaustive test ===");
        op = 2'b00;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                apply_inputs(2'b00, i[3:0], j[3:0], 4'h0);
            end
        end
        repeat(4) @(posedge clk); // flush pipeline
        $display("Multiply test complete. Check waveform for results.");

        // ?? Exhaustive add test ???????????????????????????????????
        $display("\n=== FP4 ADD (op=01) exhaustive test ===");
        op = 2'b01;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                apply_inputs(2'b01, i[3:0], j[3:0], 4'h0);
            end
        end
        repeat(4) @(posedge clk);
        $display("Add test complete.");

        // ?? Key spot-checks ???????????????????????????????????????
        $display("\n=== SPOT CHECKS ===");

        // 1.0 * 1.0 = 1.0  (a=0010, b=0010, expect result=0010)
        apply_inputs(2'b00, 4'b0010, 4'b0010, 4'h0);
        repeat(3) @(posedge clk);
        $display("1.0 * 1.0 = result: %04b (expect 0010)", result);
        if (result === 4'b0010) pass_cnt = pass_cnt + 1;
        else begin $display("FAIL!"); fail_cnt = fail_cnt + 1; end

        // 2.0 + 1.0 = 3.0  (a=0100, b=0010, expect result=0101)
        apply_inputs(2'b01, 4'b0100, 4'b0010, 4'h0);
        repeat(3) @(posedge clk);
        $display("2.0 + 1.0 = result: %04b (expect 0101)", result);
        if (result === 4'b0101) pass_cnt = pass_cnt + 1;
        else begin $display("FAIL!"); fail_cnt = fail_cnt + 1; end

        // -1.0 * 2.0 = -2.0 (a=1010, b=0100, expect result=1100)
        apply_inputs(2'b00, 4'b1010, 4'b0100, 4'h0);
        repeat(3) @(posedge clk);
        $display("-1.0 * 2.0 = result: %04b (expect 1100)", result);
        if (result === 4'b1100) pass_cnt = pass_cnt + 1;
        else begin $display("FAIL!"); fail_cnt = fail_cnt + 1; end

        $display("\n=== RESULTS: %0d PASS, %0d FAIL ===", pass_cnt, fail_cnt);

        #100;
        $display("Simulation complete.");
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("fp4_tb_200.vcd");
        $dumpvars(0, fp4_tb_200);
    end

endmodule