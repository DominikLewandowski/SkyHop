`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2020 12:33:23
// Design Name: 
// Module Name: draw_image_rom
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


module draw_image_rom(
  input wire pclk,
  input wire rst,

  input wire [11:0] rgb_pixel,
  input wire [11:0] xpos,
  input wire [11:0] ypos,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out,
  output reg [11:0] pixel_addr
  );

  localparam RECT_WIDTH = 48;
  localparam RECT_HEIGHT = 64;
  
  `VGA_BUS_SPLIT( vga_bus_in )
  `VGA_DEFINE_OUT_REG
  `VGA_BUS_MERGE( vga_bus_out )

  reg [11:0] pixel_addr_nxt;
  reg [5:0] relative_x, relative_y; 
  reg rect_display_flag;

  wire [10:0] vcount_out_nxt, hcount_out_nxt;
  wire vsync_out_nxt, vblnk_out_nxt, hsync_out_nxt, hblnk_out_nxt;
  wire [11:0] rgb_out_nxt, rgb_delayed;
  wire rect_display_flag_d;

  assign rgb_out_nxt = rect_display_flag_d ? rgb_pixel : rgb_delayed;

  delay #(
    .WIDTH (37),
    .CLK_DEL(2)
  ) u_delay (
    .clk (pclk),
    .rst (rst),
    .din ( {rect_display_flag, vcount_in, vsync_in, hcount_in, hsync_in, rgb_in}),
    .dout ({rect_display_flag_d, vcount_out_nxt, vsync_out_nxt, hcount_out_nxt, hsync_out_nxt, rgb_delayed})
  );

  always @*
  begin
    if (((hcount_in >=  xpos) && (hcount_in < (xpos + RECT_WIDTH))) && ((vcount_in >=  ypos) && (vcount_in < (ypos + RECT_HEIGHT))) ) begin 
      relative_x = hcount_in - xpos;      
      relative_y = vcount_in - ypos;
      rect_display_flag = 1; 
    end
    else begin
      relative_x = 0;
      relative_y = 0;
      rect_display_flag = 0; 
    end
    pixel_addr_nxt = {relative_y,relative_x};
  end
  
  always@(posedge pclk)
  if (rst) begin
    pixel_addr <= 0;
    rgb_out <= 0; 
    vcount_out <= 0; 
    vsync_out <= 0;
    hcount_out <= 0;
    hsync_out <= 0;
  end
  else begin
    pixel_addr <= pixel_addr_nxt;
    rgb_out <= rgb_out_nxt;  
    vcount_out <= vcount_out_nxt; 
    vsync_out <= vsync_out_nxt;
    hcount_out <= hcount_out_nxt;
    hsync_out <= hsync_out_nxt;
  end
endmodule
