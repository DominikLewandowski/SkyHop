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
  localparam S_LAYER_1 = 3'b001; 
  localparam S_LAYER_2 = 3'b011; 
  localparam S_LAYER_3 = 3'b010; 
  localparam S_LAYER_4 = 3'b110;  
  localparam S_IDLE = 3'b111;
  localparam S_GENERATE = 3'b101; 
  
  reg [2:0] state, state_nxt = S_START;
  
  reg [0:6] block_type_nxt, layer_map_nxt; 
  reg load_layer_nxt, map_ready_nxt;
  
  localparam LEFT = 1'b0, RIGHT = 1'b1;
  reg direction, direction_nxt;
    
  always @(*) begin
    state_nxt = state;
    layer_map_nxt = layer_map;
    block_type_nxt = block_type;
    load_layer_nxt = 0;
    map_ready_nxt = 0;
    
    case(state)
      S_START: 
        if( generate_map == 1 ) state_nxt = S_LAYER_1;
      
      S_LAYER_1: begin
        layer_map_nxt = 7'b0001000;
        block_type_nxt = 7'b0001000;
        load_layer_nxt = 1;
        state_nxt = S_LAYER_2;
      end
      
      S_LAYER_2: begin
        map_ready_nxt = 1;
        layer_map_nxt = 7'b1010101;
        block_type_nxt = 7'b0010000;
        load_layer_nxt = 1;
        state_nxt = S_LAYER_3;
      end
      
      S_LAYER_3: begin
        layer_map_nxt = layer_map ^ 7'b1111111;
        block_type_nxt = 7'b0100000;
        load_layer_nxt = 1;
        state_nxt = S_LAYER_4;
      end
      
      S_LAYER_4: begin
        layer_map_nxt = layer_map ^ 7'b1111111;
        block_type_nxt = 7'b1000000;
        load_layer_nxt = 1;
        map_ready_nxt = 1;
        state_nxt = S_IDLE;
      end
      
      S_IDLE: 
        if( generate_map == 1 ) state_nxt = S_GENERATE;
      
      S_GENERATE: begin
        layer_map_nxt = layer_map ^ 7'b1111111;
        block_type_nxt = 7'b0110000;
        state_nxt = S_IDLE;
      end
        
      default: state_nxt = S_IDLE; 
    endcase
  end
  
  always @( posedge clk ) begin
    if(rst) begin
      state <= S_START;
      layer_map <= 7'b0000000;
      block_type <= 7'b0000000;
      load_layer <= 1'b0;
      map_ready <= 1'b0;
      direction <= 1'b0;
    end 
    else begin
      state <= state_nxt;
      layer_map <= layer_map_nxt;
      block_type <= block_type_nxt;
      load_layer <= load_layer_nxt;
      map_ready <= map_ready_nxt;
      direction <= direction_nxt;
    end
  end
  
endmodule
