`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/03 14:37:37
// Design Name: 
// Module Name: Branch_predictor
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


module Branch_predictor(new_predict, clk, reset, correction);
    // Input Port
    input clk, reset, correction;   // correction : 분기 결과에서 taken이면 1 not taken이면 0
    
    // Output Port
    output new_predict;
    
    // Parameter
    parameter   SNT = 2'b00, LNT = 2'b01, LT = 2'b10, ST = 2'b11;
    reg         [1:0] state, next;
    
    // Satate Register 00 : SNT, 01 : LNT, 10 : LT, 11 : ST
    always @(posedge clk, reset)
        if(reset)   state <= SNT;
        else        state <= next;
        
    // Next State Logic
    always @(state) begin
        next = 2'bx;
        case(state)
            SNT :   if(correction)  next = LNT;
                    else            next = SNT;
            LNT :   if(correction)  next = LT;
                    else            next = SNT;
            LT  :   if(correction)  next = ST;
                    else            next = LNT;
            ST  :   if(correction)  next = ST;
                    else            next = LNT;
        endcase
    end
    
    // Output Logic
    assign new_predict = (state==ST || state==LT);
    
endmodule
