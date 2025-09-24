`timescale 1ns / 1ps
`define DATA_WIDTH 32
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/03 16:22:38
// Design Name: 
// Module Name: RegFile
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


module RegFile(
clk,RegWrite,ReadReg1,ReadReg2,WriteReg,WriteData,ReadData1,ReadData2
    );
    parameter ADDR_SIZE=5;
    input clk,RegWrite;
    input [ADDR_SIZE-1:0] ReadReg1,ReadReg2,WriteReg;
    input [`DATA_WIDTH-1:0] WriteData;
    output reg[`DATA_WIDTH-1:0]ReadData1,ReadData2;
    
    reg [`DATA_WIDTH-1:0] rf[2**ADDR_SIZE-1:0];
    integer i;
    integer first=1;
    
    initial begin
        rf[0]=0; 
        for (i=1;i<2**ADDR_SIZE;i=i+1) rf[i]=first<<i;
    end
    
    always @(posedge clk) begin
        if (RegWrite) rf[WriteReg]<=WriteData;
    /* assign ReadData1=(ReadReg1!=0)? rf[ReadReg1]:0;
    assign ReadData2=(ReadReg2!=0)? rf[ReadReg2]:0;   */  
		if (ReadReg1!=0) ReadData1=rf[ReadReg1];
		else ReadData1=0;
		if (ReadReg2!=0) ReadData2=rf[ReadReg2];
		else ReadData2=0;
	end
endmodule
