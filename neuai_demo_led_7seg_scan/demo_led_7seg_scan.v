module demo_led_7seg_scan(input clk, input [3:0]key, output [7:0] seg_dat, output [3:0] sel);

wire w_clk, w_clk_ms;
wire w_rst;
reg [7:0] r_seg_out;
reg [3:0] r_sel;
reg [1:0] r_sel_cnt;

assign w_rst = key[0];
assign w_clk = clk;
assign seg_dat = r_seg_out;
assign sel = r_sel;

// 毫秒时钟分频器
clk_1ms  u_clk_ms (.rst(w_rst), .clk_in(w_clk), .clk_out(w_clk_ms));

reg [7:0] r_seg_code[0:9];
always @(negedge w_rst or negedge key[1]) begin
    if(w_rst == 0) begin
    r_seg_code[0] <= 8'b0011_1111;
    r_seg_code[1] <= 8'b0000_0110;
    r_seg_code[2] <= 8'b1111_1111;
    r_seg_code[3] <= 8'b1111_1111;
    end
    else if(key[1] == 0) begin
        r_seg_code[0] <= ~r_seg_code[0];
        r_seg_code[1] <= ~r_seg_code[1];
        r_seg_code[2] <= ~r_seg_code[2];
        r_seg_code[3] <= ~r_seg_code[3];
    end
end

// 选择寄存器输出
always @(negedge w_clk_ms or negedge w_rst) begin
    if(w_rst == 0) begin
        r_seg_out <= 4'd0;
        r_sel <= 4'b1111;
    end else begin
        r_seg_out <= ~r_seg_code[r_sel_cnt]; //刷新数据
        r_sel <= ~(4'b1<<r_sel_cnt); // 刷新位选
    end
end

// 位选更新
always @(posedge w_clk_ms or negedge w_rst) begin
    if(w_rst == 0) begin
        r_sel_cnt <= 2'd0;
    end else begin
        r_sel_cnt <= r_sel_cnt + 2'b1;
    end
end

endmodule