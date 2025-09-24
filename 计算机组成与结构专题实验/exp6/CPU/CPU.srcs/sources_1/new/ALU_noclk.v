`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 23:07:06
// Design Name: 
// Module Name: ALU_noclk
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


module ALU_noclk(
	input [31:0]A,
	input [31:0]B,
	input [3:0]ALUControl,
	output reg[31:0] Result,
	output Zero
    );
	
	always @(*) begin
		case(ALUControl)
			4'b0100:Result<=A+B;//add
			4'b0101:Result<=A-B;//sub
			4'b0001:Result<=A|B;//or
			4'b0000:Result<=A&B;//and
			4'b0010:Result<=~(A|B);//xor
			default:Result<=32'bx;
		endcase
	end
	
	assign Zero=(Result==0)? 1:0;
endmodule
