`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 23:07:25
// Design Name: 
// Module Name: tb_RISCVpipeline
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


module tb_RISCVpipeline;

    // Inputs
    reg clk;
    reg reset;
    reg key;
    // Outputs
    wire [7:0] digit;
    wire [7:0] fnd;
    wire [15:0] LED;
    
    RISCVpipeline uut(
        .key(key),
        .digit(digit),
        .fnd(fnd),
        .LED(LED),
        .clk(clk),
        .reset(reset)
    );
    
    // TB
    initial begin
        reset = 0;
        #54 reset = 1;
    end
    
    initial begin
        clk = 0;
        key = 0;
        forever #5 clk = ~clk;
    end

endmodule
