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
  
  localparam NUM_MODULES = 5;
  localparam LAYER_SPACE = 150;
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus [NUM_MODULES:0];
  wire [6:0] layer_map [NUM_MODULES:0];
  wire [6:0] block_type [NUM_MODULES:0];
  
  assign vga_bus[0] = vga_bus_in;
  assign vga_bus_out = vga_bus[NUM_MODULES];
  
  // ----------  For test only  ----------------- //
  assign layer_map[0] = (layer_select) ? 7'b1010101 : 7'b0101010;
  assign block_type[0] = (layer_select) ? 7'b1000101 : 7'b0100010;
  // -------------------------------------------- //
  
  genvar i;
  generate
  for(i = 0; i < NUM_MODULES; i = i + 1) begin
  
    shift_layer #(.POS_Y(12'd25 + (LAYER_SPACE*i))) u_layer(
      .clk(clk),
      .rst(rst),
      .one_ms_tick(one_ms_tick),
      .start(jump_left | jump_right),
      .layer_map_in(layer_map[i] & {7{module_en}}),
      .block_type_in(block_type[i]),
      .vga_bus_in(vga_bus[i]),
      .vga_bus_out(vga_bus[i+1]),
      .layer_map_out(layer_map[i+1]),
      .block_type_out(block_type[i+1])
     );
  end
  endgenerate
  
endmodule
