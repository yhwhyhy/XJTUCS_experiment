`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/14 10:05:58
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
	input En,
	input clk,
	input [31:0] PC_in,
	output reg[31:0] PC_out
	);
	
	always @(posedge clk) begin
		if (En)  PC_out<=PC_in;
	end
endmodule
