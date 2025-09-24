`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 10:20:28
// Design Name: 
// Module Name: EX_MA
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


module EX_MA(
	input clk,
	input RegWrite_in,
	input MemToReg_in,
	input MemWrite_in,
	input MemRead_in,
	input[31:0] ALUResult_in,
	input[31:0] WriteData_in,
	input[4:0] WriteReg_in,
	output reg RegWrite_out,
	output reg MemToReg_out,
	output reg MemWrite_out,
	output reg MemRead_out,
	output reg[31:0] ALUResult_out,
	output reg[31:0] WriteData_out,
	output reg[4:0] WriteReg_out
    );
	
	  reg RegWrite;
	  reg MemToReg;
	  reg MemWrite;
	  reg MemRead;
	  reg[31:0] ALUResult;
	  reg[31:0] WriteData;
	  reg[4:0] WriteReg;
	  
	always @(posedge clk) begin
		RegWrite_out=RegWrite;
		MemToReg_out=MemToReg;
		MemWrite_out=MemWrite;
		MemRead_out=MemRead;
		ALUResult_out=ALUResult;
		WriteData_out=WriteData;
		WriteReg_out=WriteReg;
	end
	
	always @(negedge clk) begin
		RegWrite=RegWrite_in;
		MemToReg=MemToReg_in;
		MemWrite=MemWrite_in;
		MemRead=MemRead_in;
		ALUResult=ALUResult_in;
		WriteData=WriteData_in;
		WriteReg=WriteReg_in;
	end
endmodule
