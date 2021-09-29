

module neuai_demo_led_breath(input w_clk, input [0:3] w_key, output [0:3] w_led);

// 定义变量
wire w_clk_1s;
wire w_clk_1ms;
wire w_clk_1us;
wire w_compare;

reg [9:0]r_cnt_1ms;
reg [9:0]r_cnt_1us;
reg      r_cnt_s;

// 数据流赋值
assign w_rst = w_key[0];
assign w_compare = (r_cnt_1us > r_cnt_1ms) ? 1'b1 : 1'b0;
assign w_led[1:3] = 3'b111;
assign w_led[0] = (r_cnt_s == 0) ? (w_compare) : (~w_compare);

// 结构型建模
// 创建时钟实例
clk_1s  u_clk_1s (.rst(w_rst), .clk_in(w_clk), .clk_out(w_clk_1s));
clk_1ms u_clk_1ms(w_rst, w_clk, w_clk_1ms);
clk_1us u_clk_1us(w_rst, w_clk, w_clk_1us);

// 行为级建模
// todo: 毫秒和微妙，0~999 范围内计数
// ms
always @(posedge w_clk_1ms or negedge w_rst) begin
    if(w_rst == 0)
        r_cnt_1ms <= 0;
    else begin
        if (r_cnt_1ms == 999)
            r_cnt_1ms <= 0;
        else
            r_cnt_1ms <= r_cnt_1ms + 1'b1;
    end
end

//us
always @(posedge w_clk_1us or negedge w_rst) begin
    if(w_rst == 0)
        r_cnt_1us <= 0;
    else begin
        if (r_cnt_1us == 999)
            r_cnt_1us <= 0;
        else
            r_cnt_1us <= r_cnt_1us + 1'b1;
    end
end

always @(posedge w_clk_1s or negedge w_rst) begin
    if(w_rst == 0)
        r_cnt_s <= 0;
    else begin
        r_cnt_s = ~r_cnt_s;
    end
end


endmodule

