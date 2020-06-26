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
  input wire one_sec_tick,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus [1:0];
  
  reg disp_en, disp_en_nxt;
  
  string_game_name string_1 (
    .clk(clk),
    .rst(rst),
    .module_en(module_en),
    .vga_bus_in(vga_bus_in),
    .vga_bus_out(vga_bus[0])
  );
  
  string_game_info string_2 (
    .clk(clk),
    .rst(rst),
    .module_en(module_en),
    .vga_bus_in(vga_bus[0]),
    .vga_bus_out(vga_bus[1])
  );
  
  string_spacebar string_3 (
    .clk(clk),
    .rst(rst),
    .module_en(module_en & disp_en),
    .vga_bus_in(vga_bus[1]),
    .vga_bus_out(vga_bus_out)
);
  
  always @*
    if(one_sec_tick) disp_en_nxt = ~disp_en;
    else disp_en_nxt = disp_en;
  
  always @(posedge clk)
    disp_en <= disp_en_nxt;

endmodule
