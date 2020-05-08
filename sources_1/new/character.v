`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2020 00:10:03
// Design Name: 
// Module Name: character
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


module character(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire jump_left,
  input wire jump_right,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  reg [8:0] character_x, character_x_nxt;       // <0:799>
  reg [8:0] character_y, character_y_nxt;       // <0:599>
  reg [3:0] character_pos, character_pos_nxt;   // <0:8>
  
  localparam CHARACTER_COLOR = 12'h0F0;
  
  draw_rect #(
    .RECT_COLOUR(CHARACTER_COLOR),
    .RECT_WIDTH(80),
    .RECT_HEIGHT(80)
  ) my_draw_rect (
    .module_en(module_en),
    .xpos(character_x),
    .ypos(character_y),
    .vga_bus_in(vga_bus_in),
    .vga_bus_out(vga_bus_out),   
    .pclk(clk),
    .rst(rst)
  );
  
  always @*
  begin
    character_y_nxt = 500;
    if(jump_left == 1) character_x_nxt = 200;
    else if(jump_right == 1) character_x_nxt = 400;
    else character_x_nxt = character_x;
    
  end    

  always@(posedge clk)
    if (rst) begin
      character_x <= 0;
      character_y <= 0;
      character_pos <= 0;
    end
    else begin
      character_x <= character_x_nxt;
      character_y <= character_y_nxt;
      character_pos <= character_pos_nxt;
    end    
endmodule
