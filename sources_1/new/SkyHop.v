`timescale 1ns / 1ps
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
  
  wire [10:0] vcount_bg, hcount_bg;
  wire vblnk_bg, hblnk_bg, vsync_bg, hsync_bg;
  wire [11:0] rgb_bg;
  
  draw_background my_draw_background (
    .color_select(bg_clor_select),
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),
    .vcount_out(vcount_bg),
    .vsync_out(vsync_bg),
    .vblnk_out(vblnk_bg),
    .hcount_out(hcount_bg),
    .hsync_out(hsync_bg),
    .hblnk_out(hblnk_bg),
    .rgb_out(rgb_bg),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  wire [10:0] vcount_ssc, hcount_ssc;
  wire vblnk_ssc, hblnk_ssc, vsync_ssc, hsync_ssc;
  wire [11:0] rgb_ssc;
  
  start_screen my_start_screen (
    .module_en(start_screen_en),
    .vcount_in(vcount_bg),
    .vsync_in(vsync_bg),
    .vblnk_in(vblnk_bg),
    .hcount_in(hcount_bg),
    .hsync_in(hsync_bg),
    .hblnk_in(hblnk_bg),
    .rgb_in(rgb_bg),
    .vcount_out(vcount_ssc),
    .vsync_out(vsync_ssc),
    .vblnk_out(vblnk_ssc),
    .hcount_out(hcount_ssc),
    .hsync_out(hsync_ssc),
    .hblnk_out(hblnk_ssc),
    .rgb_out(rgb_ssc),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  wire [10:0] vcount_tb, hcount_tb;
  wire vblnk_tb, hblnk_tb, vsync_tb, hsync_tb;
  wire [11:0] rgb_tb;
  
  time_bar my_time_bar (
    .module_en(time_bar_en),
    .one_ms_tick(one_ms_tick),
    .start(time_bar_start),
    .vcount_in(vcount_ssc),
    .vsync_in(vsync_ssc),
    .vblnk_in(vblnk_ssc),
    .hcount_in(hcount_ssc),
    .hsync_in(hsync_ssc),
    .hblnk_in(hblnk_ssc),
    .rgb_in(rgb_ssc),
    .vcount_out(vcount_tb),
    .vsync_out(vsync_tb),
    .vblnk_out(vblnk_tb),
    .hcount_out(hcount_tb),
    .hsync_out(hsync_tb),
    .hblnk_out(hblnk_tb),
    .rgb_out(rgb_tb),
    .elapsed(led),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  wire [10:0] vcount_points, hcount_points;
  wire vblnk_points, hblnk_points, vsync_points, hsync_points;
  wire [11:0] rgb_points;
  
  points my_points (
    .module_en(points_en),
    .increase(1'b0),
    .vcount_in(vcount_tb),
    .vsync_in(vsync_tb),
    .vblnk_in(vblnk_tb),
    .hcount_in(hcount_tb),
    .hsync_in(hsync_tb),
    .hblnk_in(hblnk_tb),
    .rgb_in(rgb_tb),
    .vcount_out(vcount_points),
    .vsync_out(vs),
    .vblnk_out(vblnk_points),
    .hcount_out(hcount_points),
    .hsync_out(hs),
    .hblnk_out(hblnk_points),
    .rgb_out({r,g,b}),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
endmodule
