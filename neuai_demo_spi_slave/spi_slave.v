

module spi_slave (
    input wire  clk,
    input wire  sck,
    input wire  mosi,
    output wire miso,
    input wire  ssel,
    output reg  byteReceived = 1'b0,
    output reg  [7:0] receivedData,
    output wire dataNeeded,
    input wire  [7:0] dataToSend
);


reg [1:0] r_sck;
reg [1:0] r_mosi;
reg [2:0] r_bitcnt;
reg [7:0] r_dataToSendBuf;

// SPI时钟采样
always @(posedge clk) begin
    if(ssel)
        r_sck <= 2'b00;
    else
        r_sck <= {r_sck[0], sck};
end

// 检测时钟边沿
wire w_sck_posedge = (r_sck == 2'b01);
wire w_sck_negedge = (r_sck == 2'b10);

// mosi数据接收
always @(posedge clk) begin
    if(ssel)
        r_mosi <= 2'b00;
    else
        r_mosi <= {r_mosi[0], mosi}; // 数据缓冲至r_mosi
end
wire w_mosi_data = r_mosi[1];

// 接收数据串转并
always @(posedge clk) begin
    if(ssel) begin
        r_bitcnt <= 3'd0;
        receivedData <= 8'd0;
    end
    else if(w_sck_posedge) begin// 上升沿输入数据
        r_bitcnt <= r_bitcnt + 3'b1;
        receivedData <= {receivedData[6:0], w_mosi_data}; // MSB, 从低位存入，循环8次后，第一个数据存入bit7，最后的数据存入bit0
    end
end

// 判断接收数据有效, 输出为脉冲信号，持续1个时钟周期
always @(posedge clk) begin
    if(ssel)
        byteReceived <= 1'b0;
    else
        byteReceived <= w_sck_posedge && r_bitcnt == 3'b111;
end

// miso数据输出
always @(posedge clk) begin
    if(ssel)
        r_dataToSendBuf <= 8'd0;
    else begin
        if(r_bitcnt == 3'd0) 
            r_dataToSendBuf <= dataToSend;
        else begin
            // 脉冲有效信号只会出现一个时钟周期，请分析原因
            // 下降沿输出数据
            if(w_sck_negedge) 
                r_dataToSendBuf <= {r_dataToSendBuf[6:0], 1'b0}; // 数据左移，低位补零
        end
    end
end

assign dataNeeded = ~ssel && (r_bitcnt == 3'b000); // 数据发送完成标志
assign miso = r_dataToSendBuf[7]; // MSB

endmodule


