`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 14:03:55
// Design Name: 
// Module Name: SkyHop
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


module SkyHop(
  input wire rst,
  input wire clk,
  input wire [4:0] sw,
  output wire led,
  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b
  );
  
  wire locked;
  wire clk_100MHz;
  wire clk_40MHz;
  
  clk_wiz_0 clk_config (
    .clk100MHz(clk_100MHz),  // Clock out ports
    .clk40MHz(clk_40MHz),
    .reset(1'b0),            // Status and control signals
    .locked(locked),
    .clk(clk)                // Clock in ports
  );
  
  wire bg_clor_select = sw[0];
  wire start_screen_en = sw[1];
  wire time_bar_en = sw[2];
  wire time_bar_start = sw[3];
  wire points_en = sw[4];
  
  wire one_ms_tick;
  millisecond_timer my_millisecond_timer (
    .clk_40MHz(clk_40MHz), 
    .rst(rst),
    .one_milli_tick(one_ms_tick)
  );
  
  wire [10:0] vcount, hcount;
  wire vblnk, hblnk, vsync, hsync;
  
  vga_timing my_timing (
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),
    .pclk(clk_40MHz),
    .rst(rst)
  );
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus [3:0];
  
  draw_background my_draw_background (
    .color_select(bg_clor_select),
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),
    .vga_bus_out(vga_bus[0]),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  start_screen my_start_screen (
    .module_en(start_screen_en),
    .vga_bus_in(vga_bus[0]),
    .vga_bus_out(vga_bus[1]),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  time_bar my_time_bar (
    .module_en(time_bar_en),
    .one_ms_tick(one_ms_tick),
    .start(time_bar_start),
    .vga_bus_in(vga_bus[1]),
    .vga_bus_out(vga_bus[2]),
    .elapsed(led),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  points my_points (
    .module_en(points_en),
    .increase(1'b0),
    .vga_bus_in(vga_bus[2]),
    .vga_bus_out(vga_bus[3]),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  assign hs = vga_bus[3][`VGA_HSYNC_BIT];
  assign vs = vga_bus[3][`VGA_VSYNC_BIT];
  assign {r,g,b} = vga_bus[3][`VGA_RGB_BIT];
  
endmodule

