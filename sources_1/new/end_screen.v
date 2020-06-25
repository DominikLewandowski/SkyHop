`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2020 00:24:32
// Design Name: 
// Module Name: end_screen
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


module end_screen(
  input wire clk,
  input wire rst,
  input wire module_en,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  localparam CHAR_WIDHT = 8;
  localparam TEXT_POS_X = (`GAME_WIDTH / 2) - ((13 * CHAR_WIDHT * 2) / 2) - 1;

  reg [6:0] char_code;
  wire [3:0] char_line;
  wire [7:0] char_xy, char_line_pixels;
  
  draw_rect_char #(
    .TEXT_COLOUR(12'h03A),
    .FONT_SIZE(2),
    .TEXT_POS_X(TEXT_POS_X),
    .TEXT_POS_Y(150),
    .TEXT_SIZE_X(13),
    .TEXT_SIZE_Y(1)
  ) text_unit (
    .text_en(module_en),
    .vga_bus_in(vga_bus_in),
    .char_pixels(char_line_pixels),
    .vga_bus_out(vga_bus_out),
    .char_xy(char_xy),
    .char_line(char_line),
    .clk(clk),
    .rst(rst)
  ); 
    
  font_rom my_font_rom (
    .clk(clk),  
    .addr({char_code, char_line}),       
    .char_line_pixels(char_line_pixels) 
  );
  
  always@*
    casex(char_xy)
      8'h00: char_code = "E"; 
      8'h10: char_code = "N";
      8'h20: char_code = "D"; 
      8'h30: char_code = " "; 
      8'h40: char_code = "O"; 
      8'h50: char_code = "F"; 
      8'h60: char_code = " "; 
      8'h70: char_code = "T"; 
      8'h80: char_code = "I"; 
      8'h90: char_code = "M"; 
      8'hA0: char_code = "E"; 
      8'hB0: char_code = ":";
      8'hC0: char_code = "P";
      default: char_code = 7'h00;
    endcase   
endmodule
