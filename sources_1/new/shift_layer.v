`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2020 22:11:56
// Design Name: 
// Module Name: shift_layer
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


module shift_layer #(parameter POS_Y = 0)
(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire one_ms_tick,
  input wire start,
  input wire load,
  input wire [0:6] layer_map_in,
  input wire [0:6] block_type_in,
  input wire [0:6] bonus_map_in,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out,
  output reg [0:6] layer_map_out,
  output reg [0:6] block_type_out,
  output reg [0:6] bonus_map_out
 );
   
  wire [11:0] rgb_ground_rom, rgb_cloud_rom;
  wire [13:0] pixel_addres_rom;
  
  reg [7:0] shift_y, shift_y_nxt;
  reg [7:0] one_ms_timer, one_ms_timer_nxt;
  reg [0:6] layer_map_out_nxt;
  reg [0:6] block_type_out_nxt;
  reg [0:6] bonus_map_out_nxt;
  
  wire [11:0] y_offset = (POS_Y==0) ? 12'd0 :
                         (POS_Y==1) ? 12'd150 :
                         (POS_Y==2) ? 12'd300 :
                         (POS_Y==3) ? 12'd450 :
                         (POS_Y==4) ? 12'd600 : 12'd0;
  
  draw_layer my_draw_layer
  (
    .pclk(clk),
    .rst(rst),
    .module_en(module_en),
    .layer_map(layer_map_in),
    .block_type(block_type_in),
    .bonus_map(bonus_map_in),
    .rgb_pixel_ground(rgb_ground_rom),
    .rgb_pixel_cloud(rgb_cloud_rom),
    .ypos((shift_y + y_offset)),
    .vga_bus_in(vga_bus_in),
    .vga_bus_out(vga_bus_out),
    .pixel_addr(pixel_addres_rom)
  );
    
  img_ground_rom my_image_ground (  
    .address(pixel_addres_rom),
    .rgb(rgb_ground_rom),
    .clk(clk)
  );
    
  img_cloud_rom my_image_cloud (  
    .address(pixel_addres_rom),
    .rgb(rgb_cloud_rom),
    .clk(clk)
  );
  
  localparam S_IDLE = 2'b00;
  localparam S_SCROLLING = 2'b01;
  localparam S_END = 2'b10;
  
  reg [1:0] state, state_nxt = S_IDLE;

  always @(*)
  begin
    layer_map_out_nxt = layer_map_out;
    block_type_out_nxt = block_type_out;
    bonus_map_out_nxt = bonus_map_out;
    state_nxt = state;
    one_ms_timer_nxt = one_ms_timer;
    shift_y_nxt = shift_y;
    
    case(state)
  
      S_IDLE:
        if( load == 1 ) begin
          layer_map_out_nxt = layer_map_in;
          block_type_out_nxt = block_type_in;
          bonus_map_out_nxt = bonus_map_in;
        end 
        else if( start == 1 ) 
          begin
            state_nxt = S_SCROLLING;
            one_ms_timer_nxt = 0;
            shift_y_nxt = 0;
          end
      
      S_SCROLLING:
        begin 
          if( one_ms_tick == 1 )
            begin
              shift_y_nxt = shift_y + 1;
              if( one_ms_timer < 149 ) one_ms_timer_nxt = one_ms_timer + 1;
              else state_nxt = S_END;
            end 
        end
        
      S_END:
        begin
          shift_y_nxt = 0;
          layer_map_out_nxt = layer_map_in;
          block_type_out_nxt = block_type_in;
          bonus_map_out_nxt = bonus_map_in;
          state_nxt = S_IDLE;
        end
        
      default: state_nxt = S_IDLE;
    endcase
  end
  
  always @( posedge clk )
    if(rst) begin
      layer_map_out <= 7'b0;
      block_type_out <= 7'b0;
      bonus_map_out <= 7'b0;
      one_ms_timer <= 8'b0;
      shift_y <= 8'b0;
      state <= S_IDLE;
    end
    else begin
      layer_map_out <= layer_map_out_nxt;
      block_type_out <= block_type_out_nxt;
      bonus_map_out <= bonus_map_out_nxt;
      one_ms_timer <= one_ms_timer_nxt;
      shift_y <= shift_y_nxt;
      state <= state_nxt;
    end
endmodule
