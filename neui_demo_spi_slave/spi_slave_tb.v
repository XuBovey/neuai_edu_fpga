`timescale 1ns/1ps


module demo_spi_slave_tp();

reg sys_clk;
reg sck;
reg mosi;
wire miso;
reg ssel;

wire w_byteReceived;
wire[7:0] w_receivedData;
wire w_dataNeeded;
reg[7:0] r_dataToSend;

reg[7:0] r_misoData;
reg[7:0] r_mosiData;
integer i;

// 时钟
always begin
    sys_clk = 1'b0;
    forever
        #1 sys_clk = ~sys_clk;
end

// 创建spi_slave实例
// 上升沿输入，下降沿输出
spi_slave u_spi_slave(sys_clk, sck, mosi, miso, ssel, w_byteReceived, w_receivedData, w_dataNeeded, r_dataToSend);

// 模拟主设备发送数据
initial begin
    sck = 1'b0;
    mosi = 1'b0;
    ssel = 1'b1;
    r_misoData = 8'h0;

    # 20 ssel = 1'b0; // cs 使能
    r_mosiData = 8'ha5;
    r_dataToSend = 8'h5a;
    
    for (i = 7; i >= 0; i=i-1) begin
        mosi = r_mosiData[i]; 
        #10 sck = 1'b1; 
        r_misoData <= { r_misoData[6:0], miso };
        #10 sck = 1'b0; 
    end
    ssel = 1'b1;
    /*
    #10 mosi = r_mosiData[7]; #10 sck = 1'b0; #10 sck = 1'b1; #10 r_misoData <= { r_misoData[6:0], miso }; // bit 0
    #10 mosi = r_mosiData[6]; #10 sck = 1'b0; #10 sck = 1'b1; #10 r_misoData <= { r_misoData[6:0], miso }; // bit 1
    #10 mosi = r_mosiData[5]; #10 sck = 1'b0; #10 sck = 1'b1; #10 r_misoData <= { r_misoData[6:0], miso }; // bit 2
    #10 mosi = r_mosiData[4]; #10 sck = 1'b0; #10 sck = 1'b1; #10 r_misoData <= { r_misoData[6:0], miso }; // bit 3
    #10 mosi = r_mosiData[3]; #10 sck = 1'b0; #10 sck = 1'b1; #10 r_misoData <= { r_misoData[6:0], miso }; // bit 4
    #10 mosi = r_mosiData[2]; #10 sck = 1'b0; #10 sck = 1'b1; #10 r_misoData <= { r_misoData[6:0], miso }; // bit 5
    #10 mosi = r_mosiData[1]; #10 sck = 1'b0; #10 sck = 1'b1; #10 r_misoData <= { r_misoData[6:0], miso }; // bit 6
    #10 mosi = r_mosiData[0]; #10 sck = 1'b0; #10 sck = 1'b1; #10 r_misoData <= { r_misoData[6:0], miso }; // bit 7
    */
end

endmodule


