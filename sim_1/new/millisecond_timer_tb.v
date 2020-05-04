`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 20:45:55
// Design Name: 
// Module Name: millisecond_timer_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module millisecond_timer_tb();

  reg clk;
  reg rst;
  wire one_ms_tick;
  
  initial rst = 1'b0;

  millisecond_timer mymillisecond_timer (
    .clk_40MHz(clk), 
    .rst(rst),
    .one_milli_tick(one_ms_tick)
  );

  always
  begin
    clk = 1'b0;
    #12.5;
    clk = 1'b1;
    #12.5;
  end

endmodule
