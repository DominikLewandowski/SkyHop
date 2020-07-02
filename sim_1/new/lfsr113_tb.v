`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2020 12:39:41
// Design Name: 
// Module Name: lfsr113_tb
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


module lfsr113_tb();
  reg clk;
  reg rst;
  
  wire [31:0] number_out;
  initial begin
  rst = 1'b0;
  #5000
  rst = 1'b1;
  #5000
  rst = 1'b0;
  end
  
   lfsr113 my_random (
     .clk(clk), 
     .reset(rst),
     .enable(1'b1),
     .lfsr113_prng(number_out)
  );
  
  always
  begin
    clk = 1'b0;
    #12.5;
    clk = 1'b1;
    #12.5;
  end
  
endmodule
