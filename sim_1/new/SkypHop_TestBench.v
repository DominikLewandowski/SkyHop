`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 14:27:05
// Design Name: 
// Module Name: SkypHop_TestBench
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


module SkypHop_TestBench();

  reg clk;
  reg rst;
  wire vs, hs;
  wire [3:0] r, g, b;
  
  reg [2:0] sw;
  wire led;
  
  initial
  begin
   rst = 1'b0;
   sw = 3'b000;
  end

  SkyHop mySkyHop (
    .rst(rst),
    .clk(clk),
    .sw(sw),
    .led(led),
    .vs(vs),
    .hs(hs),
    .r(r),
    .g(g),
    .b(b)
  );

  always
  begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end
  
  initial
  begin
    wait (vs == 1'b0);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    $stop;
  end
  
endmodule
