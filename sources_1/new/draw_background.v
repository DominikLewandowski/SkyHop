`timescale 1ns / 1ps
`include "macros.vh"
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
  input wire clk,
  input wire rst,
  input wire color_select,

  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  `VGA_DEFINE_OUT_REG
  `VGA_BUS_MERGE( vga_bus_out )
  
  wire [10:0] hcount_out_nxt = hcount_in;
  wire [10:0] vcount_out_nxt = vcount_in;
  wire hsync_out_nxt = hsync_in;
  wire vsync_out_nxt = vsync_in;
  
  reg [11:0] rgb_out_nxt;

  always @*
    begin
      if (vblnk_in || hblnk_in) rgb_out_nxt = 12'h000; 
      else if( color_select == 0 ) rgb_out_nxt = `BG_COLOR_L;
      else rgb_out_nxt = `BG_COLOR_D;
    end
  
  always@(posedge clk)
    if (rst) begin
      hcount_out <= 0;
      vcount_out <= 0;
      hsync_out <= 0;
      vsync_out <= 0;
      rgb_out <= 0;
    end
    else begin
      hcount_out <= hcount_out_nxt;
      vcount_out <= vcount_out_nxt;
      hsync_out <= hsync_out_nxt;
      vsync_out <= vsync_out_nxt;
      rgb_out <= rgb_out_nxt;
    end
    
endmodule
