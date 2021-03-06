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
  input wire PS2Data,
  input wire PS2Clk,
  output wire vs,
  output wire hs,
  output wire [3:0] r, g, b
  );
  
  wire clk_40MHz;
  wire clk_50MHz;
  
  clk_wiz_0 clk_config (
    .clk40MHz(clk_40MHz),  // Clock out ports
    .clk50MHz(clk_50MHz),
    .reset(1'b0),            // Status and control signals
    .clk(clk)                // Clock in ports
  );
  
  wire start_screen_en, blocks_en, time_bar_en, character_en, points_en, end_screen_en;
  wire bg_clor_select, jump_left, jump_right, jump_fail, timer_start, time_elapsed, character_landed, end_text_select, map_ready;
  wire layer_generate;
  
  wire one_ms_tick;
  millisecond_timer ms_timer (
    .clk_40MHz(clk_40MHz),
    .rst(rst),
    .one_milli_tick(one_ms_tick)
  );

  wire one_sec_tick;
  one_second_timer sec_timer (
    .clk(clk_40MHz),
    .rst(rst),
    .one_milli_tick(one_ms_tick),
    .one_sec_tick(one_sec_tick)
  );

  wire [1:0] key_code;
  keyboard my_keyboard(
    .clk_50MHz(clk_50MHz),
    .rst(rst),
    .PS2Data(PS2Data),
    .PS2Clk(PS2Clk),
    .key(key_code)
   );

  state_machine FSM (
    .clk(clk_40MHz),
    .rst(rst),
    .key(key_code),
    .map_ready(map_ready),
    .jump_fail(jump_fail),
    .time_elapsed(time_elapsed),
    .character_landed(character_landed),
    .start_screen_en(start_screen_en),
    .blocks_en(blocks_en),
    .time_bar_en(time_bar_en),
    .character_en(character_en),
    .points_en(points_en),
    .end_screen_en(end_screen_en),
    .bg_clor_select(bg_clor_select),
    .jump_left(jump_left),
    .jump_right(jump_right),
    .timer_start(timer_start),
    .end_text_select(end_text_select),
    .layer_generate(layer_generate)
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
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus [6:0];
  
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
    .one_sec_tick(one_sec_tick),
    .vga_bus_in(vga_bus[0]),
    .vga_bus_out(vga_bus[1]),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  wire [0:6] layer_map, block_type, bonus_map;
  wire load_layer;
  block_generator block_gen (
    .generate_map(layer_generate),
    .layer_map(layer_map),
    .block_type(block_type),
    .bonus_map(bonus_map),
    .load_layer(load_layer),
    .map_ready(map_ready),
    .rst(rst | end_screen_en),
    .clk(clk_40MHz)
  );
  
  wire bonus;
  blocks my_blocks (
    .one_ms_tick(one_ms_tick),
    .module_en(blocks_en),
    .jump_left(jump_left),
    .jump_right(jump_right),
    .load_layer(load_layer),
    .layer_map_in(layer_map),
    .block_type_in(block_type),
    .bonus_map_in(bonus_map),
    .vga_bus_in(vga_bus[1]),
    .vga_bus_out(vga_bus[2]),
    .jump_fail(jump_fail),
    .bonus(bonus),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  character my_character (
    .module_en(character_en),
    .jump_left(jump_left),
    .jump_right(jump_right),
    .jump_fail(jump_fail),
    .landed(character_landed),
    .vga_bus_in(vga_bus[2]),
    .vga_bus_out(vga_bus[3]),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  time_bar my_time_bar (
    .module_en(time_bar_en),
    .one_ms_tick(one_ms_tick),
    .start(timer_start),
    .bonus(bonus & character_landed),
    .vga_bus_in(vga_bus[3]),
    .vga_bus_out(vga_bus[4]),
    .elapsed(time_elapsed),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  wire [11:0] score;
  
  points my_points (
    .module_en(points_en),
    .increase((character_landed & ~jump_fail)),
    .vga_bus_in(vga_bus[4]),
    .vga_bus_out(vga_bus[5]),
    .score(score),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  end_screen my_end_screen (
    .module_en(end_screen_en),
    .jump_fail(end_text_select),
    .score_in(score),
    .vga_bus_in(vga_bus[5]),
    .vga_bus_out(vga_bus[6]),
    .one_sec_tick(one_sec_tick),
    .rst(rst),
    .clk(clk_40MHz)
  );
  
  assign hs = vga_bus[6][`VGA_HSYNC_BIT];
  assign vs = vga_bus[6][`VGA_VSYNC_BIT];
  assign {r,g,b} = vga_bus[6][`VGA_RGB_BIT];
  
endmodule
