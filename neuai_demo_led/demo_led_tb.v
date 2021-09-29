`timescale 1ns/10ps

module demo_led_tb();

parameter CLK_PERIOD = 50;

wire [0:3] led;
wire [0:3] key;

reg rst;
reg sys_clk;

assign key[0] = rst;

initial
    sys_clk = 1'b0;

always
    sys_clk = #(CLK_PERIOD/2) ~sys_clk;

initial begin
    rst = 1'b0;
    # 200;
    rst = 1'b1;
end

demo_led led_test(sys_clk, key, led);

endmodule
