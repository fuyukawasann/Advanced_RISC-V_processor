`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/01 16:54:41
// Design Name: 
// Module Name: InDecode
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


module InDecode(
    input clk, reset,
    // data hazard
    input stall,
    // control hazard
    input flush,
    // forwarding
    input Ctl_RegWrite_in,
    // control signal
    output reg Ctl_ALUSrc_out, Ctl_MemtoReg_out, Ctl_RegWrite_out, Ctl_MemRead_out, Ctl_MemWrite_out, Ctl_Branch_out, Ctl_ALUOpcode1_out, Ctl_ALUOpcode0_out,
    //
    input   [4:0] WriteReg,
    input   [31:0] PC_in, instruction_in, WriteData,
    
    output reg [4:0] Rd_out, Rs1_out, Rs2_out,
    output reg [31:0] PC_out, ReadData1_out, ReadData2_out, Immediate_out,
    output reg [6:0] funct7_out,
    output reg [2:0] funct3_out,
    output reg      jalr_out, jal_out
    );
    wire    [6:0] opcode = instruction_in[6:0];
    wire    [6:0] funct7 = instruction_in[31:25];
    wire    [2:0] funct3 = instruction_in[14:12];
    wire    [4:0] Rd = instruction_in[11:7];
    wire    [4:0] Rs1 = instruction_in[19:15];
    wire    [4:0] Rs2 = instruction_in[24:20];
    wire    jalr = (opcode == 7'b1100111) ? 1:0;
    wire    jal = (opcode == 7'b1101111) ? 1:0;
    
    wire    [0:7] Ctl_out;
    
    // control Unit RISC-V 
    Control_unit B0 (.opcode(opcode), .Ctl_out(Ctl_out), .reset(reset));    // ¸í½ÃÀû
    reg [7:0] Control;
    
    always @(*) begin
        Control = (flush) ? 1'b0 : (stall) ? 1'b0 : Ctl_out;
    end
    
    // Register
    parameter reg_size = 32;
    reg [31:0] Reg[0:reg_size-1];
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for(i=0;i<32;i=i+1) begin
                Reg[i] <= 32'b0;
            end
            Reg[0] <= 0;
            Reg[1] <= 2;
            Reg[2] <= 3;
            Reg[3] <= 4;
            Reg[4] <= 5;
            Reg[5] <= 6;
            Reg[6] <= 7;
        end
        else if (Ctl_RegWrite_in && WriteReg != 0)
            Reg[WriteReg] <= WriteData;
    end
    
    // Immediate generator - sign extention RISC-V
    reg [31:0] Immediate;
    always @(*) begin
        case(opcode)
            7'b00000_11 : Immediate = $signed(instruction_in[31:20]);   // I-type
            7'b00100_11 : Immediate = $signed(instruction_in[31:20]);   // I-type
            7'b11001_11 : Immediate = $signed(instruction_in[31:20]);   // I-type jalr
            7'b01000_11 : Immediate = $signed({instruction_in[31:25], instruction_in[11:7]});   // S-type
            7'b11000_11 : Immediate = $signed({instruction_in[31], instruction_in[7], instruction_in[30:25], instruction_in[11:8]});  // SB-type
            7'b11011_11 : Immediate = $signed({instruction_in[31], instruction_in[19:12], instruction_in[20], instruction_in[30:21]}); // jal
            
            default:    Immediate = 32'b0;
        endcase
    end
    
    // ID/EX reg
    always @(posedge clk) begin
        // RISC-V
        PC_out              <= (reset) ? 0 : PC_in;
        funct7_out          <= (reset) ? 0 : funct7;
        funct3_out          <= (reset) ? 0 : funct3;
        Rd_out              <= (reset) ? 0 : Rd;
        Rs1_out             <= (reset) ? 0 : Rs1;
        Rs2_out             <= (reset) ? 0 : Rs2;
        ReadData1_out       <= (reset) ? 0 : (Ctl_RegWrite_in && WriteReg==Rs1) ? WriteData : Reg[Rs1];
        ReadData2_out       <= (reset) ? 0 : (Ctl_RegWrite_in && WriteReg==Rs2) ? WriteData : Reg[Rs2];
        jalr_out            <= (reset) ? 0 : jalr;
        jal_out             <= (reset) ? 0 : jal;
        Ctl_ALUSrc_out      <= (reset) ? 0 : Control[7];
        Ctl_MemtoReg_out    <= (reset) ? 0 : Control[6];
        Ctl_RegWrite_out    <= (reset) ? 0 : Control[5];
        Ctl_MemRead_out     <= (reset) ? 0 : Control[4];
        Ctl_MemWrite_out    <= (reset) ? 0 : Control[3];
        Ctl_Branch_out       <= (reset) ? 0 : Control[2];
        Ctl_ALUOpcode1_out  <= (reset) ? 0 : Control[1];
        Ctl_ALUOpcode0_out  <= (reset) ? 0 : Control[0];
        Immediate_out       <= (reset) ? 0 : Immediate;
    end
endmodule
