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


module keyboard(
  input wire clk,
  input wire rst,
  input wire btnU, btnL, btnR,
  //input wire PS2Data,
  //input wire PS2Clk,
  output wire [1:0] key_code
  //output reg flag,
  //output reg [31:0] data
 );
 
   // -------------  For test only  ------------------------------------------------------- //
 wire btnU_tick, btnL_tick, btnR_tick;
 btn_debounce my_db_1( .clk(clk), .reset(rst), .sw(btnU), .db_level(), .db_tick(btnU_tick));
 btn_debounce my_db_2( .clk(clk), .reset(rst), .sw(btnL), .db_level(), .db_tick(btnL_tick));
 btn_debounce my_db_3( .clk(clk), .reset(rst), .sw(btnR), .db_level(), .db_tick(btnR_tick));
 
 assign key_code =  btnU_tick ? 2'b11 : 
                            btnL_tick ? 2'b01 :
                            btnR_tick ? 2'b10 : 2'b00;
 // ------------------------------------------------------------------------------------- // 
 
endmodule
