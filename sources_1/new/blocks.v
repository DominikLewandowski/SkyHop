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
  input wire layer_select,
  input wire one_ms_tick,
  input wire jump_left,
  input wire jump_right,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out,
  output reg jump_fail
  );
  
  localparam NUM_MODULES = 5;
  wire [`VGA_BUS_SIZE-1:0] vga_bus [NUM_MODULES:0];
  wire [0:6] layer_map [NUM_MODULES:0];
  wire [0:6] block_type [NUM_MODULES:0];
  
  assign vga_bus[0] = vga_bus_in;
  assign vga_bus_out = vga_bus[NUM_MODULES];
  
  block_generator block_gen (
    .layer_select(layer_select),
    .layer_map(layer_map[0]),
    .block_type(block_type[0])
  );
  
  genvar i;
  generate
    for(i = 0; i < NUM_MODULES; i = i + 1) begin
      shift_layer #(.POS_Y(i)) u_layer(
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
  
  reg [3:0] character_pos, character_pos_nxt = 3'b101;
  reg jump_fail_nxt = 0;
  
  always@*
  begin
    jump_fail_nxt = jump_fail;
    character_pos_nxt = character_pos;
    
    if(jump_left) begin
      character_pos_nxt = character_pos - 1;
      if( (layer_map[3][character_pos-3] == 1) && (block_type[3][character_pos-3] == 1) ) jump_fail_nxt = 1;
    end
    else if(jump_right) begin
      character_pos_nxt = character_pos + 1;
      if( (layer_map[3][character_pos-1] == 1) && (block_type[3][character_pos-1] == 1) ) jump_fail_nxt = 1;
    end
  end
  
  always@(posedge clk)
    if(rst) begin
      character_pos <= 3'b101;
      jump_fail <= 0;
    end
    else begin
      character_pos <= character_pos_nxt;
      jump_fail <= jump_fail_nxt;
    end

endmodule
