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
  
  localparam CHARACTER_POS_X = (`GAME_WIDTH / 2) - (CHARACTER_WIDTH / 2) - 1;
  localparam CHARACTER_POS_Y = 625 - 100 - CHARACTER_HEIGHT - SPACE_BLOCK_CHAR;
  
  localparam CHAR_LEFT = 2'b00;
  localparam CHAR_RIGHT = 2'b01;
  localparam CHAR_FRONT = 2'b10;
  
  wire [11:0] rgb_char_front, rgb_char_side;
  wire [13:0] pixel_addres_rom;
  reg [1:0] charcter_view, charcter_view_nxt;
  
  wire char_mirror = ( charcter_view == CHAR_RIGHT ) ? 1'b0 : 1'b1;
  wire [11:0] rgb_pixel = (charcter_view == CHAR_FRONT) ? rgb_char_front : rgb_char_side;
  
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
    .rgb(rgb_char_front),
    .clk(clk)
  );
  
  img_char_s_rom my_char_s_rom (  
    .address(pixel_addres_rom),
    .rgb(rgb_char_side),
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
  
  reg [7:0] counter, counter_nxt;
  
  always @(*)
  begin
    state_nxt = state;
    character_y_nxt = character_y;
    character_x_nxt = character_x;
    charcter_view_nxt = charcter_view;
    counter_nxt = counter;
    landed_nxt = 0;
    
    case( state )
    
      S_IDLE:
      begin 
        if( jump_fail ) begin
          state_nxt = S_FALL;
          counter_nxt = 0;
        end  
        else if( jump_left ) begin
          state_nxt = S_JUMP_L;
          charcter_view_nxt = CHAR_LEFT;
          counter_nxt = 0;
        end
        else if( jump_right ) begin
          state_nxt = S_JUMP_R;
          charcter_view_nxt = CHAR_RIGHT;
          counter_nxt = 0;
        end
        else charcter_view_nxt = CHAR_FRONT; 
      end
        
      S_JUMP_R:
        if( movement_tick == 1 )
          begin
            charcter_view_nxt = CHAR_RIGHT;
            character_x_nxt = character_x + 1;
            character_y_nxt = (counter < 40) ? character_y - 2 : character_y + 2;
            if( counter < 79 ) counter_nxt = counter + 1;
            else 
              begin
                landed_nxt = 1;
                state_nxt = S_IDLE;
              end
          end  
  
      S_JUMP_L:
        if( movement_tick == 1 )
          begin
            charcter_view_nxt = CHAR_LEFT;
            character_x_nxt = character_x - 1;
            character_y_nxt = (counter < 40) ? character_y - 2 : character_y + 2;
            if( counter < 79 ) counter_nxt = counter + 1;
            else 
              begin
                landed_nxt = 1;
                state_nxt = S_IDLE;
              end
          end  
     
       S_FALL: begin
         if( movement_tick == 1 )
           begin
             if( character_y < (`GAME_HEIGHT + 350) ) begin
               counter_nxt = counter + 1;
               character_x_nxt = ( charcter_view == CHAR_LEFT ) ? (character_x - 1) : (character_x + 1);
               character_y_nxt = character_y + 2**counter[7:2];    
             end
             else begin
               landed_nxt = 1;
               state_nxt = S_IDLE;
             end
           end  
         end

      default: state_nxt = S_IDLE;
    endcase
  end    

  always @( posedge clk )
    if (rst || (module_en == 0)) begin
      character_x <= CHARACTER_POS_X;
      character_y <= CHARACTER_POS_Y;
      state <= S_IDLE;
      landed <= 0;
      counter <= 0;
      charcter_view <= CHAR_FRONT;
    end
    else begin
      character_x <= character_x_nxt;
      character_y <= character_y_nxt;
      state <= state_nxt;
      landed <= landed_nxt;
      counter <= counter_nxt;
      charcter_view <= charcter_view_nxt;
    end    
endmodule
