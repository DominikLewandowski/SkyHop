`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2020 13:58:54
// Design Name: 
// Module Name: string_game_end
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


module string_game_end(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire jump_fail,
  
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
    
  localparam CHAR_WIDHT = 8;
  localparam TEXT_SIZE_X = 14;
  localparam TEXT_SIZE_Y = 1;
  localparam FONT_SIZE = 2;
  localparam TEXT_POS_X = (`GAME_WIDTH / 2) - ((TEXT_SIZE_X * CHAR_WIDHT * (2**(FONT_SIZE-1))) / 2) - 1;
  localparam TEXT_POS_Y = 120;
    
  reg [6:0] char_code_1, char_code_2;
  wire [6:0] char_code = (jump_fail) ? char_code_2 : char_code_1;
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
      8'h00: char_code_1 = "E"; 
      8'h10: char_code_1 = "N";
      8'h20: char_code_1 = "D"; 
      8'h30: char_code_1 = " "; 
      8'h40: char_code_1 = "O"; 
      8'h50: char_code_1 = "F"; 
      8'h60: char_code_1 = " "; 
      8'h70: char_code_1 = "T"; 
      8'h80: char_code_1 = "I"; 
      8'h90: char_code_1 = "M"; 
      8'hA0: char_code_1 = "E"; 
      8'hB0: char_code_1 = " "; 
      8'hC0: char_code_1 = ":";
      8'hD0: char_code_1 = "P";
      default: char_code_1 = 7'h00;
    endcase   
    
  always@*
    casex(char_xy)
      8'h00: char_code_2 = "Y"; 
      8'h10: char_code_2 = "O";
      8'h20: char_code_2 = "U"; 
      8'h30: char_code_2 = " "; 
      8'h40: char_code_2 = "F"; 
      8'h50: char_code_2 = "A"; 
      8'h60: char_code_2 = "I"; 
      8'h70: char_code_2 = "L"; 
      8'h80: char_code_2 = "E"; 
      8'h90: char_code_2 = "D"; 
      8'hA0: char_code_2 = " "; 
      8'hB0: char_code_2 = ":"; 
      8'hC0: char_code_2 = "(";
      8'hD0: char_code_2 = " ";
      default: char_code_2 = 7'h00;
    endcase  
endmodule
