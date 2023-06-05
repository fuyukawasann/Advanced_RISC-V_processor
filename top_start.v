`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/08 17:31:24
// Design Name: 
// Module Name: top_start
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


module top_start(
    input         clk,
    input         rstb,
    input [15:0]  DIP_SW,
    input         PUSH_SW_UP,
    input         PUSH_SW_LEFT,
    input         PUSH_SW_MID,
    input         PUSH_SW_RIGHT,
    input         PUSH_SW_DOWN,
    output [15:0] LED,
    output [7:0] seg,
    output [7:0] digit
    );
    
    test_7seg u0 (.clk(clk), .rstb(rstb), .seg(seg), .digit(digit));
    
    test_sw_led u1 (.clk(clk), .rstb(rstb), .DIP_SW(DIP_SW), .PUSH_SW_UP(PUSH_SW_UP), .PUSH_SW_LEFT(PUSH_SW_LEFT), .PUSH_SW_MID(PUSH_SW_MID), .PUSH_SW_RIGHT(PUSH_SW_RIGHT), .PUSH_SW_DOWN(PUSH_SW_DOWN), .LED(LED));
    
endmodule
