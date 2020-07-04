`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2020 08:38:43
// Design Name: 
// Module Name: draw_rect_img
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


module draw_rect_img   
  #( parameter
    RECT_WIDTH = 48,
    RECT_HEIGHT = 64
  )(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire mirror,
  input wire [11:0] rgb_pixel,
  input wire [9:0] xpos,
  input wire [9:0] ypos,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out,
  output reg [13:0] pixel_addr
);

  `VGA_BUS_SPLIT( vga_bus_in )
  `VGA_DEFINE_OUT_REG
  `VGA_BUS_MERGE( vga_bus_out )

  reg rect_disp_flag;
  wire rect_disp_flag_delayed;
  wire [11:0] rgb_in_delayed;
  
  wire [10:0] vcount_out_nxt, hcount_out_nxt;
  wire hsync_out_nxt, vsync_out_nxt;
  wire [11:0] rgb_out_nxt;
  
  reg [6:0] relative_x, relative_y; 
  wire [13:0] pixel_addr_nxt = {relative_y, relative_x};

  assign rgb_out_nxt = (rect_disp_flag_delayed & module_en) ? ((rgb_pixel == 12'hFFF) ? rgb_in_delayed : rgb_pixel) : rgb_in_delayed;

  delay #(
    .WIDTH (`VGA_BUS_SIZE + 1),
    .CLK_DEL(2)
  ) u_delay (
    .clk (clk),
    .rst (rst),
    .din ( {rect_disp_flag, vcount_in, vsync_in, hcount_in, hsync_in, rgb_in}),
    .dout ({rect_disp_flag_delayed, vcount_out_nxt, vsync_out_nxt, hcount_out_nxt, hsync_out_nxt, rgb_in_delayed})
  );

  always @(*)
    begin
      if (((hcount_in >=  xpos) && (hcount_in < (xpos + RECT_WIDTH))) && ((vcount_in >=  ypos) && (vcount_in < (ypos + RECT_HEIGHT))) ) begin 
        relative_x = (mirror == 1) ? (RECT_WIDTH - (hcount_in - xpos) - 1) : (hcount_in - xpos);      
        relative_y = vcount_in - ypos;
        rect_disp_flag = 1; 
      end
      else begin
        relative_x = 0;
        relative_y = 0;
        rect_disp_flag = 0; 
      end
    end
  
  always @( posedge clk )
    if (rst) begin
      hcount_out <= 0;
      vcount_out <= 0; 
      hsync_out <= 0;
      vsync_out <= 0;
      pixel_addr <= 0;
      rgb_out <= 0; 
    end
    else begin
      hcount_out <= hcount_out_nxt;
      vcount_out <= vcount_out_nxt; 
      hsync_out <= hsync_out_nxt;
      vsync_out <= vsync_out_nxt;
      pixel_addr <= pixel_addr_nxt;
      rgb_out <= rgb_out_nxt;
    end
  endmodule
