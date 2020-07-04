`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2020 06:13:14
// Design Name: 
// Module Name: one_second_timer
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


module one_second_timer(
  input wire clk, 
  input wire rst,
  input wire one_milli_tick,
  output reg one_sec_tick
  );
  
  localparam TIMER_CONST = 10'd1_000;
  
  reg one_sec_tick_nxt = 1'b0;
  reg [9:0] counter, counter_nxt = 10'd0;
  
  always @(*)
  begin
    if( counter >= (TIMER_CONST-1) ) 
      begin
        one_sec_tick_nxt = 1'b1;
        counter_nxt = 10'h000;
      end
    else
      begin 
        one_sec_tick_nxt = 1'b0;
        counter_nxt = (one_milli_tick) ? (counter + 1) : counter;
      end
  end
  
  always @( posedge clk )
  begin
    if(rst) begin
      one_sec_tick <= 1'b0;
      counter <= 10'd0;
    end else begin
      one_sec_tick <= one_sec_tick_nxt;
      counter <= counter_nxt;
    end
  end
  
endmodule
