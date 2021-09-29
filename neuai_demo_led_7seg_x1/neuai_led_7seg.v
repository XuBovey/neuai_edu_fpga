module neuai_demo_led_7seg_x1(input clk, input [3:0]key, output [7:0] led_7seg, output dig1);

wire w_clk, w_clk_1s;
wire w_rst;
reg [3:0] r_sec_cnt = 0;
reg [7:0] r_seg_out;

assign w_rst = key[0];
assign w_clk = clk;
assign led_7seg = r_seg_out;
assign dig1 = 0;

// 1秒时钟分频器
// todo
clk_1s  u_clk_1s (.rst(w_rst), .clk_in(w_clk), .clk_out(w_clk_1s));

// 1秒计数器，计数范围0~9, r_sec_cnt = r_sec_cnt + 1
// todo
always @(posedge w_clk_1s or negedge w_rst) begin
    if(w_rst == 0)
        r_sec_cnt <= 0;
    else begin
        if(r_sec_cnt == 3)
            r_sec_cnt <= 0;
        else
            r_sec_cnt <= r_sec_cnt + 1'b1;
    end
end

// 4-10译码器
always @(posedge w_clk_1s or negedge w_rst) begin
    if(w_rst == 0)
        r_seg_out <= 0;
    else
        case(r_sec_cnt)          // pgfe dcba
            0: r_seg_out <= 8'b0011_1111;
            1: r_seg_out <= 8'b0000_0110;
            2: r_seg_out <= 8'b0011_1011;
            // todo
            3: r_seg_out <= 8'b1111_1111;
            

            default: r_seg_out <= r_seg_out;
        endcase
end

endmodule