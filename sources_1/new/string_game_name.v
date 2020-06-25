`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2020 21:43:19
// Design Name: 
// Module Name: string_game_name
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


module string_game_name(
  input wire clk,
  input wire rst,
  input wire module_en,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
    
  localparam CHAR_WIDHT = 8;
  localparam TEXT_SIZE_X = 7;
  localparam TEXT_SIZE_Y = 1;
  localparam FONT_SIZE = 3;
  localparam TEXT_POS_X = (`GAME_WIDTH / 2) - ((TEXT_SIZE_X * CHAR_WIDHT * (2**(FONT_SIZE-1))) / 2) - 1;
  localparam TEXT_POS_Y = 120;
    
  reg [6:0] char_code;
  wire [3:0] char_line;
  wire [7:0] char_xy, char_line_pixels;
    
  draw_rect_char #(
    .TEXT_COLOUR(12'h03A),
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
      8'h00: char_code = "S"; 
      8'h10: char_code = "k";
      8'h20: char_code = "y"; 
      8'h30: char_code = " "; 
      8'h40: char_code = "H"; 
      8'h50: char_code = "o"; 
      8'h60: char_code = "p"; 
      default: char_code = 7'h00;
    endcase
    
endmodule
