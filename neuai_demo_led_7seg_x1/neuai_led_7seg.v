module neuai_demo_led_7seg_x1(input clk, input [3:0]key, output [7:0] led_7seg, output dig1);

wire w_clk, w_clk_1s;
wire w_rst;
reg [3:0] r_sec_cnt = 4'd0;
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
        r_sec_cnt <= 4'd0;
    else begin
        if(r_sec_cnt == 4'd9)
            r_sec_cnt <= 4'd0;
        else
            r_sec_cnt <= r_sec_cnt + 1'b1;
    end
end


reg [7:0] r_seg_code[0:9];
always @(*) begin
    r_seg_code[0] = 8'b0011_1111;
    r_seg_code[1] = 8'b0000_0110;
    r_seg_code[2] = 8'b1111_1111;
    r_seg_code[3] = 8'b1111_1111;
    // todo
end


// 选择寄存器输出
always @(posedge w_clk_1s or negedge w_rst) begin
    if(w_rst == 0) begin
        r_seg_out <= 4'd0;
    end else
        r_seg_out <= r_seg_code[r_sec_cnt];
end


/*
// 4-10译码器
always @(posedge w_clk_1s or negedge w_rst) begin
    if(w_rst == 0)
        r_seg_out <= 4'd0;
    else
        case(r_sec_cnt)         //pgfe_dcba
            4'd0: r_seg_out <= 8'b0011_1111;
            4'd1: r_seg_out <= 8'b0000_0110;
            4'd2: r_seg_out <= 8'b0011_1011;
            4'd3: r_seg_out <= 8'b0111_1111;
            // todo

            default: r_seg_out <= 8'b1000_0000;
        endcase
end
*/
endmodule