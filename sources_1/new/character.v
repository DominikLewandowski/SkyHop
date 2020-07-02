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
  output reg landed,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus;
  
  reg [9:0] character_x, character_x_nxt;       // <0:799>
  reg [9:0] character_y, character_y_nxt;       // <0:599>
  
  reg landed_nxt;
  
  localparam CHARACTER_COLOR = 12'hFF0;
  localparam CHARACTER_HEIGHT = 70;
  localparam CHARACTER_WIDTH = 88;
  localparam SPACE_BLOCK_CHAR = 1;
  
  localparam CHARACTER_POS_Y = 625 - 100 - CHARACTER_HEIGHT - SPACE_BLOCK_CHAR;
  
  wire [11:0] rgb_char_f_rom, rgb_char_s_rom;
  wire [13:0] pixel_addres_rom;

  reg fly_flag, fly_flag_nxt;
  wire [11:0] rgb_pixel = (fly_flag == 1) ? rgb_char_s_rom : rgb_char_f_rom;
  reg char_mirror, char_mirror_nxt;
  
  draw_rect_img #(
    .RECT_WIDTH(CHARACTER_WIDTH),
    .RECT_HEIGHT(CHARACTER_HEIGHT)
  ) draw_character (
    .clk(clk),
    .rst(rst),
    .mirror(char_mirror),
    .module_en(module_en),
    .rgb_pixel(rgb_pixel),
    .xpos(character_x),
    .ypos(character_y),
    .vga_bus_in(vga_bus_in),
    .vga_bus_out(vga_bus_out),
    .pixel_addr(pixel_addres_rom)
  );
  
  img_char_f_rom my_char_f_rom (  
    .address(pixel_addres_rom),
    .rgb(rgb_char_f_rom),
    .clk(clk)
  );
  
  img_char_s_rom my_char_s_rom (  
    .address(pixel_addres_rom),
    .rgb(rgb_char_s_rom),
    .clk(clk)
  );
  
  wire movement_tick;
  char_movement_timer #(
    .TIMER_CONST(17'd78_000)
  ) movement_timer (
    .clk_40MHz(clk), 
    .rst(rst),
    .movement_tick(movement_tick)
  );
  
  reg [1:0] state, state_nxt;
  localparam S_IDLE   = 2'b00;
  localparam S_JUMP_R = 2'b01;
  localparam S_JUMP_L = 2'b10;
  localparam S_FALL   = 2'b11;
  
  reg [7:0] timer, timer_nxt;
  
  always @*
  begin
    state_nxt = state;
    character_y_nxt = character_y;
    character_x_nxt = character_x;
    timer_nxt = timer;
    fly_flag_nxt = fly_flag;
    char_mirror_nxt = char_mirror;
    landed_nxt = 0;
    
    case(state)
    
      S_IDLE:
      begin 
        state_nxt = jump_fail ? S_FALL : (jump_left ? S_JUMP_L : (jump_right ? S_JUMP_R : state));
        timer_nxt = 0;
        fly_flag_nxt = 0;
      end
        
      S_JUMP_R:
        if( movement_tick == 1 )
          begin
            char_mirror_nxt = 0;
            fly_flag_nxt = 1;
            character_x_nxt = character_x + 1;
            character_y_nxt = (timer < 40) ? character_y - 2 : character_y + 2;
            if( timer < 79 ) timer_nxt = timer + 1;
            else 
              begin
                landed_nxt = 1;
                state_nxt = S_IDLE;
              end
          end  
  
      S_JUMP_L:
        if( movement_tick == 1 )
          begin
            char_mirror_nxt = 1;
            fly_flag_nxt = 1;
            character_x_nxt = character_x - 1;
            character_y_nxt = (timer < 40) ? character_y - 2 : character_y + 2;
            if( timer < 79 ) timer_nxt = timer + 1;
            else 
              begin
                landed_nxt = 1;
                state_nxt = S_IDLE;
              end
          end  
     
       S_FALL:
         if( movement_tick == 1 )
           begin
             fly_flag_nxt = 1;
             character_y_nxt = character_y + 1;
             if( timer < 200 ) timer_nxt = timer + 1;
             else 
               begin
                 landed_nxt = 1;
                 state_nxt = S_IDLE;
               end
            end  

        
      default: state_nxt = S_IDLE;
    endcase
  end    

  always@(posedge clk)
    if (rst || (module_en == 0)) begin
      character_x <= (`GAME_WIDTH/2)-(CHARACTER_WIDTH/2)-1;
      character_y <= CHARACTER_POS_Y;
      state <= S_IDLE;
      landed <= 0;
      timer <= 0;
      fly_flag <= 0;
      char_mirror <= 0;
    end
    else begin
      character_x <= character_x_nxt;
      character_y <= character_y_nxt;
      state <= state_nxt;
      landed <= landed_nxt;
      timer <= timer_nxt;
      fly_flag <= fly_flag_nxt;
      char_mirror <= char_mirror_nxt;
    end    
endmodule
