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
  output wire [0:6] block_type,
  output reg [0:6] bonus_map,
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
  
  localparam LEFT = 1'b0, RIGHT = 1'b1;
  localparam SEED = 32'd987654321;
  
  localparam BONUS_PERIOD = 4'b1111;
  
  reg [31:0] z1, z2, z3, z4;
  reg [31:0] z1_nxt=SEED, z2_nxt=SEED, z3_nxt=SEED, z4_nxt=SEED;
  wire [31:0] pseudo_number = (z1 ^ z2 ^ z3 ^ z4);
  
  reg [2:0] state, state_nxt = S_START;
  reg [0:6] main_track, main_track_nxt, layer_map_nxt; 
  reg [0:6] second_track, second_track_nxt;
  reg load_layer_nxt, map_ready_nxt;
  reg direction_main, direction_second;
  reg [3:0] block_counter, block_counter_nxt;
  reg track_en, track_en_nxt;
  
  wire direction_main_nxt = ( ^pseudo_number[31:16] == 1'b1 ) ? LEFT : RIGHT;
  wire direction_second_nxt = ( ^pseudo_number[15:0] == 1'b0 ) ? LEFT : RIGHT;
  
  assign block_type = main_track | second_track;
  
  reg [3:0] bonus_counter, bonus_counter_nxt;
  reg [0:6] bonus_map_nxt;
    
  always @(*) begin
    state_nxt = state;
    layer_map_nxt = layer_map;
    main_track_nxt = main_track;
    second_track_nxt = second_track;
    block_counter_nxt = block_counter;
    load_layer_nxt = 0;
    map_ready_nxt = 0;
    track_en_nxt = track_en;
    bonus_counter_nxt = bonus_counter;
    bonus_map_nxt = bonus_map;
    
    case(state)
      S_START: 
        if( generate_map == 1 ) state_nxt = S_LAYER_1;
      
      S_LAYER_1: begin
        layer_map_nxt = 7'b0001000;
        main_track_nxt = 7'b0001000;
        load_layer_nxt = 1;
        state_nxt = S_LAYER_2;
      end
      
      S_LAYER_2: begin
        layer_map_nxt = 7'b1010101;
        main_track_nxt = ( direction_main == LEFT ) ? ( main_track << 1 ) : ( main_track >> 1 );
        load_layer_nxt = 1;
        state_nxt = S_LAYER_3;
      end
      
      S_LAYER_3: begin
        layer_map_nxt = layer_map ^ 7'b1111111;
        main_track_nxt = ( direction_main == LEFT ) ? ( main_track << 1 ) : ( main_track >> 1 );
        load_layer_nxt = 1;
        state_nxt = S_LAYER_4;
      end
      
      S_LAYER_4: begin
        layer_map_nxt = layer_map ^ 7'b1111111;
        main_track_nxt = ( direction_main == LEFT ) ? ( main_track << 1 ) : ( main_track >> 1 );
        load_layer_nxt = 1;
        map_ready_nxt = 1;
        block_counter_nxt = 0;
        track_en_nxt = 0;
        bonus_counter_nxt = 0;
        state_nxt = S_IDLE;
      end
      
      S_IDLE: 
        if( generate_map == 1 ) state_nxt = S_GENERATE;
      
      S_GENERATE: begin
        bonus_counter_nxt = bonus_counter + 1;
        bonus_map_nxt = 7'b0;
        
        layer_map_nxt = layer_map ^ 7'b1111111;
        if( main_track == 7'b1000000 ) begin
          main_track_nxt = main_track >> 1;
          if(bonus_counter == BONUS_PERIOD ) bonus_map_nxt = main_track >> 1;
          second_track_nxt = ( track_en == 1 ) ? second_track : (main_track >> 1);
        end
        else if( main_track == 7'b0000001 ) begin
          main_track_nxt = main_track << 1;
          if(bonus_counter == BONUS_PERIOD ) bonus_map_nxt = main_track << 1;
          second_track_nxt = ( track_en == 1 ) ? second_track : (main_track << 1);
        end  
        else begin
          main_track_nxt = ( direction_main == LEFT ) ? ( main_track << 1 ) : ( main_track >> 1 );
          if(bonus_counter == BONUS_PERIOD ) bonus_map_nxt = ( direction_main == LEFT ) ? ( main_track << 1 ) : ( main_track >> 1 );
          second_track_nxt = ( track_en == 1 ) ? second_track : (( direction_main == LEFT ) ? ( main_track << 1 ) : ( main_track >> 1 ));
        end  
        
        if( (track_en == 0) && (pseudo_number[3:0] < 4'hA) ) begin
          track_en_nxt = 1'b1;
          block_counter_nxt = pseudo_number[7:4];
        end    
              
        if( track_en == 1'b1 ) begin
          block_counter_nxt = block_counter - 1;
          if( (block_counter == 4'h0) && (^block_type == 1'b1) ) begin 
            second_track_nxt = 7'b0000000;
            track_en_nxt = 1'b0;
          end
          else if( second_track == 7'b1000000 ) second_track_nxt = second_track >> 1;
          else if( second_track == 7'b0000001 ) second_track_nxt = second_track << 1;
          else second_track_nxt = ( direction_second == LEFT ) ? ( second_track << 1 ) : ( second_track >> 1 );
        end
        state_nxt = S_IDLE;
      end
        
      default: state_nxt = S_IDLE; 
    endcase
  end
  
  always @( posedge clk ) begin
    if(rst) begin
      state <= S_START;
      layer_map <= 7'b0000000;
      main_track <= 7'b0000000;
      second_track <= 7'b0000000;
      load_layer <= 1'b0;
      map_ready <= 1'b0;
      direction_main <= 1'b0;
      direction_second <= 1'b0;
      block_counter <= 4'b0;
      track_en <= 1'b0;
      bonus_counter <= 4'b0;
      bonus_map <= 7'b0;
    end 
    else begin
      state <= state_nxt;
      layer_map <= layer_map_nxt;
      main_track <= main_track_nxt;
      second_track <= second_track_nxt;
      load_layer <= load_layer_nxt;
      map_ready <= map_ready_nxt;
      direction_main <= direction_main_nxt;
      direction_second <= direction_second_nxt;
      block_counter <= block_counter_nxt;
      track_en <= track_en_nxt;
      bonus_counter <= bonus_counter_nxt;
      bonus_map <= bonus_map_nxt;
    end
  end
  
  always @(*) begin
    z1_nxt = (((z1 & 32'd4294967294) << 18) ^ (((z1 << 6)  ^ z1) >> 13));
    z2_nxt = (((z2 & 32'd4294967288) << 2)  ^ (((z2 << 2)  ^ z2) >> 27));
    z3_nxt = (((z3 & 32'd4294967280) << 7)  ^ (((z3 << 13) ^ z3) >> 21));
    z4_nxt = (((z4 & 32'd4294967168) << 13) ^ (((z4 << 3)  ^ z4) >> 12));
  end
  
  always @( posedge clk ) 
    if(rst) {z1, z2, z3, z4} <= {SEED, SEED, SEED, SEED};
    else {z1, z2, z3, z4} <= {z1_nxt, z2_nxt, z3_nxt, z4_nxt};
    
endmodule
