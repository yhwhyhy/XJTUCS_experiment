`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/15 09:11:38
// Design Name: 
// Module Name: sim_MultiCycleCPU
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


module sim_MultiCycleCPU(

    );
	reg clk,reset;
	initial begin
		reset=0;
		clk=0;
		forever #50 clk=~clk;
	end
	
	MultiCycleCPU test(.clk(clk),.reset(reset));
endmodule
