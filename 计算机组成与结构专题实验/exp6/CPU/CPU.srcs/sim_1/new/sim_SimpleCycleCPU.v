`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 18:31:13
// Design Name: 
// Module Name: sim_SimpleCycleCPU
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


module sim_SimpleCycleCPU(

    );
	reg clk,reset;
	initial begin
		reset=0;
		clk=0;
		forever #50 clk=~clk;
	end
	
	SimpleCycleCPU test(.clk(clk),.reset(reset));
endmodule

