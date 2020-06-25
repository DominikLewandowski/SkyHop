`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2020 21:50:19
// Design Name: 
// Module Name: string_game_info
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


module string_game_info(
  input wire clk,
  input wire rst,
  input wire module_en,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
);
    
  localparam CHAR_WIDHT = 8;
  localparam TEXT_SIZE_X = 16;
  localparam TEXT_SIZE_Y = 6;
  localparam FONT_SIZE = 2;
  localparam TEXT_POS_X = (`GAME_WIDTH / 2) - ((TEXT_SIZE_X * CHAR_WIDHT * (2**(FONT_SIZE-1))) / 2) - 1;
  localparam TEXT_POS_Y = 200;  
    
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
      8'h00: char_code = "U"; 
      8'h10: char_code = "s";
      8'h20: char_code = "e"; 
      8'h30: char_code = " "; 
      8'h40: char_code = "l"; 
      8'h50: char_code = "e"; 
      8'h60: char_code = "f"; 
      8'h70: char_code = "t"; 
      8'h80: char_code = " "; 
      8'h90: char_code = "a"; 
      8'hA0: char_code = "r"; 
      8'hB0: char_code = "r"; 
      8'hC0: char_code = "o";
      8'hD0: char_code = "w";
         
      8'h01: char_code = "t"; 
      8'h11: char_code = "o"; 
      8'h21: char_code = " "; 
      8'h31: char_code = "h"; 
      8'h41: char_code = "o"; 
      8'h51: char_code = "p"; 
      8'h61: char_code = " "; 
      8'h71: char_code = "l"; 
      8'h81: char_code = "e"; 
      8'h91: char_code = "f"; 
      8'hA1: char_code = "t"; 
        
      8'h02: char_code = "U"; 
      8'h12: char_code = "s";
      8'h22: char_code = "e"; 
      8'h32: char_code = " "; 
      8'h42: char_code = "r"; 
      8'h52: char_code = "i"; 
      8'h62: char_code = "g"; 
      8'h72: char_code = "h"; 
      8'h82: char_code = "t"; 
      8'h92: char_code = " "; 
      8'hA2: char_code = "a"; 
      8'hB2: char_code = "r"; 
      8'hC2: char_code = "r";
      8'hD2: char_code = "o"; 
      8'hE2: char_code = "w";
         
      8'h03: char_code = "t"; 
      8'h13: char_code = "o"; 
      8'h23: char_code = " "; 
      8'h33: char_code = "h"; 
      8'h43: char_code = "o"; 
      8'h53: char_code = "p"; 
      8'h63: char_code = " "; 
      8'h73: char_code = "r"; 
      8'h83: char_code = "i"; 
      8'h93: char_code = "g"; 
      8'hA3: char_code = "h";
      8'hB3: char_code = "t";
        
      8'h04: char_code = "D"; 
      8'h14: char_code = "o";
      8'h24: char_code = "n"; 
      8'h34: char_code = "'"; 
      8'h44: char_code = "t"; 
      8'h54: char_code = " "; 
      8'h64: char_code = "f"; 
      8'h74: char_code = "a"; 
      8'h84: char_code = "l"; 
      8'h94: char_code = "l"; 
      8'hA4: char_code = "!"; 
        
      8'h05: char_code = "G"; 
      8'h15: char_code = "O";
      8'h25: char_code = "O"; 
      8'h35: char_code = "D"; 
      8'h45: char_code = " "; 
      8'h55: char_code = "L"; 
      8'h65: char_code = "U"; 
      8'h75: char_code = "C"; 
      8'h85: char_code = "K"; 
      8'h95: char_code = " "; 
      8'hA5: char_code = ":"; 
      8'hB5: char_code = ")"; 
         
      default: char_code = 7'h00;
    endcase
  endmodule
