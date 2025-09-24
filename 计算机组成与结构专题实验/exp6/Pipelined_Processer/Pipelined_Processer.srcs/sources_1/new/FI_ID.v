`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 09:42:25
// Design Name: 
// Module Name: FI_ID
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


module FI_ID(
	input clk,
	input En,
	input CLR,
	input[31:0] Instr_in,
	input[31:0] PCPlus_in,
	output reg[31:0] Instr_out,
	output reg[31:0] PCPlus_out
    );
	
	reg[31:0] Instr;
	reg[31:0] PCPlus;
	
	always @(posedge clk) begin
		Instr_out=Instr;
		PCPlus_out=PCPlus;
	end
	always @(negedge clk) begin
		if (CLR)
		begin
		Instr=0;
		PCPlus=0;
		end
		if (En)
		begin
		Instr=Instr_in;
		PCPlus=PCPlus_in;
		end
	end
endmodule
