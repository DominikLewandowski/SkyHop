`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 15:01:38
// Design Name: 
// Module Name: vga_timing
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

module vga_timing (
  input wire pclk,
  input wire rst,

  output wire [10:0] vcount,
  output wire vsync,
  output wire vblnk,
  output wire [10:0] hcount,
  output wire hsync,
  output wire hblnk
  );
  
  reg [10:0] vga_V_nxt, vga_V_cnt = 0;
  reg [10:0] vga_H_nxt, vga_H_cnt = 0;
    
  assign vcount = vga_V_cnt;
  assign hcount = vga_H_cnt;
  
  assign hsync = ((vga_H_cnt >= 840) & (vga_H_cnt < 968));
  assign hblnk = (vga_H_cnt >= 800);
  assign vsync = ((vga_V_cnt >= 601) & (vga_V_cnt < 605));
  assign vblnk = (vga_V_cnt >= 600);

    
  always @*
    if (vga_H_cnt == 1055) begin
      vga_H_nxt = 0;
      vga_V_nxt = (vga_V_cnt == 627) ? 0 : vga_V_cnt + 1;
    end
    else begin
      vga_H_nxt = vga_H_cnt + 1;
      vga_V_nxt = vga_V_cnt;
    end
  
always@(posedge pclk)
  if (rst) begin
    vga_V_cnt <=  0;
    vga_H_cnt <=  0;
  end
  else begin
    vga_V_cnt <=  vga_V_nxt;
    vga_H_cnt <=  vga_H_nxt;
  end  
endmodule
