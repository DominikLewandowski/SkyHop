`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2020 12:06:07
// Design Name: 
// Module Name: lfsr113
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


module lfsr113(
  input wire clk, 
  input wire reset,
  input wire enable_p,
  output reg [31:0] lfsr113_prng
 );
 
  parameter CI_S0 = 1'b0, CI_IDLE = 1'b1;
  
  reg [31:0] z1, z2, z3, z4;
  reg [31:0] z1_nxt, z2_nxt, z3_nxt, z4_nxt;
  wire [31:0] lfsr113_prng_nxt;
  reg state, state_nxt;
  
  assign lfsr113_prng_nxt = (state == CI_S0) ? (z1 ^ z2 ^ z3 ^ z4) : lfsr113_prng;
  
   always @(posedge clk) begin
     if (reset) begin
       state <= CI_IDLE;
     end else begin
       state <= state_nxt;
     end
   end
  
   always @* begin
     case (state)
       CI_IDLE: state_nxt = (enable_p == 1'b0) ? CI_IDLE : CI_S0;
       CI_S0: state_nxt = CI_S0;
       default: state_nxt = CI_IDLE;
     endcase
   end
  
  always @* begin
    case (state)
      CI_IDLE : begin
        z1_nxt = z1; 
        z2_nxt = z2; 
        z3_nxt = z3; 
        z4_nxt = z4;
      end
      CI_S0 : begin
        z1_nxt = (((z1 & 32'd4294967294) << 18) ^ (((z1 << 6)  ^ z1) >> 13));
        z2_nxt = (((z2 & 32'd4294967288) << 2)  ^ (((z2 << 2)  ^ z2) >> 27));
        z3_nxt = (((z3 & 32'd4294967280) << 7)  ^ (((z3 << 13) ^ z3) >> 21));
        z4_nxt = (((z4 & 32'd4294967168) << 13) ^ (((z4 << 3)  ^ z4) >> 12));
      end
    endcase
   end


   always @(posedge clk ) begin
     if (reset) begin
       lfsr113_prng <= 32'b0;
       z1 <= 32'd987654321;
       z2 <= 32'd987654321; 
       z3 <= 32'd987654321; 
       z4 <= 32'd987654321;
     end else begin
       lfsr113_prng <= lfsr113_prng_nxt;
       z1 <= z1_nxt; 
       z2 <= z2_nxt; 
       z3 <= z3_nxt; 
       z4 <= z4_nxt;
     end
   end
  
 endmodule