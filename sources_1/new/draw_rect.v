`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2020 22:23:08
// Design Name: 
// Module Name: draw_rect
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



module draw_rect
  #( parameter
    RECT_COLOUR = 12'h0F0,
    RECT_WIDTH = 80,
    RECT_HEIGHT = 80
  )
  (
  input wire pclk,
  input wire rst,
  input wire module_en,

  input wire [8:0] xpos,
  input wire [8:0] ypos,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  `VGA_BUS_SPLIT( vga_bus_in )
  `VGA_DEFINE_OUT_REG
  `VGA_BUS_MERGE( vga_bus_out )

  wire [10:0] hcount_out_nxt = hcount_in;
  wire [10:0] vcount_out_nxt = vcount_in;
  wire hsync_out_nxt = hsync_in;
  wire vsync_out_nxt = vsync_in;
  //wire hblnk_out_nxt = hblnk_in;
  //wire vblnk_out_nxt = vblnk_in;
  
  reg [11:0] rgb_out_nxt;
  

  always @*
    begin
      if ((module_en == 1) && ((hcount_in >=  xpos) && (hcount_in < (xpos + RECT_WIDTH))) && ((vcount_in >=  ypos) && (vcount_in < (ypos + RECT_HEIGHT))) ) 
      begin 
        rgb_out_nxt = RECT_COLOUR;
      end 
      else rgb_out_nxt = rgb_in;
    end
    
  always@(posedge pclk)
    if (rst) begin
      hcount_out <= 0;
      vcount_out <= 0; 
      hsync_out <= 0;
      vsync_out <= 0;
      //hblnk_out <= 0;
      //vblnk_out <= 0;
      rgb_out <= 0;
    end
    else begin
      hcount_out <= hcount_out_nxt;
      vcount_out <= vcount_out_nxt; 
      hsync_out <= hsync_out_nxt;
      vsync_out <= vsync_out_nxt;
      //hblnk_out <= hblnk_out_nxt;
      //vblnk_out <= vblnk_out_nxt;
      rgb_out <= rgb_out_nxt;  
    end
endmodule
