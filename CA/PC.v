`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/01 15:54:35
// Design Name: 
// Module Name: PC
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


module PC(
    input           clk, reset,
    input           PCWrite,
    input   [31:0]  PC_in,
    output reg [31:0] PC_out
    );
    always @(posedge clk) begin
        if(reset)           PC_out <= 0;
        else if(PCWrite)    PC_out <= PC_out;
        else                PC_out <= PC_in;
    end
endmodule
