`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/01 16:12:26
// Design Name: 
// Module Name: InFetch
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


module InFetch(
    input               clk, reset,
    input               PCSrc,
    input               PCWrite,
    input       [31:0]  PCimm_in,
    output      [31:0]  instruction_out,
    output  reg [31:0]  PC_out
    );
    wire        [31:0]  PC;
    wire        [31:0]  PC4 = (PCSrc) ? PCimm_in : PC + 4;
    
    PC B1_PC(
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .PC_in(PC4),        .PC_out(PC));
    
    iMEM B2_iMEM(
        .clk(clk),
        .reset(reset),
        .IF_ID_Write(PCWrite),
        .PCSrc(PCSrc),
        .PC_in(PC), .instruction_out(instruction_out));
        
    // IF/ID reg
    always @(posedge clk) begin
        if(reset||PCSrc)    PC_out <= 0;
        else if (PCWrite)   PC_out <= PC_out;
        else                PC_out <= PC;
    end
endmodule
