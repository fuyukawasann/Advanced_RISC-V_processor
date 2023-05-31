`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/16 00:57:10
// Design Name: 
// Module Name: RISCVpipeline
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


module RISCVpipeline(
    input key,
    output  [7:0] digit,
    output  [7:0] fnd,
    output  [15:0] LED,
    input   clk, reset
    );
    wire rst;
    assign rst = ~reset;
    wire stl_out;
    wire c;
    wire [2:0] LED_clk;
    wire [31:0] pc, ins;
    wire [0:7] ind_ctl;
    wire [0:7] exe_ctl;
    wire [0:7] mem_ctl;
    wire [0:7] wb_ctl;
    
    wire [31:0] ind_pc;
    wire [31:0] ind_data1, ind_data2, ind_imm, exe_data2, exe_addr, exe_result, mem_addr, mem_result, mem_data, wb_data;
    wire [4:0]  ind_rd, exe_rd, mem_rd, wb_rd;
    wire [6:0]  ind_funct7;
    wire [2:0]  ind_funct3;
    wire    ind_jal, ind_jalr, exe_zero, mem_PCSrc;
    wire    exe_jal, exe_jalr, mem_jal, mem_jalr;
    wire [31:0] exe_pc, mem_pc;
    wire [4:0]  ind_rs1, ind_rs2;
    wire [1:0]  fa_out, fb_out;
    
    wire [31:0] clk_address, clk_count;
    wire [31:0] data = (key) ? mem_data : clk_count;
    wire [31:0] RAM_address = (key) ? (clk_address<<2) : exe_result;
    assign LED = (key) ? 16'b1000_0000_0000_0000 : 16'b0;
    
    LED_channel LED0(
        .data(data),    .digit(digit),
        .LED_clk(LED_clk),  .fnd(fnd)
    );
    
    counter A0_counter(
        .key1(key),
        .mem_data(mem_data),
        .clk_address(clk_address),
        .indrs1(ind_rs1),
        .inddata1(ind_data1),
        .clk(clk),  .LED_clk(LED_clk),
        .rst(rst),  .clk_out(c),
        .pc_in(pc),
        .clk_count_out(clk_count)
    );

    
    InFetch A1_InFetch(
        .PCSrc(mem_PCSrc),
        .PCWrite(stl_out),
        .PCimm_in(mem_addr),
        .PC_out(pc),
        .instruction_out(ins),
        .reset(rst),
        .clk(c)
    );
    
    InDecode A3_InDecode(
        .Ctl_RegWrite_in(wb_ctl[5]),
        .stall(stl_out),
        .flush(mem_PCSrc),
        .WriteReg(wb_rd),
        .PC_in(pc),
        .instruction_in(ins),
        .WriteData(wb_data),
        .Rd_out(ind_rd),
        .Rs1_out(ind_rs1),
        .Rs2_out(ind_rs2),
        .PC_out(ind_pc),
        .ReadData1_out(ind_data1),
        .ReadData2_out(ind_data2),
        .Immediate_out(ind_imm),
        .funct7_out(ind_funct7),
        .funct3_out(ind_funct3),
        .jalr_out(ind_jalr),
        .jal_out(ind_jal),
        .Ctl_ALUSrc_out(ind_ctl[7]),
        .Ctl_MemtoReg_out(ind_ctl[6]),
        .Ctl_RegWrite_out(ind_ctl[5]),
        .Ctl_MemRead_out(ind_ctl[4]),
        .Ctl_MemWrite_out(ind_ctl[3]),
        .Ctl_Branch_out(ind_ctl[2]),
        .Ctl_ALUOpcode1_out(ind_ctl[1]),
        .Ctl_ALUOpcode0_out(ind_ctl[0]),
        .reset(rst),
        .clk(c)
    );
    
    Execution A4_Execution(
        .flush(mem_PCSrc), .jal_in(ind_jal), .jalr_in(ind_jalr),
        .jal_out(exe_jal), .jalr_out(exe_jalr),
        .funct7_in(ind_funct7), .funct3_in(ind_funct3), .Zero_out(exe_zero),
        .ALUresult_out(exe_result), .PCimm_out(exe_addr), .ReadData2_out(exe_data2), .PC_out(exe_pc),
        .Immediate_in(ind_imm), .ReadData1_in(ind_data1), .ReadData2_in(ind_data2), .PC_in(ind_pc),
        .mem_data(exe_result), .wb_data(wb_data),
        .Rd_in(ind_rd),                 .Rd_out(exe_rd),
        .Ctl_ALUSrc_in(ind_ctl[7]),
        .Ctl_MemtoReg_in(ind_ctl[6]),   .Ctl_MemtoReg_out(exe_ctl[6]),
        .Ctl_RegWrite_in(ind_ctl[5]),   .Ctl_RegWrite_out(exe_ctl[5]),
        .Ctl_MemRead_in(ind_ctl[4]),    .Ctl_MemRead_out(exe_ctl[4]),
        .Ctl_MemWrite_in(ind_ctl[3]),   .Ctl_MemWrite_out(exe_ctl[3]),
        .Ctl_Branch_in(ind_ctl[2]),     .Ctl_Branch_out(exe_ctl[2]),
        .Ctl_ALUOpcode1_in(ind_ctl[1]),
        .Ctl_ALUOpcode0_in(ind_ctl[0]),
        .ForwardA_in(fa_out), .ForwardB_in(fb_out),
        .clk(c),
        .reset(rst)
    );
    
    Memory A6_Memory(
        .Zero_in(exe_zero),
        .Write_Data(exe_data2),
        .ALUresult_in(RAM_address),
        .PCimm_in(exe_addr),
        .PCSrc(mem_PCSrc),
        .Read_Data(mem_data), .ALUresult_out(mem_result), .PCimm_out(mem_addr),
        .Rd_in(exe_rd),                 .Rd_out(mem_rd),
        .Ctl_MemtoReg_in(exe_ctl[6]),   .Ctl_MemtoReg_out(mem_ctl[6]),
        .Ctl_RegWrite_in(exe_ctl[5]),   .Ctl_RegWrite_out(mem_ctl[5]),
        .Ctl_MemRead_in(exe_ctl[4]),
        .Ctl_MemWrite_in(exe_ctl[3]),
        .Ctl_Branch_in(exe_ctl[2]),
        .jal_in(exe_jal), .jalr_in(exe_jalr), .PC_in(exe_pc), .PC_out(mem_pc),
        .jal_out(mem_jal), .jalr_out(mem_jalr),
        .reset(rst),
        .clk(c)
    );
    
    WB A7_WB(
        .Ctl_MemtoReg_in(mem_ctl[6]),
        .Ctl_RegWrite_in(mem_ctl[5]),       .Ctl_RegWrite_out(wb_ctl[5]),
        
        .jal_in(mem_jal), .jalr_in(mem_jalr), .PC_in(mem_pc),
        .ReadDatafromMem_in(mem_data), .WriteDatatoReg_out(wb_data),
        .ALUresult_in(mem_result),
        .Rd_in(mem_rd), .Rd_out(wb_rd)
    );
    
    Hazard_detection_unit A8_HDU(
        .exe_Ctl_MemRead_in(ind_ctl[4]),
        .Rd_in(ind_rd),
        .instruction_in(ins[24:15]),
        .stall_out(stl_out)
    );
    
    Forwarding_unit A9_FU(
        .mem_Ctl_RegWrite_in(exe_ctl[5]),
        .wb_Ctl_RegWrite_in(mem_ctl[5]),
        .Rs1_in(ind_rs1),
        .Rs2_in(ind_rs2),
        .mem_Rd_in(exe_rd),
        .wb_Rd_in(mem_rd),
        .ForwardA_out(fa_out),
        .ForwardB_out(fb_out)
    );
    
endmodule
