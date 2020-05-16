`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2020 00:12:51
// Design Name: 
// Module Name: blocks
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


module blocks(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire one_ms_tick,
  input wire jump_left,
  input wire jump_right,
  input wire layer_select,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus [3:0];
  wire [6:0] layer_map [3:0];
  wire [6:0] block_type [3:0];
  
  wire [6:0] f_layer_map = (layer_select) ? 7'b1010101 : 7'b0101010;
  wire [6:0] f_layer_type = (layer_select) ? 7'b1000101 : 7'b0100010;
  
  shift_layer #(.POS_Y(12'd25)) my_layer_0(
    .clk(clk),
    .rst(rst),
    .one_ms_tick(one_ms_tick),
    .start(jump_left | jump_right),
    .layer_map_in(f_layer_map & {7{module_en}}),
    .block_type_in(f_layer_type),
    .vga_bus_in(vga_bus_in),
    .vga_bus_out(vga_bus[0]),
    .layer_map_out(layer_map[0]),
    .block_type_out(block_type[0])
   );
   
   shift_layer #(.POS_Y(12'd175)) my_layer_1(
     .clk(clk),
     .rst(rst),
     .one_ms_tick(one_ms_tick),
     .start(jump_left | jump_right),
     .layer_map_in(layer_map[0] & {7{module_en}}),
     .block_type_in(block_type[0]),
     .vga_bus_in(vga_bus[0]),
     .vga_bus_out(vga_bus[1]),
     .layer_map_out(layer_map[1]),
     .block_type_out(block_type[1])
    );
       
    shift_layer #(.POS_Y(12'd325)) my_layer_2(
      .clk(clk),
      .rst(rst),
      .one_ms_tick(one_ms_tick),
      .start(jump_left | jump_right),
      .layer_map_in(layer_map[1] & {7{module_en}}),
      .block_type_in(block_type[1]),
      .vga_bus_in(vga_bus[1]),
      .vga_bus_out(vga_bus[2]),
      .layer_map_out(layer_map[2]),
      .block_type_out(block_type[2])
    );
    
     shift_layer #(.POS_Y(12'd475)) my_layer_3(
      .clk(clk),
      .rst(rst),
      .one_ms_tick(one_ms_tick),
      .start(jump_left | jump_right),
      .layer_map_in(layer_map[2] & {7{module_en}}),
      .block_type_in(block_type[2]),
      .vga_bus_in(vga_bus[2]),
      .vga_bus_out(vga_bus[3]),
      .layer_map_out(layer_map[3]),
      .block_type_out(block_type[3])
    );
    
    shift_layer #(.POS_Y(12'd625)) my_layer_4(
     .clk(clk),
     .rst(rst),
     .one_ms_tick(one_ms_tick),
     .start(jump_left | jump_right),
     .layer_map_in(layer_map[3] & {7{module_en}}),
     .block_type_in(block_type[3]),
     .vga_bus_in(vga_bus[3]),
     .vga_bus_out(vga_bus_out),
     .layer_map_out(),
     .block_type_out()
   );
   

endmodule
