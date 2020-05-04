`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 20:22:09
// Design Name: 
// Module Name: millisecond_timer
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


module millisecond_timer(
  input wire clk_40MHz, 
  input wire rst,
  output reg one_milli_tick
  );
  
  localparam TIMER_CONST = 16'd40_000;    // 40 000 * 25ns = 1ms
  
  reg one_milli_tick_nxt = 0;
  reg [15:0] counter, counter_nxt = 0;
  
  always@*
  begin
    if( counter >= (TIMER_CONST-1) ) 
      begin
        one_milli_tick_nxt = 1'b1;
        counter_nxt = 16'h0000;
      end
    else
      begin 
        one_milli_tick_nxt = 1'b0;
        counter_nxt = counter + 1;
      end
  end
  
  always@ (posedge clk_40MHz or posedge rst)
  begin
    if(rst)
      begin
        one_milli_tick <= 0;
        counter <= 0;
      end
    else
      begin
        one_milli_tick <= one_milli_tick_nxt;
        counter <= counter_nxt;
      end
  end
  
endmodule
