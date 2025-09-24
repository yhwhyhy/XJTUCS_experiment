`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/20 10:53:42
// Design Name: 
// Module Name: HazardControlUnit
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


module HazardControlUnit(
	input RegWriteM,
	input RegWriteW,
	input RegWriteE,
	input[4:0] WriteRegM,
	input[4:0] WriteRegW,
	input[4:0] WriteRegE,
	input BranchD,
	input[4:0] RsE,
	input[4:0] RtE,
	output reg[1:0] ForwardAE,
	output reg[1:0] ForwardBE,
	input MemToRegE,
	input MemToRegM,
	input[4:0] RsD,
	input[4:0] RtD,
	output reg ForwardAD,ForwardBD,
	output reg StallF,StallD,FlushE
    );
	
	reg lwstall;
	reg branhstall;
	always @(*) begin	
		if ((RsE!=0)&(RsE==WriteRegM)& RegWriteM) ForwardAE=10;//源操作数是上条指令计算结果
		else if ((RsE!=0)&(RsE==WriteRegW)& RegWriteW) ForwardAE=01;//源操作数是上上条指令计算结果
		else ForwardAE=0;
	end
	
	always @(*) begin	
		if ((RtE!=0)&(RtE==WriteRegM)& RegWriteM) ForwardBE=10;//源操作数是上条指令计算结果
		else if ((RtE!=0)&(RtE==WriteRegW)& RegWriteW) ForwardBE=01;//源操作数是上上条指令计算结果
		else ForwardBE=00;
	end
	always @(*) begin
		ForwardAD=(RsD!=0) & (RsD==WriteRegM) & RegWriteM;
		ForwardBD=(RtD!=0) & (RtD==WriteRegM) & RegWriteM;
	end
	always @(*) begin
		lwstall=((RsD==RsE) | (RtD==RtE)) & MemToRegE;
		branhstall=(BranchD & RegWriteE & (WriteRegE==RsD | WriteRegE==RtD)) |
					(BranchD & MemToRegM & (WriteRegM==RsD | WriteRegM==RtD));
		StallD=lwstall | branhstall;
		StallF=lwstall | branhstall;
		FlushE=lwstall | branhstall;
	end
endmodule
