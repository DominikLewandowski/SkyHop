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
  input wire [11:0] score_in,
  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out
  );
  
  wire [`VGA_BUS_SIZE-1:0] vga_bus [1:0];
  
  reg disp_en, disp_en_nxt;
  
  reg [11:0] score_latched;
  wire [11:0] score_latched_nxt = (module_en == 0) ? score_in : score_latched;
  
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
    .score(score_latched),
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
    if(one_sec_tick) disp_en_nxt = ~disp_en;
    else disp_en_nxt = disp_en;
    
  always @(posedge clk)
    if(rst) begin
      disp_en <= 0;
      score_latched <= 0;
    end
    else begin
      disp_en <= disp_en_nxt;
      score_latched <= score_latched_nxt;
    end

endmodule
