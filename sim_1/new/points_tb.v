`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2020 22:27:06
// Design Name: 
// Module Name: points_tb
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


module points_tb();

  reg clk;
  reg increase;

points my_points(
  .clk(clk),
  .rst(1'b0),
  .module_en(1'b1),
  .increase(increase),

  .vcount_in(1'b0),
  .vsync_in(1'b0),
  .vblnk_in(1'b0),
  .hcount_in(1'b0),
  .hsync_in(1'b0),
  .hblnk_in(1'b0),
  .rgb_in(1'b0),
  .vcount_out(),
  .vsync_out(),
  .vblnk_out(),
  .hcount_out(),
  .hsync_out(),
  .hblnk_out(),
  .rgb_out()
  );
  
  always
  begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #3;
    increase = 1'b1;
    #2
    clk = 1'b1;
    #5;
    increase = 1'b0;
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
endmodule
