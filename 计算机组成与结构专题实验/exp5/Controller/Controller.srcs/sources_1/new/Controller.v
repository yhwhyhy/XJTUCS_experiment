`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/24 11:03:20
// Design Name: 
// Module Name: Controller
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


module Controller(
Op,Funct,Zero,MemToReg,MemWrite,PCSrc,ALUSrc,RegDst,RegWrite,Jump,ALUControl
    );
	
	input [5:0] Op,Funct;
	input Zero;
	output MemToReg,MemWrite;
	output PCSrc,ALUSrc,RegDst,RegWrite,Jump;
	output [2:0] ALUControl;
	
	wire [1:0] ALUOp;
	wire Branch;
	
	MainDec MainDec_1(Op,MemToReg,MemWrite,Branch,ALUSrc,RegDst,RegWrite,Jump,ALUOp);
	
	ALUDec ALUDec_1(Funct,ALUOp,ALUControl);
	
	assign PCSrc=Branch&Zero;
endmodule
