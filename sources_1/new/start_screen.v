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
  
  localparam CHAR_WIDHT = 8;
  localparam TEXT_1_POS_X = (`GAME_WIDTH / 2) - ((7 * CHAR_WIDHT * 4) / 2) - 1;
  localparam TEXT_2_POS_X = (`GAME_WIDTH / 2) - ((16 * CHAR_WIDHT * 2) / 2) - 1;
  
  reg [6:0] char_code_1;
  wire [3:0] char_line_1;
  wire [7:0] char_xy_1, char_line_pixels_1;
  
  draw_rect_char #(
    .TEXT_COLOUR(12'h03A),
    .FONT_SIZE(3),
    .TEXT_POS_X(TEXT_1_POS_X),
    .TEXT_POS_Y(120),
    .TEXT_SIZE_X(7),
    .TEXT_SIZE_Y(1)
  ) text_unit_1 (
    .text_en(module_en),
    .vga_bus_in(vga_bus_in),
    .char_pixels(char_line_pixels_1),
    .vga_bus_out(vga_bus),
    .char_xy(char_xy_1),
    .char_line(char_line_1),
    .clk(clk),
    .rst(rst)
  ); 
    
  font_rom my_font_rom_1 (
    .clk(clk),  
    .addr({char_code_1, char_line_1}),       
    .char_line_pixels(char_line_pixels_1) 
  );
  
  always@*
    casex(char_xy_1)
      8'h00: char_code_1 = "S"; 
      8'h10: char_code_1 = "k";
      8'h20: char_code_1 = "y"; 
      8'h30: char_code_1 = " "; 
      8'h40: char_code_1 = "H"; 
      8'h50: char_code_1 = "o"; 
      8'h60: char_code_1 = "p"; 
      default: char_code_1 = 7'h00;
    endcase
  
  reg [6:0] char_code_2;
  wire [3:0] char_line_2;
  wire [7:0] char_xy_2, char_line_pixels_2;
  
  draw_rect_char #(
    .TEXT_COLOUR(12'hFFF),
    .FONT_SIZE(2),
    .TEXT_POS_X(TEXT_2_POS_X),
    .TEXT_POS_Y(200),
    .TEXT_SIZE_X(16),
    .TEXT_SIZE_Y(6)
  ) text_unit_2 (
    .text_en(module_en),
    .vga_bus_in(vga_bus),
    .char_pixels(char_line_pixels_2),
    .vga_bus_out(vga_bus_out),
    .char_xy(char_xy_2),
    .char_line(char_line_2),
    .clk(clk),
    .rst(rst)
  ); 
    
  font_rom my_font_rom_2 (
    .clk(clk),  
    .addr({char_code_2, char_line_2}),       
    .char_line_pixels(char_line_pixels_2) 
  );
    
  always@*
    casex(char_xy_2)
      8'h00: char_code_2 = "U"; 
      8'h10: char_code_2 = "s";
      8'h20: char_code_2 = "e"; 
      8'h30: char_code_2 = " "; 
      8'h40: char_code_2 = "l"; 
      8'h50: char_code_2 = "e"; 
      8'h60: char_code_2 = "f"; 
      8'h70: char_code_2 = "t"; 
      8'h80: char_code_2 = " "; 
      8'h90: char_code_2 = "a"; 
      8'hA0: char_code_2 = "r"; 
      8'hB0: char_code_2 = "r"; 
      8'hC0: char_code_2 = "o";
      8'hD0: char_code_2 = "w";
       
      8'h01: char_code_2 = "t"; 
      8'h11: char_code_2 = "o"; 
      8'h21: char_code_2 = " "; 
      8'h31: char_code_2 = "h"; 
      8'h41: char_code_2 = "o"; 
      8'h51: char_code_2 = "p"; 
      8'h61: char_code_2 = " "; 
      8'h71: char_code_2 = "l"; 
      8'h81: char_code_2 = "e"; 
      8'h91: char_code_2 = "f"; 
      8'hA1: char_code_2 = "t"; 
      
      8'h02: char_code_2 = "U"; 
      8'h12: char_code_2 = "s";
      8'h22: char_code_2 = "e"; 
      8'h32: char_code_2 = " "; 
      8'h42: char_code_2 = "r"; 
      8'h52: char_code_2 = "i"; 
      8'h62: char_code_2 = "g"; 
      8'h72: char_code_2 = "h"; 
      8'h82: char_code_2 = "t"; 
      8'h92: char_code_2 = " "; 
      8'hA2: char_code_2 = "a"; 
      8'hB2: char_code_2 = "r"; 
      8'hC2: char_code_2 = "r";
      8'hD2: char_code_2 = "o"; 
      8'hE2: char_code_2 = "w";
       
      8'h03: char_code_2 = "t"; 
      8'h13: char_code_2 = "o"; 
      8'h23: char_code_2 = " "; 
      8'h33: char_code_2 = "h"; 
      8'h43: char_code_2 = "o"; 
      8'h53: char_code_2 = "p"; 
      8'h63: char_code_2 = " "; 
      8'h73: char_code_2 = "r"; 
      8'h83: char_code_2 = "i"; 
      8'h93: char_code_2 = "g"; 
      8'hA3: char_code_2 = "h";
      8'hB3: char_code_2 = "t";
      
      8'h04: char_code_2 = "D"; 
      8'h14: char_code_2 = "o";
      8'h24: char_code_2 = "n"; 
      8'h34: char_code_2 = "'"; 
      8'h44: char_code_2 = "t"; 
      8'h54: char_code_2 = " "; 
      8'h64: char_code_2 = "f"; 
      8'h74: char_code_2 = "a"; 
      8'h84: char_code_2 = "l"; 
      8'h94: char_code_2 = "l"; 
      8'hA4: char_code_2 = "!"; 
      
      8'h05: char_code_2 = "G"; 
      8'h15: char_code_2 = "O";
      8'h25: char_code_2 = "O"; 
      8'h35: char_code_2 = "D"; 
      8'h45: char_code_2 = " "; 
      8'h55: char_code_2 = "L"; 
      8'h65: char_code_2 = "U"; 
      8'h75: char_code_2 = "C"; 
      8'h85: char_code_2 = "K"; 
      8'h95: char_code_2 = " "; 
      8'hA5: char_code_2 = ":"; 
      8'hB5: char_code_2 = ")"; 
       
      default: char_code_2 = 7'h00;
    endcase
    
endmodule
