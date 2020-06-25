`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 17:36:33
// Design Name: 
// Module Name: start_screen
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


module start_screen(
  input wire clk,
  input wire rst,
  input wire module_en,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus;
  
  string_game_name string_1 (
    .clk(clk),
    .rst(rst),
    .module_en(module_en),
    .vga_bus_in(vga_bus_in),
    .vga_bus_out(vga_bus)
  );
  
  string_game_info string_2 (
    .clk(clk),
    .rst(rst),
    .module_en(module_en),
    .vga_bus_in(vga_bus),
    .vga_bus_out(vga_bus_out)
  );

endmodule
