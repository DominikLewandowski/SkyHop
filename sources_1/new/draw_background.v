`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 15:02:13
// Design Name: 
// Module Name: draw_background
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



module draw_background(
  input wire pclk,
  input wire rst,

  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,

  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,

  output reg [11:0] rgb_out
  );
  
  wire [10:0] vcount_out_nxt = vcount_in;
  wire vsync_out_nxt = vsync_in;
  wire vblnk_out_nxt = vblnk_in;
  wire [10:0] hcount_out_nxt = hcount_in;
  wire hsync_out_nxt = hsync_in;
  wire hblnk_out_nxt = hblnk_in;
    
  reg [11:0] rgb_nxt;

  always @*
    begin
      // During blanking, make it it black.
      if (vblnk_in || hblnk_in) rgb_nxt = 12'h0_0_0; 
      else
        begin
          // Active display, top edge, make a yellow line.
          if (vcount_in == 0) rgb_nxt = 12'hf_f_0;
          // Active display, bottom edge, make a red line.
          else if (vcount_in == 599) rgb_nxt = 12'hf_0_0;
          // Active display, left edge, make a green line.
          else if (hcount_in == 0) rgb_nxt = 12'h0_f_0;
          // Active display, right edge, make a blue line.
          else if (hcount_in == 799) rgb_nxt = 12'h0_0_f;
          // Active display, interior, fill with gray.
          // You will replace this with your own test.
          else rgb_nxt = 12'h8_8_8;      
        end
      end
    
  always@(posedge pclk)
    if (rst) begin
      rgb_out <=  0; 
      vcount_out <=  0; 
      vsync_out <=  0;
      vblnk_out <=  0;
      hcount_out <= 0;
      hsync_out <=  0;
      hblnk_out <=  0;
    end
    else begin
      rgb_out <= rgb_nxt;
      vcount_out <= vcount_out_nxt; 
      vsync_out <= vsync_out_nxt;
      vblnk_out <= vblnk_out_nxt;
      hcount_out <= hcount_out_nxt;
      hsync_out <= hsync_out_nxt;
      hblnk_out <= hblnk_out_nxt;
    end
endmodule