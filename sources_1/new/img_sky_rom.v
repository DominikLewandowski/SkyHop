`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2020 14:52:08
// Design Name: 
// Module Name: img_sky_rom
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


module img_sky_rom(
  input wire clk ,
  input wire [13:0] address,  // address = {addry[7:0], addrx[7:0]}
  output reg [11:0] rgb
);


  reg [11:0] rom [0:16383];

  initial $readmemh("../../img_block_sky.data", rom); 

  always @(posedge clk)
    rgb <= rom[address];

endmodule
