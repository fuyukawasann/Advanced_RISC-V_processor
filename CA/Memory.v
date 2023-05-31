`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 00:30:43
// Design Name: 
// Module Name: Memory
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


module Memory(
    input   reset, clk,
    input   Ctl_MemtoReg_in, Ctl_RegWrite_in, Ctl_MemRead_in, Ctl_MemWrite_in, Ctl_Branch_in,
    output reg Ctl_MemtoReg_out, Ctl_RegWrite_out,
    // bypass
    input   [4:0]   Rd_in,
    output reg  [4:0] Rd_out,
    //
    input   jal_in, jalr_in, // 추가 jal
    input   Zero_in,
    input   [31:0]  Write_Data, ALUresult_in, PCimm_in, PC_in, // 추가 jal
    output  PCSrc,
    
    output reg          jal_out, jalr_out, // 추가 jal
    output reg  [31:0]  Read_Data, ALUresult_out, PC_out,
    output      [31:0]  PCimm_out
    );
    parameter RAM_size = 1024;
    reg [31:0]  mem [0:RAM_size-1];
    
    wire branch;
    
    // Branch: [4]
    or(branch, jalr_in, jal_in, Zero_in);
    and(PCSrc, Ctl_Branch_in, branch); // 추가 jal
    integer i;
    
    initial begin
        for (i=0; i<RAM_size; i=i+1) begin
            mem[i] = 32'b0;
        end
    end
    
    initial begin
        $readmemh("C:/Users/wmp91/Fibonacci_project/Fibonacci_project.srcs/sources_1/imports/src/darsocv.ram.mem",mem);
    end
    
    always @(posedge clk) begin
        if (Ctl_MemWrite_in)
            mem[ALUresult_in>>2] <= Write_Data;
        if (reset)
            Read_Data <= 0;
        else
            Read_Data <= mem[ALUresult_in>>2];
    end
    
    // Mem/WB reg
    always@ (posedge clk) begin
        Ctl_MemtoReg_out    <= (reset) ? 1'b0 : Ctl_MemtoReg_in;
        Ctl_RegWrite_out    <= (reset) ? 1'b0 : Ctl_RegWrite_in;
        jalr_out            <= (reset) ? 1'b0 : jalr_in;
        jal_out             <= (reset) ? 1'b0 : jal_in;
        PC_out              <= (reset) ? 1'b0 : PC_in;
        
        ALUresult_out       <= (reset) ? 1'b0 : ALUresult_in;
        Rd_out              <= (reset) ? 1'b0 : Rd_in;
    end
    assign PCimm_out = (jalr_in) ? ALUresult_in : PCimm_in;
    
endmodule
