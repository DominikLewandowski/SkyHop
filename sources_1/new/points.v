`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2020 14:46:22
// Design Name: 
// Module Name: points
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


module points(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire increase,

  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [11:0] rgb_in,
  output wire [10:0] vcount_out,
  output wire vsync_out,
  output wire vblnk_out,
  output wire [10:0] hcount_out,
  output wire hsync_out,
  output wire hblnk_out,
  output wire [11:0] rgb_out
  );
  
  wire [3:0] char_line;
  wire [7:0] char_xy;
  reg [6:0] char_code;
  wire [7:0] char_line_pixels;
  
  draw_rect_char #(
    .TEXT_COLOUR(12'hFFF),
    .TEXT_POS_X(50),
    .TEXT_POS_Y(50),
    .TEXT_SIZE_X(10),
    .TEXT_SIZE_Y(1)
  ) my_draw_rect_char (
    .text_en(module_en),
    .hcount_in(hcount_in),
    .hsync_in(hsync_in),
    .hblnk_in(hblnk_in),
    .vcount_in(vcount_in),
    .vsync_in(vsync_in),
    .vblnk_in(vblnk_in),
    .rgb_in(rgb_in),
    .char_pixels(char_line_pixels),
    .hcount_out(hcount_out),
    .hsync_out(hsync_out),
    .hblnk_out(hblnk_out),
    .vcount_out(vcount_out),
    .vsync_out(vsync_out),
    .vblnk_out(vblnk_out),
    .rgb_out(rgb_out),
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
  
  reg [3:0] hundred_cnt, hundred_cnt_nxt = 0;
  reg [3:0] ten_cnt, ten_cnt_nxt = 0;
  reg [3:0] one_cnt, one_cnt_nxt = 0;
  
  always@*
  begin
    if( increase == 1 )
      begin
        if( one_cnt < 9 )
          begin
            one_cnt_nxt = one_cnt + 1;
            ten_cnt_nxt = ten_cnt;
            hundred_cnt_nxt = hundred_cnt;        
          end
        else 
          begin 
            one_cnt_nxt = 0;
            if( ten_cnt < 9 )
              begin
                ten_cnt_nxt = ten_cnt + 1;
                hundred_cnt_nxt = hundred_cnt;
              end
            else
              begin
                ten_cnt_nxt = 0;
                if( hundred_cnt < 9 ) hundred_cnt_nxt = hundred_cnt + 1;
                else hundred_cnt_nxt = 0;           
              end
          end
      end
    else 
      if( module_en == 1 )
        begin
          one_cnt_nxt = one_cnt;
          ten_cnt_nxt = ten_cnt;
          hundred_cnt_nxt = hundred_cnt;
        end
      else
        begin
          one_cnt_nxt = 0;
          ten_cnt_nxt = 0;
          hundred_cnt_nxt = 0;
        end
      end
  
  always@*
    casex(char_xy)
      8'h00: char_code = "S"; 
      8'h10: char_code = "c";
      8'h20: char_code = "o"; 
      8'h30: char_code = "r"; 
      8'h40: char_code = "e"; 
      8'h50: char_code = ":"; 
      8'h60: char_code = " "; 
      8'h70: char_code = 7'h30 + {3'b000, hundred_cnt}; 
      8'h80: char_code = 7'h30 + {3'b000, ten_cnt};
      8'h90: char_code = 7'h30 + {3'b000, one_cnt}; 
      default: char_code = 7'h00;
    endcase
    
  always@(posedge clk or posedge rst)
  begin
    if(rst)
      begin
        one_cnt = 0;
        ten_cnt = 0;
        hundred_cnt = 0;
      end
    else
      begin
        one_cnt = one_cnt_nxt;
        ten_cnt = ten_cnt_nxt;
        hundred_cnt = hundred_cnt_nxt;
      end
  end 
endmodule
