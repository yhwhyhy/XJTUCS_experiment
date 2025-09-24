`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/14 10:35:07
// Design Name: 
// Module Name: ALUControlUnit
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


module ALUControlUnit(
Funct,ALUOp,ALUControl
    );
	input [5:0] Funct;
	input [1:0] ALUOp;
	output reg [3:0] ALUControl;
	
	always @(*)
		case(ALUOp)
			2'b00:ALUControl<=4'b0100;//add
			2'b01:ALUControl<=4'b0101;//sub
			2'b11:ALUControl<=4'b0001;//or
			default:case(Funct)
				6'b100001:ALUControl<=4'b0100;//加法
				6'b100011:ALUControl<=4'b0101;//减法
				6'b000010:ALUControl<=4'b0000;//与
				6'b000011:ALUControl<=4'b0001;//or
				6'b000100:ALUControl<=4'b0010;//xor
				default: ALUControl<=4'bxxxx;
				endcase
		endcase		
endmodule
