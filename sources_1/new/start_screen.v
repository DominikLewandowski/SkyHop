`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 17:36:33
// Design Name: 
// Module Name: start_screen
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


module start_screen(
  input wire clk,
  input wire rst,
  input wire module_en,

  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire [11:0] rgb_in,
  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg [11:0] rgb_out
  );
  
  wire [10:0] vcount_out_nxt = vcount_in;
  wire vsync_out_nxt = vsync_in;
  wire vblnk_out_nxt = vblnk_in;
  wire [10:0] hcount_out_nxt = hcount_in;
  wire hsync_out_nxt = hsync_in;
  wire hblnk_out_nxt = hblnk_in;
  
  reg [11:0] rgb_nxt;
  
  always @*
    begin
      if ( module_en == 1 ) 
      begin
        if( (hcount_in > 100) && (hcount_in < 150) && (vcount_in > 100) && (vcount_in < 150) ) rgb_nxt = 12'h000;
        else rgb_nxt = rgb_in; 
      end
      else rgb_nxt = rgb_in; 
    end  
     
  

  always@(posedge clk)
    if (rst) begin
      rgb_out <=  0; 
      vcount_out <=  0; 
      vsync_out <=  0;
      vblnk_out <=  0;
      hcount_out <= 0;
      hsync_out <=  0;
      hblnk_out <=  0;
    end
    else begin
      rgb_out <= rgb_nxt;
      vcount_out <= vcount_out_nxt; 
      vsync_out <= vsync_out_nxt;
      vblnk_out <= vblnk_out_nxt;
      hcount_out <= hcount_out_nxt;
      hsync_out <= hsync_out_nxt;
      hblnk_out <= hblnk_out_nxt;
    end  
  
endmodule
