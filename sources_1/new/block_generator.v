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
  input wire rst, 
  input wire generate_map,
  output reg [0:6] layer_map,
  output reg [0:6] block_type,
  output reg load_layer,
  output reg map_ready
);

  localparam S_START = 3'b000;
  localparam S_L1 = 3'b001; 
  localparam S_L2 = 3'b011; 
  localparam S_L3 = 3'b010; 
  localparam S_L4 = 3'b110; 
  localparam S_IDLE = 3'b111;
  localparam S_GENERATE = 3'b101; 
  
  reg [2:0] state, state_nxt = S_START;
  reg load_layer_nxt, map_ready_nxt;

  reg [0:6] layer_map_nxt, block_type_nxt; 
  
  always @* begin
    state_nxt = state;
    load_layer_nxt = 0;
    layer_map_nxt = 7'b0000000;
    block_type_nxt = 7'b0000000;
    map_ready_nxt = 0;
    
    case(state)
      S_START: if( generate_map == 1 ) state_nxt = S_L1;
      S_L1: begin
        layer_map_nxt = 7'b0001000; 
        block_type_nxt = 7'b0000000;
        load_layer_nxt = 1;
        state_nxt = S_L2;
      end
      S_L2: begin
        map_ready_nxt = 1;
        layer_map_nxt = 7'b1010101; 
        block_type_nxt = 7'b1000101;
        load_layer_nxt = 1;
        state_nxt = S_L3;
      end
      S_L3: begin
        layer_map_nxt = 7'b0101010; 
        block_type_nxt = 7'b0001010;
        load_layer_nxt = 1;
        state_nxt = S_L4;
      end
     S_L4: begin
        layer_map_nxt = 7'b1010101; 
        block_type_nxt = 7'b0010101;
        load_layer_nxt = 1;
        map_ready_nxt = 1;
        state_nxt = S_IDLE;
      end
      S_IDLE: state_nxt = S_IDLE;
    endcase
  
  end
  
  always @(posedge clk) begin
    if(rst) begin
      state <= S_START;
      layer_map <= 7'b0000000;
      block_type <= 7'b0000000;
      load_layer <= 0;
      map_ready <= 0;
    end 
    else begin
      state <= state_nxt;
      layer_map <= layer_map_nxt;
      block_type <= block_type_nxt;
      load_layer <= load_layer_nxt;
      map_ready <= map_ready_nxt;
    end
  end
  
endmodule
