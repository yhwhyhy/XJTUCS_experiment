`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/24 11:01:57
// Design Name: 
// Module Name: ALUDec
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


module ALUDec(
Funct,ALUOp,ALUControl
    );
	
	input [5:0] Funct;
	input [1:0] ALUOp;
	output reg [2:0] ALUControl;
	
	always @(*)
		case(ALUOp)
			2'b00:ALUControl<=3'b010;
			2'b01:ALUControl<=3'b110;
			default:case(Funct)
				6'b100000:ALUControl<=3'b010;
				6'b100010:ALUControl<=3'b110;
				6'b100100:ALUControl<=3'b000;
				6'b100101:ALUControl<=3'b001;
				6'b101010:ALUControl<=3'b111;
				default: ALUControl<=3'bxxx;
				endcase
		endcase		
endmodule
