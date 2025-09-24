`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 09:54:10
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
	input clk,
	input CLR,
	input RegWrite_in,
	input MemToReg_in,
	input MemWrite_in,
	input MemRead_in,
	input[3:0] ALUControl_in,
	input ALUSrc_in,
	input RegDst_in,
	input[31:0] ReadData1_in,
	input[31:0] ReadData2_in,
	input[4:0] Rs_in,
	input[4:0] Rt_in,
	input[4:0] Rd_in,
	input[31:0] Imm_in,
	output reg RegWrite_out,
	output reg MemToReg_out,
	output reg MemRead_out,
	output reg MemWrite_out,
	output reg[3:0] ALUControl_out,
	output reg ALUSrc_out,
	output reg RegDst_out,
	output reg[31:0] ReadData1_out,
	output reg[31:0] ReadData2_out,
	output reg[4:0] Rs_out,
	output reg[4:0] Rt_out,
	output reg[4:0] Rd_out,
	output reg[31:0] Imm_out
    );
	
	reg RegWrite;
	 reg MemToReg;
	 reg MemWrite;
	 reg MemRead;
	 reg[3:0] ALUControl;
	 reg ALUSrc;
	 reg RegDst;
	 reg[31:0] ReadData1;
	 reg[31:0] ReadData2;
	 reg[4:0] Rs;
	 reg[4:0] Rt;
	 reg[4:0] Rd;
	 reg[31:0] Imm;
	
	always @(posedge clk) begin
		RegWrite_out=RegWrite;
		MemToReg_out=MemToReg;
		MemWrite_out=MemWrite;
		MemRead_out=MemRead;
		ALUControl_out=ALUControl;
		ALUSrc_out=ALUSrc;
		RegDst_out=RegDst;
		ReadData1_out=ReadData1;
		ReadData2_out=ReadData2;
		Rs_out=Rs;
		Rt_out=Rt;
		Rd_out=Rd;
		Imm_out=Imm;
	end
	always @(negedge clk) begin
		if (CLR) begin
		RegWrite=0;
		MemToReg=0;
		MemWrite=0;
		MemRead=0;
		ALUControl=0;
		ALUSrc=0;
		RegDst=0;
		ReadData1=0;
		ReadData2=0;
		Rs=0;
		Rt=0;
		Rd=0;
		Imm=0;
		end
		else begin
		#25
		RegWrite=RegWrite_in;
		MemToReg=MemToReg_in;
		MemWrite=MemWrite_in;
		MemRead=MemRead_in;
		ALUControl=ALUControl_in;
		ALUSrc=ALUSrc_in;
		RegDst=RegDst_in;
		ReadData1=ReadData1_in;
		ReadData2=ReadData2_in;
		Rs=Rs_in;
		Rt=Rt_in;
		Rd=Rd_in;
		Imm=Imm_in;
		end
	end
	
endmodule
