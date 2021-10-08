module demo_spi_slave (
    input wire  clk,
    input wire  sck,
    input wire  mosi,
    output wire miso,
    input wire  ssel,
    output wire [7:0]leds
);
wire w_byteReceived;
wire[7:0] w_receivedData;
wire w_dataNeeded;
reg[7:0] r_dataToSend;
reg[7:0] r_receiveDataBuf;

// 创建spi_slave实例
spi_slave u_spi_slave(clk, sck, mosi, miso, ssel, w_byteReceived, w_receivedData, w_dataNeeded, r_dataToSend);

// 数据接收
always @(posedge clk) begin
    if(w_byteReceived)
        r_receiveDataBuf <= w_receivedData;
end

// 数据发送
always @(posedge clk) begin
    if(w_dataNeeded)
        r_dataToSend <= r_receiveDataBuf;
end

assign leds = r_receiveDataBuf;

endmodule


