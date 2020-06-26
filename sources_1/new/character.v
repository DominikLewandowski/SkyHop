`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2020 00:10:03
// Design Name: 
// Module Name: character
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


module character(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire jump_left,
  input wire jump_right,
  input wire jump_fail,
  input wire one_ms_tick,
  output reg landed,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  reg [9:0] character_x, character_x_nxt;       // <0:799>
  reg [9:0] character_y, character_y_nxt;       // <0:599>
  
  reg landed_nxt;
  
  localparam CHARACTER_COLOR = 12'hFF0;
  localparam CHARACTER_HEIGHT = 60;
  localparam CHARACTER_WIDTH = 40;
  
  draw_rect #(
    .RECT_COLOUR(CHARACTER_COLOR),
    .RECT_WIDTH(CHARACTER_WIDTH),
    .RECT_HEIGHT(CHARACTER_HEIGHT)
  ) my_draw_rect (
    .module_en(module_en),
    .xpos(character_x),
    .ypos(character_y),
    .vga_bus_in(vga_bus_in),
    .vga_bus_out(vga_bus_out),   
    .pclk(clk),
    .rst(rst)
  );
  
  reg [1:0] state, state_nxt;
  localparam S_IDLE   = 2'b00;
  localparam S_JUMP_R = 2'b01;
  localparam S_JUMP_L = 2'b10;
  localparam S_FALL   = 2'b11;
  
  reg [6:0] one_ms_timer, one_ms_timer_nxt;
  
  always @*
  begin
    state_nxt = state;
    character_y_nxt = 450;
    character_x_nxt = character_x;
    one_ms_timer_nxt = one_ms_timer;
    landed_nxt = 0;
    
    case(state)
    
      S_IDLE:
      begin 
        if( module_en == 0 ) character_x_nxt = (`GAME_WIDTH / 2)-(CHARACTER_WIDTH / 2) - 1;
        state_nxt = jump_fail ? S_FALL : jump_left ? S_JUMP_L : jump_right ? S_JUMP_R : state;
        one_ms_timer_nxt = 0;
      end
        
      S_JUMP_R:
        begin 
          if( one_ms_tick == 1 )
            begin
              character_x_nxt = character_x + 1;
              if( one_ms_timer < 79 ) one_ms_timer_nxt = one_ms_timer + 1;
              else 
                begin
                  landed_nxt = 1;
                  state_nxt = S_IDLE;
                end
            end  
        end
        
      S_JUMP_L:
        begin 
          if( one_ms_tick == 1 )
            begin
              character_x_nxt = character_x - 1;
              if( one_ms_timer < 79 ) one_ms_timer_nxt = one_ms_timer + 1;
              else 
                begin
                  landed_nxt = 1;
                  state_nxt = S_IDLE;
                end
            end  
        end
        
       S_FALL:
         state_nxt = S_IDLE;
        
      default: state_nxt = S_IDLE;
    endcase
  end    

  always@(posedge clk)
    if (rst) begin
      character_x <= (`GAME_WIDTH/2)-(CHARACTER_WIDTH/2)-1;
      character_y <= 0;
      state <= S_IDLE;
      landed <= 0;
      one_ms_timer <= 0;
    end
    else begin
      character_x <= character_x_nxt;
      character_y <= character_y_nxt;
      state <= state_nxt;
      landed <= landed_nxt;
      one_ms_timer <= one_ms_timer_nxt;
    end    
endmodule
