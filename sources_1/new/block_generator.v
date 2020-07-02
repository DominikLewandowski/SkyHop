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
  input wire clk,
  input wire generate_map,
  output reg [0:6] layer_map,
  output reg [0:6] block_type,
  output wire map_ready
);

  assign map_ready = 1'b1;
  reg [2:0] counter, counter_nxt = 3'b000;
  
  reg [0:6] layer_map_nxt; 
  reg [0:6] block_type_nxt;
  
  always@* begin
    if(generate_map) counter_nxt = counter + 1;
    else counter_nxt = counter;
  end
  
  always@* begin
    case(counter)
      3'b000: begin
        layer_map_nxt  = 7'b0001000; 
        block_type_nxt = 7'b0000000;
      end
      3'b001: begin
        layer_map_nxt  = 7'b1010101; 
        block_type_nxt = 7'b1000101; 
      end
      3'b010: begin
        layer_map_nxt  = 7'b0101010; 
        block_type_nxt = 7'b0001010; 
      end
      3'b011: begin
        layer_map_nxt  = 7'b1010101; 
        block_type_nxt = 7'b0010101; 
      end
      3'b100: begin
        layer_map_nxt  = 7'b0101010; 
        block_type_nxt = 7'b0001010; 
      end
      3'b101: begin
        layer_map_nxt  = 7'b1010101; 
        block_type_nxt = 7'b0010101;   
      end
      3'b110: begin
        layer_map_nxt  = 7'b0101010;
        block_type_nxt = 7'b0001010; 
      end
      3'b111: begin
        layer_map_nxt  = 7'b1010101;
        block_type_nxt = 7'b1000101;        
      end
    endcase
  end
  
  always @(posedge clk) begin
    layer_map <= layer_map_nxt;
    block_type <= block_type_nxt;
    counter <= counter_nxt;
  end
  
endmodule
