`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2020 21:41:40
// Design Name: 
// Module Name: char_movement_timer
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


module char_movement_timer #(parameter TIMER_CONST = 17'd40_000)
(
  input wire clk_40MHz, 
  input wire rst,
  output reg movement_tick
);

  reg movement_tick_nxt = 0;
  reg [17:0] counter, counter_nxt = 0;
  
  always @(*)
  begin
    if( counter >= (TIMER_CONST-1) ) 
      begin
        movement_tick_nxt = 1'b1;
        counter_nxt = 18'h0000;
      end
    else
      begin 
        movement_tick_nxt = 1'b0;
        counter_nxt = counter + 1;
      end
  end
  
  always@ (posedge clk_40MHz)
  begin
    if(rst)
      begin
        movement_tick <= 1'b0;
        counter <= 18'h0000;
      end
    else
      begin
        movement_tick <= movement_tick_nxt;
        counter <= counter_nxt;
      end
  end
endmodule
