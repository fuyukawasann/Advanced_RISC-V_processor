`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/08 16:33:14
// Design Name: 
// Module Name: Execution
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


module Execution(
    input clk, reset,
    input flush,
    // control signal
    input   Ctl_ALUSrc_in, Ctl_MemtoReg_in, Ctl_RegWrite_in, Ctl_MemRead_in, Ctl_MemWrite_in, Ctl_Branch_in, Ctl_ALUOpcode1_in, Ctl_ALUOpcode0_in,
    output reg  Ctl_MemtoReg_out, Ctl_RegWrite_out, Ctl_MemRead_out, Ctl_MemWrite_out, Ctl_Branch_out,
    // bypass
    input   [4:0]   Rd_in,
    output reg  [4:0]   Rd_out,
    input   jal_in, jalr_in,
    output reg  jal_out, jalr_out, // bypass 추가
    //
    input   [31:0]  Immediate_in, ReadData1_in, ReadData2_in, PC_in,
    input   [31:0]  mem_data, wb_data, // 추가 forwarding
    input   [6:0]   funct7_in,
    input   [2:0]   funct3_in,
    input   [1:0]   ForwardA_in, ForwardB_in, // 추가 forwarding
    output reg      Zero_out,
    
    output reg  [31:0]  ALUresult_out, PCimm_out, ReadData2_out, PC_out // 추가 jal
    );
    
    // RISC-V
    wire    [3:0]   ALU_ctl;
    wire    [31:0]   ALUresult;
    wire    Zero;
    
    wire    [31:0]  ALU_input1 = (ForwardA_in==2'b10) ? mem_data : (ForwardA_in==2'b01) ? wb_data : ReadData1_in;
    
    wire    [31:0]  ForwardB_input = (ForwardB_in==2'b10) ? mem_data : (ForwardB_in==2'b01) ? wb_data : ReadData2_in;
    
    wire    [31:0]  ALU_input2 = (Ctl_ALUSrc_in) ? Immediate_in : ForwardB_input;
    
    ALU_control B0 ({Ctl_ALUOpcode1_in, Ctl_ALUOpcode0_in}, funct7_in, funct3_in, ALU_ctl);
    ALU B1 (ALU_ctl, ALU_input1, ALU_input2, ALUresult, Zero);
    
    
    always @(posedge clk) begin
        Ctl_MemtoReg_out    <=  (reset||flush) ? 0 : Ctl_MemtoReg_in;
        Ctl_RegWrite_out    <=  (reset||flush) ? 0 : Ctl_RegWrite_in;
        Ctl_MemRead_out     <=  (reset||flush) ? 0 : Ctl_MemRead_in;
        Ctl_MemWrite_out    <=  (reset||flush) ? 0 : Ctl_MemWrite_in;
        Ctl_Branch_out      <=  (reset||flush) ? 0 : Ctl_Branch_in;
        
        PC_out              <=  (reset) ? 1'b0 : PC_in;
        jalr_out            <=  (reset) ? 1'b0 : jalr_in;
        jal_out             <=  (reset) ? 1'b0 : jal_in;
        
        Rd_out              <=  Rd_in;
        PCimm_out           <=  PC_in + (Immediate_in << 1);
        ReadData2_out       <=  (reset) ? 0 : ForwardB_input;
        ALUresult_out       <=  ALUresult;
        Zero_out            <=  (reset) ? 0 : Zero;
    end
    
    
endmodule
