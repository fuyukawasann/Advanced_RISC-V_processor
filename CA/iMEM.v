`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/01 16:10:04
// Design Name: 
// Module Name: iMEM
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


module iMEM(
    input clk, reset,
    input   IF_ID_Write, PCSrc,
    input [31:0] PC_in,
    output reg [31:0] instruction_out
    );
    parameter ROM_size = 128;
    reg [31:0] ROM [0:ROM_size-1];
    integer i;
    initial begin
        for (i=0; i!=ROM_size; i=i+1) begin
            ROM[i] = 32'b0;
        end
        $readmemh ("darksocv.rom.mem",ROM);
    end
    
    always @(posedge clk) begin
        if (!IF_ID_Write) begin
            if (reset||PCSrc)       instruction_out <= 32'b0;
            else                    instruction_out <= ROM[PC_in[31:2]];
        end
    end
endmodule
