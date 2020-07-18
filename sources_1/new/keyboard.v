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
  input wire clk_50MHz,
  input wire rst,
  input wire PS2Data,
  input wire PS2Clk,
  output reg [1:0] key
 );
 
 localparam SPACEBAR_CODE = 8'h29;
 localparam L_ARROW_CODE  = 8'h6B;
 localparam R_ARROW_CODE  = 8'h74;
 
  reg   [1:0] key_nxt;
  reg         start, start_nxt = 0;
  reg  [15:0] keycodev, keycodev_nxt = 0;
  wire [15:0] keycode;
  wire        flag;
  
  PS2Receiver uut (
    .clk(clk_50MHz),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
  );
  
  always@(*)
    if (keycode[7:0] == 8'hf0) begin
      start_nxt = 1'b0;
      keycodev_nxt = keycodev;
    end else if (keycode[15:8] == 8'hf0) begin
      start_nxt = 1'b0;
      keycodev_nxt = (flag == 1'b1 && (keycode != keycodev) ) ? keycode : keycodev;
    end else begin
      start_nxt = (flag == 1'b1 && (keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0) ) ? 1'b1 : 1'b0;
      keycodev_nxt = (flag == 1'b1 && (keycode[7:0] != keycodev[7:0] || keycodev[15:8] == 8'hf0) ) ? keycode : keycodev;
    end

  always@(posedge clk_50MHz) begin
    start <= start_nxt;
    keycodev <= keycodev_nxt;
  end
  
  reg delay_flag, delay_flag_nxt = 1'b0;
  
  always@(*) 
   if( delay_flag != 1'b0 ) begin
     key_nxt = key;
     delay_flag_nxt = delay_flag - 1;
   end 
   else if( start == 1'b1 ) 
     case( keycodev[7:0] )
       SPACEBAR_CODE: begin
         key_nxt = `K_SPACEBAR;
         delay_flag_nxt = 1'b1;
       end
       L_ARROW_CODE: begin
         key_nxt = `K_LEFT;
         delay_flag_nxt = 1'b1;
       end
       R_ARROW_CODE: begin
         key_nxt = `K_RIGHT;
         delay_flag_nxt = 1'b1;
       end
       default: begin
         key_nxt = `K_NULL;
         delay_flag_nxt = 1'b0;
       end
     endcase
   else begin
     key_nxt = `K_NULL;
     delay_flag_nxt = 1'b0;
   end
  
  always@(posedge clk_50MHz) begin
    if(rst) begin
      key <= `K_NULL;
      delay_flag <= 1'b0;
    end
    else begin
      key <= key_nxt;
      delay_flag <= delay_flag_nxt;
    end  
  end
          
endmodule
