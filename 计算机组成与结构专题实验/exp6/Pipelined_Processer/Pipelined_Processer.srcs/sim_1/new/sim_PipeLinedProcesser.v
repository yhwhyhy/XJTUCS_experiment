`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/21 00:25:26
// Design Name: 
// Module Name: sim_PipeLinedProcesser
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


module sim_PipeLinedProcesser(

    );
	reg clk;
	initial begin
	clk=0;
	forever #50 clk=~clk;
	end
	
	Pipelined_Processer test(clk);
endmodule
