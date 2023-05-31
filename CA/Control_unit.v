`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/01 16:49:40
// Design Name: 
// Module Name: Control_unit
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


module Control_unit(
    input [6:0] opcode,
    input reset,
    output reg [7:0] Ctl_out
    );
    
    always @(*) begin
        if (reset) Ctl_out = 8'b0;
        else
            case (opcode)
                7'b01100_11 : Ctl_out = 8'b001000_10;   // R-type
                7'b00100_11 : Ctl_out = 8'b101000_11;   // I-type MCC
                7'b00000_11 : Ctl_out = 8'b111100_00;
                7'b00000_11 : Ctl_out = 8'b100010_00;   // S-type
                7'b01000_11 : Ctl_out = 8'b000001_00;   // SB-type
                7'b11000_11 : Ctl_out = 8'b001001_00;   // UJ-type
                7'b11001_11 : Ctl_out = 8'b101001_11;
                
                default     : Ctl_out = 8'b0;   // control unit
            endcase
    end
endmodule
