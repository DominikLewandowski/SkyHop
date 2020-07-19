`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2020 20:43:43
// Design Name: 
// Module Name: draw_layer
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

module draw_layer
(
  input wire pclk,
  input wire rst,
  input wire module_en,
  input wire [0:6] layer_map,
  input wire [0:6] block_type,
  input wire [0:6] bonus_map,
  input wire [11:0] rgb_pixel_ground,
  input wire [11:0] rgb_pixel_cloud,
  input wire [11:0] ypos,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out,
  output reg [13:0] pixel_addr
);
  localparam SCREEN_WIDTH = 800;
  localparam BLOCK_WIDTH = 80;
  localparam BLOCK_HEIGHT = 50;
  
  localparam BLOCKS_N = 7;
  localparam OFFSET_Y = 100;
  localparam START_X = ((SCREEN_WIDTH-(BLOCKS_N*BLOCK_WIDTH))/2) - 1;
  
  `VGA_BUS_SPLIT( vga_bus_in )
  `VGA_DEFINE_OUT_REG
  `VGA_BUS_MERGE( vga_bus_out )
  
  reg [1:0] rect_type;
  wire [1:0] rect_type_delayed;
  wire [11:0] rgb_in_delayed;

  wire [10:0] vcount_out_nxt, hcount_out_nxt;
  wire hsync_out_nxt, vsync_out_nxt;
  reg [11:0] rgb_out_nxt;
  
  reg [6:0] relative_x, relative_y; 
  wire [13:0] pixel_addr_nxt = {relative_y,relative_x};
  
  delay #(
    .WIDTH (`VGA_BUS_SIZE + 2),
    .CLK_DEL(2)
  ) u_delay (
    .clk (pclk),
    .rst (rst),
    .din ( {rect_type, vcount_in, vsync_in, hcount_in, hsync_in, rgb_in}),
    .dout ({rect_type_delayed, vcount_out_nxt, vsync_out_nxt, hcount_out_nxt, hsync_out_nxt, rgb_in_delayed})
  );
  
  localparam BLOCK_EMPTY = 2'b00;
  localparam BLOCK_GROUND = 2'b01;
  localparam BLOCK_CLOUD = 2'b10;
  localparam BLOCK_BONUS = 2'b11;
  
  always @*
    if(module_en == 0) 
      rgb_out_nxt = rgb_in_delayed;
    else if(rect_type_delayed == BLOCK_GROUND)
      if(((vcount_out_nxt+OFFSET_Y) >=  ypos) && ((vcount_out_nxt+OFFSET_Y) < (ypos + BLOCK_HEIGHT/2))) rgb_out_nxt = rgb_in_delayed;
      else rgb_out_nxt = (rgb_pixel_ground == 12'hFFF) ? rgb_in_delayed : rgb_pixel_ground;
    else if(rect_type_delayed == BLOCK_CLOUD)
      rgb_out_nxt = (rgb_pixel_cloud == 12'hFFF) ? rgb_in_delayed : rgb_pixel_cloud;
    else if(rect_type_delayed == BLOCK_BONUS)
      rgb_out_nxt = (rgb_pixel_ground == 12'hFFF) ? rgb_in_delayed : rgb_pixel_ground;
    else rgb_out_nxt = rgb_in_delayed;
      
  always @*
    begin
      relative_y = vcount_in + OFFSET_Y - ypos;
      if (((hcount_in >=  START_X+(0*BLOCK_WIDTH)) && (hcount_in < (START_X + (1*BLOCK_WIDTH)))) 
        && (((vcount_in+OFFSET_Y) >=  ypos) && ((vcount_in+OFFSET_Y) < (ypos + BLOCK_HEIGHT))) ) 
        begin 
          relative_x = hcount_in - (START_X+(0*BLOCK_WIDTH));    
          if(layer_map[0] == 1 ) rect_type = (bonus_map[0] == 1) ? BLOCK_BONUS : (block_type[0] == 1) ? BLOCK_GROUND : BLOCK_CLOUD; 
          else rect_type = BLOCK_EMPTY; 
        end
      else if (((hcount_in >=  START_X+(1*BLOCK_WIDTH)) && (hcount_in < (START_X + (2*BLOCK_WIDTH)))) 
        && (((vcount_in+OFFSET_Y) >=  ypos) && ((vcount_in+OFFSET_Y) < (ypos + BLOCK_HEIGHT))) ) 
        begin 
          relative_x = hcount_in - (START_X+(1*BLOCK_WIDTH));      
          if(layer_map[1] == 1 )  rect_type = (bonus_map[1] == 1) ? BLOCK_BONUS : (block_type[1] == 1) ? BLOCK_GROUND : BLOCK_CLOUD; 
          else rect_type = BLOCK_EMPTY;  
        end
      else if (((hcount_in >=  START_X+(2*BLOCK_WIDTH)) && (hcount_in < (START_X + (3*BLOCK_WIDTH)))) 
        && (((vcount_in+OFFSET_Y) >=  ypos) && ((vcount_in+OFFSET_Y) < (ypos + BLOCK_HEIGHT))) ) 
        begin 
          relative_x = hcount_in - (START_X+(2*BLOCK_WIDTH));      
          if(layer_map[2] == 1 )  rect_type = (bonus_map[2] == 1) ? BLOCK_BONUS : (block_type[2] == 1) ? BLOCK_GROUND : BLOCK_CLOUD; 
          else rect_type = BLOCK_EMPTY;  
        end
      else if (((hcount_in >=  START_X+(3*BLOCK_WIDTH)) && (hcount_in < (START_X + (4*BLOCK_WIDTH)))) 
        && (((vcount_in+OFFSET_Y) >=  ypos) && ((vcount_in+OFFSET_Y) < (ypos + BLOCK_HEIGHT))) ) 
        begin 
          relative_x = hcount_in - (START_X+(3*BLOCK_WIDTH));      
          if(layer_map[3] == 1 )  rect_type = (bonus_map[3] == 1) ? BLOCK_BONUS : (block_type[3] == 1) ? BLOCK_GROUND : BLOCK_CLOUD; 
          else rect_type = BLOCK_EMPTY;  
        end
      else if (((hcount_in >=  START_X+(4*BLOCK_WIDTH)) && (hcount_in < (START_X + (5*BLOCK_WIDTH)))) 
        && (((vcount_in+OFFSET_Y) >=  ypos) && ((vcount_in+OFFSET_Y) < (ypos + BLOCK_HEIGHT))) ) 
        begin 
          relative_x = hcount_in - (START_X+(4*BLOCK_WIDTH));      
          if(layer_map[4] == 1 )  rect_type = (bonus_map[4] == 1) ? BLOCK_BONUS : (block_type[4] == 1) ? BLOCK_GROUND : BLOCK_CLOUD; 
          else rect_type = BLOCK_EMPTY;   
        end
      else if (((hcount_in >=  START_X+(5*BLOCK_WIDTH)) && (hcount_in < (START_X + (6*BLOCK_WIDTH)))) 
        && (((vcount_in+OFFSET_Y) >=  ypos) && ((vcount_in+OFFSET_Y) < (ypos + BLOCK_HEIGHT))) ) 
        begin 
          relative_x = hcount_in - (START_X+(5*BLOCK_WIDTH));      
          if(layer_map[5] == 1 )  rect_type = (bonus_map[5] == 1) ? BLOCK_BONUS : (block_type[5] == 1) ? BLOCK_GROUND : BLOCK_CLOUD; 
          else rect_type = BLOCK_EMPTY;  
        end
      else if (((hcount_in >=  START_X+(6*BLOCK_WIDTH)) && (hcount_in < (START_X + (7*BLOCK_WIDTH)))) 
        && (((vcount_in+OFFSET_Y) >=  ypos) && ((vcount_in+OFFSET_Y) < (ypos + BLOCK_HEIGHT))) ) 
        begin 
          relative_x = hcount_in - (START_X+(6*BLOCK_WIDTH));      
          if(layer_map[6] == 1 )  rect_type = (bonus_map[6] == 1) ? BLOCK_BONUS : (block_type[6] == 1) ? BLOCK_GROUND : BLOCK_CLOUD; 
          else rect_type = BLOCK_EMPTY;  
        end
      else 
        begin
          relative_x = 0;
          relative_y = 0;
          rect_type = BLOCK_EMPTY; 
        end
    end
  
  always @( posedge pclk )
    if (rst) begin
      hcount_out <= 0;
      vcount_out <= 0; 
      hsync_out <= 0;
      vsync_out <= 0;
      pixel_addr <= 0;
      rgb_out <= 0; 
    end
    else begin  
      hcount_out <= hcount_out_nxt;
      vcount_out <= vcount_out_nxt; 
      hsync_out <= hsync_out_nxt;
      vsync_out <= vsync_out_nxt;
      pixel_addr <= pixel_addr_nxt;
      rgb_out <= rgb_out_nxt;
    end
endmodule
