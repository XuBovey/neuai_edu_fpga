module clk_div (
    input       rst, clk_int,
    output reg  clk_out
);

parameter CLK_DIV_PERIOD = 12_000_000; // default 1Hz from 12Mhz input

reg [24:0] cnt = 25'd0;

always 
    @(posedge clk_int or negedge rst) begin
        if(rst == 0) begin
            cnt <= 1'b0;
            clk_out <= 1'b0;
        end else begin
            if(cnt == (CLK_DIV_PERIOD - 1)) begin
                cnt <= 1'b0;
            end else begin
                cnt <= cnt + 1'b1;
            end

            if(cnt < (CLK_DIV_PERIOD>>1)) begin
                clk_out <= 1'b1;
            end else begin
                clk_out <= 1'b0;
            end
        end
    end
endmodule


module clk_1s (
    input rst, clk_in,
    output clk_out
);
    clk_div #(12_000_000)  m_clk_div_1s (rst, clk_in, clk_out);
endmodule


module clk_1ms (
    input rst, clk_in,
    output clk_out
);
    clk_div #(12_000)  m_clk_div_1ms (rst, clk_in, clk_out);
endmodule


module clk_1us (
    input rst, clk_in,
    output clk_out
);
    clk_div #(12)  m_clk_div_1us (rst, clk_in, clk_out);
endmodule
