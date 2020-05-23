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


module state_machine(
  // --- for test only --- //
  input wire [6:0] sw,
  input wire btnU, btnL, btnR,
  output wire led,
  // --------------------- //
  input wire clk,
  input wire rst,
  
  //input wire keyboard_flag,
  //input wire keyboard_data,
  
  input wire jump_fail,
  input wire time_elapsed,
  input wire character_landed,
  
  output reg start_screen_en,
  output reg blocks_en,
  output reg time_bar_en,
  output reg character_en,
  output reg points_en,
  output reg end_screen_en,
  
  output reg bg_clor_select,
  output reg jump_left,
  output reg jump_right,
  output reg timer_start
  );
  
  // -------------  For test only  ------------------------------------------------------- //
  assign led = time_elapsed;
  wire btnU_tick, btnL_tick, btnR_tick;
  btn_debounce my_db_1( .clk(clk), .reset(rst), .sw(btnU), .db_level(), .db_tick(btnU_tick));
  btn_debounce my_db_2( .clk(clk), .reset(rst), .sw(btnL), .db_level(), .db_tick(btnL_tick));
  btn_debounce my_db_3( .clk(clk), .reset(rst), .sw(btnR), .db_level(), .db_tick(btnR_tick));
  
  wire timer_start_nxt = btnU_tick;
  wire jump_left_nxt = btnL_tick;
  wire jump_right_nxt = btnR_tick;
  
  wire bg_clor_select_nxt = sw[0];
  wire start_screen_en_nxt = sw[1];
  wire blocks_en_nxt = sw[2];
  wire time_bar_en_nxt = sw[3];
  wire character_en_nxt = sw[4];
  wire points_en_nxt = sw[5];
  wire end_screen_en_nxt = sw[6];
  // ------------------------------------------------------------------------------------ //
  
  always@(posedge clk)
    if(rst) 
      begin
        bg_clor_select <= 0;
        start_screen_en <= 0;
        blocks_en <= 0;
        time_bar_en <= 0;
        character_en <= 0;
        points_en <= 0;
        end_screen_en <= 0;
        timer_start <= 0;
        jump_left <= 0;
        jump_right <= 0;
      end 
    else 
      begin
        bg_clor_select <= bg_clor_select_nxt;
        start_screen_en <= start_screen_en_nxt;
        blocks_en <= blocks_en_nxt;
        time_bar_en <= time_bar_en_nxt;
        character_en <= character_en_nxt;
        points_en <= points_en_nxt;
        end_screen_en <= end_screen_en_nxt;
        timer_start <= timer_start_nxt;
        jump_left <= jump_left_nxt;
        jump_right <= jump_right_nxt;
      end
  
endmodule
