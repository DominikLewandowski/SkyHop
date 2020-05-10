`ifndef MACROS_VH
`define MACROS_V

// ------ DRAW BACKGROUND ------ //
`define BG_COLOR_L 12'h5_9_F
`define BG_COLOR_D 12'h3_7_F

// ------ TIME BAR ------ //
`define BAR_COLOR 12'h4_C_0
`define BAR_BG_COLOR 12'h3_3_3


// ------ VGA BUS ------  //
`define VGA_BUS_SIZE 36

`define VGA_HCOUNT_BIT 10:0
`define VGA_VCOUNT_BIT 21:11
`define VGA_HSYNC_BIT 22
`define VGA_VSYNC_BIT 23
`define VGA_RGB_BIT 35:24

`define VGA_BUS_SPLIT( BUS_NAME ) \
  wire [10:0] hcount_in = BUS_NAME[`VGA_HCOUNT_BIT]; \
  wire [10:0] vcount_in = BUS_NAME[`VGA_VCOUNT_BIT]; \
  wire hsync_in = BUS_NAME[`VGA_HSYNC_BIT]; \
  wire vsync_in = BUS_NAME[`VGA_VSYNC_BIT]; \
  wire [11:0] rgb_in = BUS_NAME[`VGA_RGB_BIT];
    
`define VGA_DEFINE_OUT_REG \
    reg [10:0] hcount_out; \
    reg [10:0] vcount_out; \
    reg hsync_out; \
    reg vsync_out; \
    reg [11:0] rgb_out;

`define VGA_BUS_MERGE( BUS_NAME ) \
    assign BUS_NAME[`VGA_HCOUNT_BIT] = hcount_out; \
    assign BUS_NAME[`VGA_VCOUNT_BIT] = vcount_out; \
    assign BUS_NAME[`VGA_HSYNC_BIT] = hsync_out; \
    assign BUS_NAME[`VGA_VSYNC_BIT] = vsync_out; \
    assign BUS_NAME[`VGA_RGB_BIT] = rgb_out;
    
 `endif