`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2020 06:41:23
// Design Name: 
// Module Name: string_spacebar
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


module string_spacebar(
  input wire clk,
  input wire rst,
  input wire module_en,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  localparam CHAR_WIDHT = 8;
  localparam TEXT_SIZE_X = 16;
  localparam TEXT_SIZE_Y = 1;
  localparam FONT_SIZE = 1;
  localparam TEXT_POS_X = (`GAME_WIDTH / 2) - ((TEXT_SIZE_X * CHAR_WIDHT * (2**(FONT_SIZE-1))) / 2) - 1;
  localparam TEXT_POS_Y = 480;
  
  reg [6:0] char_code;
  wire [3:0] char_line;
  wire [7:0] char_xy, char_line_pixels;
  
  draw_rect_char #(
    .TEXT_COLOUR(12'hFFF),
    .FONT_SIZE(FONT_SIZE),
    .TEXT_POS_X(TEXT_POS_X),
    .TEXT_POS_Y(TEXT_POS_Y),
    .TEXT_SIZE_X(TEXT_SIZE_X),
    .TEXT_SIZE_Y(TEXT_SIZE_Y)
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
      8'h00: char_code = "["; 
      8'h10: char_code = "P";
      8'h20: char_code = "r"; 
      8'h30: char_code = "e"; 
      8'h40: char_code = "s"; 
      8'h50: char_code = "s"; 
      8'h60: char_code = " "; 
      8'h70: char_code = "S"; 
      8'h80: char_code = "P"; 
      8'h90: char_code = "A"; 
      8'hA0: char_code = "C"; 
      8'hB0: char_code = "E";
      8'hC0: char_code = "B";
      8'hD0: char_code = "A";
      8'hE0: char_code = "R";
      8'hF0: char_code = "]"; 
      default: char_code = 7'h00;
    endcase
  
endmodule
