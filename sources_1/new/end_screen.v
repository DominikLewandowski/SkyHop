`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2020 00:24:32
// Design Name: 
// Module Name: end_screen
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


module end_screen(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire jump_fail,
  input wire one_sec_tick,
  input wire [11:0] score,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus [1:0];
  
  reg disp_en, disp_en_nxt;
  reg [11:0] real_score, real_score_nxt;
  
  
  string_game_end string_1 (
    .clk(clk),
    .rst(rst),
    .module_en(module_en),
    .jump_fail(jump_fail),
    .vga_bus_in(vga_bus_in),
    .vga_bus_out(vga_bus[0])
  );
 
  string_score_end string_2 (
    .clk(clk),
    .rst(rst),
    .module_en(module_en),
    .score(real_score),
    .vga_bus_in(vga_bus[0]),
    .vga_bus_out(vga_bus[1])
  );
  
  string_spacebar string_3 (
    .clk(clk),
    .rst(rst),
    .module_en(module_en & disp_en),
    .vga_bus_in(vga_bus[1]),
    .vga_bus_out(vga_bus_out)
  );

  always @*
  if( jump_fail ) begin
    if( score[3:0] > 0 ) begin
      real_score_nxt[11:8] = score[11:8];
      real_score_nxt[7:4]  = score[7:4];
      real_score_nxt[3:0]  = score[3:0] - 4'b0001;
    end 
    else if( score[7:4] > 0 ) begin
      real_score_nxt[11:8] = score[11:8];
      real_score_nxt[7:4]  = score[7:4] - 4'b0001;
      real_score_nxt[3:0]  = 4'b1001;
    end
    else begin
      real_score_nxt[11:8] = score[11:8] - 4'b0001;
      real_score_nxt[7:4]  = 4'b1001;
      real_score_nxt[3:0]  = 4'b1001;
    end
  end
  else real_score_nxt = score;
  
  always @*
    if(one_sec_tick) disp_en_nxt = ~disp_en;
    else disp_en_nxt = disp_en;
    
  always @(posedge module_en)
    real_score <= real_score_nxt;
  
  always @(posedge clk)
    if(rst) disp_en <= 0;
    else disp_en <= disp_en_nxt;

endmodule
