`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 23:06:08
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
ReadData,Address,MemRead,MemWrite,WriteData
    );
	parameter Addr_Width=12;
    parameter Data_Width=32;
    output reg [Data_Width-1:0] ReadData;
    input [Addr_Width-1:0] Address;
    input MemRead;
    input MemWrite;
    input [Data_Width-1:0] WriteData;
	
	integer i;
	reg [Data_Width-1:0] RAM[2**Addr_Width-1:0];
	initial begin
		for (i=0;i<2**Addr_Width;i=i+1) RAM[i]=i;
	end
	
	always @(*) begin
		if (MemRead) ReadData=RAM[Address];
		if (MemWrite) RAM[Address]=WriteData;
	end
endmodule
