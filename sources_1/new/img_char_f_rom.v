`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2020 08:32:07
// Design Name: 
// Module Name: img_char_f_rom
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


module img_char_f_rom(
  input wire clk ,
  input wire [13:0] address,  // address = {addry[7:0], addrx[7:0]}
  output reg [11:0] rgb
);

  reg [11:0] rom [0:16383];

  initial $readmemh("../../img_char_front.data", rom); 

  always @(posedge clk)
    rgb <= rom[address];

endmodule
