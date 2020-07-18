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

`define S_START         4'b0000
`define S_PREPARE_MAP   4'b0001
`define S_GAME_IDLE     4'b0011
`define S_JUMP_L        4'b0010
`define S_JUMP_R        4'b0110
`define S_CHAR_FLY      4'b0111
`define S_CHAR_FALL     4'b0101
`define S_GAME_END_T    4'b0100
`define S_GAME_END_F    4'b1100
`define S_WIDTH  4

module state_machine (
  input wire clk,
  input wire rst,
  input wire [1:0] key,
  input wire map_ready,
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
  output wire timer_start,
  output wire end_text_select,
  output wire layer_generate
  );
  
  reg [11:0] outputs;
  assign {start_screen_en, blocks_en, time_bar_en, character_en, points_en, end_screen_en, 
                 bg_clor_select, jump_left, jump_right, timer_start, end_text_select, layer_generate} = outputs[11:0];
  
  reg [`S_WIDTH-1:0] state;
  wire [`S_WIDTH-1:0] state_nxt;
  reg [`S_WIDTH-1:0] next_state;
  
  always @* begin
    case (state)
      `S_START:        {outputs, next_state} = {12'b100000000000, (key == `K_SPACEBAR) ? `S_PREPARE_MAP : `S_START};
      `S_PREPARE_MAP:  {outputs, next_state} = {12'b100000000001, map_ready ? `S_GAME_IDLE : `S_PREPARE_MAP};
      `S_GAME_IDLE:    {outputs, next_state} = {12'b011110100000, jump_fail ? `S_CHAR_FALL : time_elapsed ? `S_GAME_END_T : 
                                                                  key == `K_LEFT ? `S_JUMP_L : key == `K_RIGHT ? `S_JUMP_R : `S_GAME_IDLE};
      `S_JUMP_L:       {outputs, next_state} = {12'b011110110101, `S_CHAR_FLY};
      `S_JUMP_R:       {outputs, next_state} = {12'b011110101101, `S_CHAR_FLY};
      `S_CHAR_FLY:     {outputs, next_state} = {12'b011110100100, character_landed ? `S_GAME_IDLE : `S_CHAR_FLY};
      `S_CHAR_FALL:    {outputs, next_state} = {12'b011110100100, character_landed ? `S_GAME_END_F : `S_CHAR_FALL};
      `S_GAME_END_T:   {outputs, next_state} = {12'b000001000000, (key == `K_SPACEBAR) ? `S_PREPARE_MAP : `S_GAME_END_T};
      `S_GAME_END_F:   {outputs, next_state} = {12'b000001000010, (key == `K_SPACEBAR) ? `S_PREPARE_MAP : `S_GAME_END_F};
      default:         {outputs, next_state} = {12'b100000000000, `S_START};
    endcase
  end
  
  assign state_nxt = rst ? `S_START : next_state;

  always @ (posedge clk)
    state <= state_nxt;

endmodule
