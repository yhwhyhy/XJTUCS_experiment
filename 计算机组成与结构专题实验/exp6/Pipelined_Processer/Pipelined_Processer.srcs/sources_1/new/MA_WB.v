`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 10:30:33
// Design Name: 
// Module Name: MA_WB
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


module MA_WB(
	input clk,
	input RegWrite_in,
	input MemToReg_in,
	input[31:0] ReadData_in,
	input[31:0] ALUResult_in,
	input[4:0] WriteReg_in,
	output reg RegWrite_out,
	output reg MemToReg_out,
	output reg[31:0] ReadData_out,
	output reg[31:0] ALUResult_out,
	output reg[4:0] WriteReg_out
    );
	
	reg RegWrite;
	reg MemToReg;
	reg[31:0] ReadData;
	reg[31:0] ALUResult;
	reg[4:0] WriteReg;
	
	always @(posedge clk) begin
		RegWrite_out=RegWrite;
		MemToReg_out=MemToReg;
		ReadData_out=ReadData;
		ALUResult_out=ALUResult;
		WriteReg_out=WriteReg;
	end
	
	always @(negedge clk) begin
		RegWrite=RegWrite_in;
		MemToReg=MemToReg_in;
		ReadData=ReadData_in;
		ALUResult=ALUResult_in;
		WriteReg=WriteReg_in;
	end
endmodule
