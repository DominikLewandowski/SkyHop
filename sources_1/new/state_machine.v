`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2020 13:16:55
// Design Name: 
// Module Name: state_machine
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

`define S_START         3'b000
`define S_PREPARE_MAP   3'b001
`define S_GAME_IDLE     3'b011
`define S_JUMP_L        3'b010
`define S_JUMP_R        3'b110
`define S_CHAR_FLY      3'b111
`define S_CHAR_FALL     3'b101
`define S_GAME_END      3'b100
`define S_WIDTH  3

module state_machine (
  input wire clk,
  input wire rst,
  input wire [1:0] key,
  input wire jump_fail,
  input wire time_elapsed,
  input wire character_landed,
  
  output wire start_screen_en,
  output wire blocks_en,
  output wire time_bar_en,
  output wire character_en,
  output wire points_en,
  output wire end_screen_en,
  output wire bg_clor_select,
  output wire jump_left,
  output wire jump_right,
  output wire timer_start
  );
  
  localparam K_LEFT     = 2'b01;  // Left arrow
  localparam K_RIGHT    = 2'b10;  // Right arrow
  localparam K_SPACEBAR = 2'b11;  // Spacebar
  
  reg [9:0] outputs;
  assign {start_screen_en, blocks_en, time_bar_en, character_en, points_en, end_screen_en, bg_clor_select, jump_left, jump_right, timer_start} = outputs[9:0];
  
  reg [`S_WIDTH-1:0] state;
  wire [`S_WIDTH-1:0] state_nxt;
  reg [`S_WIDTH-1:0] next_state;
  
  always @* begin
    case (state)
      `S_START:          {outputs, next_state} = {10'b1000000000, (key == K_SPACEBAR) ? `S_PREPARE_MAP : `S_START};
      `S_PREPARE_MAP:    {outputs, next_state} = {10'b1000000000, `S_GAME_IDLE};
      `S_GAME_IDLE:      {outputs, next_state} = {10'b0111101000, jump_fail ? `S_CHAR_FALL : (time_elapsed ? `S_GAME_END : ((key == K_LEFT) ? `S_JUMP_L : ((key == K_RIGHT) ? `S_JUMP_R : `S_GAME_IDLE)))};
      `S_JUMP_L:         {outputs, next_state} = {10'b0111101101, `S_CHAR_FLY};
      `S_JUMP_R:         {outputs, next_state} = {10'b0111101011, `S_CHAR_FLY};
      `S_CHAR_FLY:       {outputs, next_state} = {10'b0111101001, character_landed ? `S_GAME_IDLE : `S_CHAR_FLY};
      `S_CHAR_FALL:      {outputs, next_state} = {10'b0111101001, character_landed ? `S_GAME_END : `S_CHAR_FALL};
      `S_GAME_END:       {outputs, next_state} = {10'b0000010000, (key == K_SPACEBAR) ? `S_START : `S_GAME_END};
      default:           {outputs, next_state} = {10'b1000000000, (key == K_SPACEBAR) ? `S_PREPARE_MAP : `S_START};
    endcase
  end
  
  assign state_nxt = rst ? `S_START : next_state;

  always @ (posedge clk)
    state <= state_nxt;

endmodule
