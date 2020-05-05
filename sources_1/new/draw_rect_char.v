`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2020 15:54:50
// Design Name: 
// Module Name: draw_rect_char
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


module draw_rect_char
#( parameter
  TEXT_COLOUR = 12'h0_2_9,
  TEXT_POS_X = 50,
  TEXT_POS_Y = 50,
  TEXT_SIZE_X = 16,
  TEXT_SIZE_Y = 16
)
(
  input wire clk,
  input wire rst,
  input wire text_en,
  input wire [7:0] char_pixels,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out,
  output reg [7:0] char_xy,
  output reg [3:0] char_line
);

  `VGA_BUS_SPLIT( vga_bus_in )
  `DEFINE_VGA_OUT_REG
  `VGA_BUS_MERGE( vga_bus_out )
  
  wire [10:0] hcount_out_nxt, vcount_out_nxt;
  wire hsync_out_nxt, vsync_out_nxt, hblnk_out_nxt, vblnk_out_nxt;
  reg [11:0] rgb_out_nxt;
  wire [11:0] rgb_delayed;
  
  localparam CHAR_WIDTH = 8;
  localparam CHAR_HEIGHT = 16;
  localparam TEXT_WIDTH = CHAR_WIDTH * TEXT_SIZE_X;
  localparam TEXT_HEIGHT = CHAR_HEIGHT * TEXT_SIZE_Y;
  
  wire [10:0] offset_hcount_in = hcount_in - TEXT_POS_X;
  wire [10:0] offset_vcount_in = vcount_in - TEXT_POS_Y;
  wire [10:0] offset_hcount_out = hcount_out_nxt - TEXT_POS_X;
  wire [7:0] char_xy_nxt = {offset_hcount_in[6:3], offset_vcount_in[7:4]};
  wire [3:0] char_line_nxt = offset_vcount_in[3:0];
  wire [7:0] current_pixel;

  assign current_pixel = (offset_hcount_out[2:0] == 3'b000) ? 8'b1000_0000: 
                         (offset_hcount_out[2:0] == 3'b001) ? 8'b0100_0000: 
                         (offset_hcount_out[2:0] == 3'b010) ? 8'b0010_0000: 
                         (offset_hcount_out[2:0] == 3'b011) ? 8'b0001_0000:
                         (offset_hcount_out[2:0] == 3'b100) ? 8'b0000_1000:
                         (offset_hcount_out[2:0] == 3'b101) ? 8'b0000_0100:
                         (offset_hcount_out[2:0] == 3'b110) ? 8'b0000_0010: 8'b0000_0001;

  delay #(
      .WIDTH (38),
      .CLK_DEL(2)
  ) u_delay (
      .clk (clk),
      .rst (rst),
      .din ( {hcount_in, hsync_in, hblnk_in, vcount_in, vsync_in, vblnk_in, rgb_in}),
      .dout ({hcount_out_nxt, hsync_out_nxt, hblnk_out_nxt, vcount_out_nxt, vsync_out_nxt, vblnk_out_nxt, rgb_delayed})
  );
  
  always@*
  begin
    rgb_out_nxt = rgb_delayed;
  
    if( text_en == 1 )
    begin
      if((hcount_out_nxt >= TEXT_POS_X) && (hcount_out_nxt < (TEXT_POS_X+TEXT_WIDTH)) && (vcount_out_nxt >= TEXT_POS_Y) && (vcount_out_nxt < (TEXT_POS_Y+TEXT_HEIGHT))) 
      begin  
        rgb_out_nxt = (char_pixels & current_pixel) ? TEXT_COLOUR : rgb_delayed;
      end
    end
  end
  
  
  always@ (posedge clk)
    if(rst) 
      begin
      hcount_out <= 0;
      hsync_out <= 0;
      hblnk_out <= 0;
      vcount_out <= 0;
      vsync_out <= 0;
      vblnk_out <= 0;
      rgb_out <= 0;
      char_xy <= 0;
      char_line <= 0;
      end
    else 
      begin
      hcount_out <= hcount_out_nxt;
      hsync_out <= hsync_out_nxt;
      hblnk_out <= hblnk_out_nxt;
      vcount_out <= vcount_out_nxt;
      vsync_out <= vsync_out_nxt;
      vblnk_out <= vblnk_out_nxt;
      rgb_out <= rgb_out_nxt;
      char_xy <= char_xy_nxt;
      char_line <= char_line_nxt;
      end
endmodule

