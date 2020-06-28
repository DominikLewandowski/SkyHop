`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2020 14:41:50
// Design Name: 
// Module Name: block_generator
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


module block_generator(
  input wire layer_select,
  output wire [0:6] layer_map,
  output wire [0:6] block_type
);


  // ----------  For test only  ----------------- //
  assign layer_map = (layer_select) ? 7'b1010101 : 7'b0101010;
  assign block_type = (layer_select) ? 7'b1000101 : 7'b0100010;
  // -------------------------------------------- //
  
  
endmodule
