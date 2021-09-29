// demo_led

// step 1: open led1 and led2
/*
module demo_led
(
output led1,
output led2
);

assign led1=1'b0;
assign led2=1'b0;

endmodule

*/

// step 2: open all led1~led8
/*

module demo_led
(
output [0:7]led
);

assign led=8'b00000000;

endmodule
*/

// step 3: key ctrl led
/*
module demo_led
(
input		[0:3]key,
output 	[0:3]led
);

//assign led=key;h
or	uor_led0(led[0],key[0],key[1]);
or	uor_led1(led[1],key[2],key[3]);

endmodule
*/

// step 4: key ctrl led
/*
module demo_led
(
input		[0:3]key,
output reg	[0:3]led
);

//assign led=key;
//or	uor_led0(led[0],key[0],key[1]);
//or	uor_led1(led[1],key[2],key[3]);]

always 
	@(key[0]) begin
		led[0] = key[0];
	end

endmodule
*/

// step 5: key ctrl led blink
/*
module demo_led
(
input		[0:3]key,
output reg	[0:3]led
);

always 
	@(posedge key[0]) begin
		led[0] = ~led[0];
	end

always 
	@(posedge key[1]) begin
		led[1] = ~led[1];
	end
		
endmodule
*/

// step 5: key ctrl led blink
/*
module demo_led (clk, key, led);

input       clk;
input       [0:3]key;
output reg  [0:3]led;


parameter CLK_DIV_PERIOD = 12_000_000; // 1Hz

reg [24:0] cnt = 0;

always 
    @(posedge clk) begin
        if(cnt == (CLK_DIV_PERIOD - 1)) begin
            cnt = 0;
        end else begin
            cnt = cnt + 1;
        end

        if(cnt < (CLK_DIV_PERIOD>>1)) begin
            led[0] = 1;
        end else begin
            led[0] = 0;
        end
    end
        
endmodule
*/

/*
module clk_1ms (
input       clk_int,
output reg  clk_out);

parameter CLK_DIV_PERIOD = 120_000; // 100Hz

reg [24:0] cnt = 0;

always 
    @(posedge clk_int) begin
        if(cnt == (CLK_DIV_PERIOD - 1)) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end

        if(cnt < (CLK_DIV_PERIOD>>1)) begin
            clk_out <= 1;
        end else begin
            clk_out <= 0;
        end
    end
endmodule


module key_filter (
input       key_in,
input       clk_1ms,
output reg  key_out);

parameter DELAY = 10;

reg key_last    = 1'b1;
reg key_now     = 1'b1;
reg [0:3]cnt    = 4'd0;
wire cnt_en;

assign cnt_en = (key_last == key_now)?1'b1:1'b0;

// 按键状态更新
always @(posedge clk_1ms) begin
    key_last <= key_now;
    key_now <= key_in;
    end

// 延时消抖
always @(posedge clk_1ms)
    if(cnt_en == 1'b1)
        if(cnt == (DELAY -1))
            key_out <= key_now;
        else
            cnt <= cnt + 4'd1;
    else
        cnt <= 4'b0;
endmodule

module demo_led (
input       clk,
input       [0:3]key,
output      [0:3]led);

wire clk_1ms;
wire [0:4]key_out;

clk_1ms(clk, clk_1ms);

key_filter(key[0], clk_1ms, key_out[0]);
key_filter(key[1], clk_1ms, key_out[1]);

assign led[0] = key_out[0];

endmodule

*/
/*
module clk_div #(parameter CLK_DIV_PERIOD = 4 ) (
input       clk_int,
output reg  clk_out);

reg [24:0] cnt = 0;

always 
    @(posedge clk_int) begin
        if(cnt == (CLK_DIV_PERIOD - 1)) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end

        if(cnt < (CLK_DIV_PERIOD>>1)) begin
            clk_out <= 1;
        end else begin
            clk_out <= 0;
        end
    end
endmodule
*/

/*
module demo_led(input clk, output reg [0:3] led);

wire clk_1hz;

clk_1hz(clk, clk_1hz); // 得到1Hz时钟

reg [1:0] cnt = 0;

always @(posedge clk_1hz) begin
    case(cnt) 
        0: led <= 4'b0001;
        1: led <= 4'b0010;
        2: led <= 4'b0100;
        3: led <= 4'b1000;
        default: led <= led;
    endcase
    
    cnt = cnt + 1;
end
endmodule
*/
/*
module clk_div_1 (
input       clk_int,
output reg  clk_out);

parameter CLK_DIV_PERIOD = 4;

reg [24:0] cnt = 0;

always 
    @(posedge clk_int) begin
        if(cnt == (CLK_DIV_PERIOD - 1)) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end

        if(cnt < (CLK_DIV_PERIOD>>1)) begin
            clk_out <= 1;
        end else begin
            clk_out <= 0;
        end
    end
endmodule
*/
module demo_led(input clk, input [0:3] key, output [0:3] led);

wire clk_1hz;
wire rst;
reg [0:3] data;

assign led = data;  // 数据输出到LED
assign rst = key[0];

clk_1us m_clk_1s(rst, clk, clk_1hz);

always @(posedge clk_1hz or negedge rst) begin
    if (rst == 0)
        data <= 4'b1110;    // 复位时加载初始值
    else
        data <= {data[3], data[0:2]}; // 数据循环
    end
    
endmodule

/*

always @(posedge clk_1hz or negedge rst) begin
    if(rst == 0)
        data <= 4'b1110;
    else
        data <= {data[1:3],data[0]};
    end
    
endmodule
*/