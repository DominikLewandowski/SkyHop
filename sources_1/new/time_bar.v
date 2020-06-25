`timescale 1ns / 1ps
`include "macros.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2020 18:47:33
// Design Name: 
// Module Name: time_bar
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


module time_bar(
  input wire clk,
  input wire rst,
  input wire module_en,
  input wire start,
  input wire one_ms_tick,

  input wire [`VGA_BUS_SIZE-1:0] vga_bus_in,
  output wire [`VGA_BUS_SIZE-1:0] vga_bus_out,
  
  output reg elapsed
  );
  
  localparam BAR_WIDTH = `GAME_WIDTH;
  localparam BAR_HEIGHT = 25;
  localparam MS_PER_PIXEL = 40;             // czas = 40 [ms/pixel] * 800 [pixel] = 32 sec
  localparam MS_PER_PIXEL_BIT = 6;
  
  `VGA_BUS_SPLIT( vga_bus_in )
  `VGA_DEFINE_OUT_REG
  `VGA_BUS_MERGE( vga_bus_out )
  
  wire [10:0] hcount_out_nxt = hcount_in;
  wire [10:0] vcount_out_nxt = vcount_in;
  wire hsync_out_nxt = hsync_in;
  wire vsync_out_nxt = vsync_in;

  reg [11:0] rgb_out_nxt;
  reg elapsed_nxt;
  
  reg [(MS_PER_PIXEL_BIT-1):0] time_counter, time_counter_nxt = 0;
  reg [9:0] pixel_counter, pixel_counter_nxt = 0;

  
  localparam  [1:0]
              S_IDLE    = 2'b00,
              S_ENABLE  = 2'b01,
              S_STARTED = 2'b10,
              S_STOPPED = 2'b11;
  
  reg [1:0] state, state_nxt = S_IDLE; 
  
  
  always@(posedge clk)
    if (rst) begin
      hcount_out <= 0;
      vcount_out <=  0; 
      hsync_out <=  0;
      vsync_out <=  0;
      rgb_out <=  0;
      time_counter <= 0;
      pixel_counter <= 0;
      state <= S_IDLE;
      elapsed <= 0;
    end
    else begin
      hcount_out <= hcount_out_nxt;
      vcount_out <= vcount_out_nxt; 
      hsync_out <= hsync_out_nxt;
      vsync_out <= vsync_out_nxt;
      rgb_out <= rgb_out_nxt;
      time_counter <= time_counter_nxt;
      pixel_counter <= pixel_counter_nxt;
      state <= state_nxt;
      elapsed <= elapsed_nxt;
    end  
  
  always @*
  begin
    rgb_out_nxt = rgb_in;
    pixel_counter_nxt = pixel_counter;
    time_counter_nxt = time_counter;
    state_nxt = state;
    elapsed_nxt = 1'b0;
    
    case(state)
    
      S_IDLE:
        if(module_en == 1) state_nxt = S_ENABLE;
          
      S_ENABLE:
        begin   
          if( (vcount_in >= (`GAME_HEIGHT - BAR_HEIGHT)) && (vcount_in < `GAME_HEIGHT) ) rgb_out_nxt = `BAR_COLOR;
          if(start == 1)
            begin  
              state_nxt = S_STARTED;
              pixel_counter_nxt = BAR_WIDTH-1;
              time_counter_nxt = 0;
            end
          else if( module_en == 0 ) state_nxt = S_IDLE;
          else state_nxt = S_ENABLE;
        end
        
      S_STARTED:
        begin
          if( one_ms_tick == 1 ) 
          begin 
            time_counter_nxt = time_counter + 1;
            if( time_counter >= MS_PER_PIXEL ) 
              begin 
                time_counter_nxt = 0;
                pixel_counter_nxt = pixel_counter - 1;
              end
          end

          if( (vcount_in >= (`GAME_HEIGHT - BAR_HEIGHT)) && (vcount_in < `GAME_HEIGHT) && (hcount_in < BAR_WIDTH) )
                rgb_out_nxt = (hcount_in >= pixel_counter) ? `BAR_BG_COLOR : `BAR_COLOR; 
          if( pixel_counter == 0 ) state_nxt = S_STOPPED;
          else if( module_en == 0 ) state_nxt = S_IDLE;
          else state_nxt = S_STARTED;
        end
        
      S_STOPPED:
        begin
          elapsed_nxt = 1'b1;    
          if(module_en == 0) state_nxt = S_IDLE;
          else state_nxt = S_STOPPED;
          if( (vcount_in >= (`GAME_HEIGHT - BAR_HEIGHT)) && (vcount_in < `GAME_HEIGHT) ) rgb_out_nxt = `BAR_BG_COLOR;
        end
        
      default: state_nxt = S_IDLE;
    endcase  
  end  
  
endmodule
