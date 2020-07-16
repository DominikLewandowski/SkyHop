`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2020 14:18:28
// Design Name: 
// Module Name: keyboard
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


module keyboard (
  input wire clk_40MHz,
  input wire clk_50MHz,
  input wire rst,
  input wire PS2Data,
  input wire PS2Clk,
  output reg [1:0] key
 );
 
  reg  [1:0]  key_nxt = 0;
  reg  [15:0] keycodev, keycodev_nxt = 0;

  wire [15:0] keycode;
  wire [15:0] keycode_latched_nxt = keycode;
  reg [15:0] keycode_latched;
  
  wire flag;
  wire flag_latched_nxt = flag;
  reg flag_latched;
  
  PS2Receiver uut (
    .clk(clk_50MHz),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
  );
  
  always @( posedge clk_40MHz ) begin
    keycode_latched <= keycode_latched_nxt;
    flag_latched <= flag_latched_nxt;
  end
  
  always @(*) begin
    key_nxt = 2'b00;
    keycodev_nxt = keycodev;
    
    if ( (keycode[7:0] != 8'hf0) && (keycode[15:8] != 8'hf0) ) 
    begin
      if( (flag_latched == 1'b1) && (keycode_latched[7:0] != keycodev[7:0] || keycodev[15:8]) ) 
      begin
        keycodev_nxt = keycode_latched;
        if( keycode_latched[7:0] == 8'h29 ) key_nxt = 2'b11;
        else if( keycode_latched[7:0] == 8'h6B ) key_nxt = 2'b01;
        else if( keycode_latched[7:0] == 8'h74 ) key_nxt = 2'b10;
      end
    end
  end

  always@( posedge clk_40MHz ) begin
    if(rst) begin
      key <= 2'b00;
      keycodev <= 16'h0000;
    end
    else begin
      key <= key_nxt;
      keycodev <= keycodev_nxt;
    end
  end
          
endmodule
