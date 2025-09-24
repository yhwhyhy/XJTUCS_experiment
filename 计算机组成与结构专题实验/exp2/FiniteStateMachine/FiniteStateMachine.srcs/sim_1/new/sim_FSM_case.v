`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/20 10:49:26
// Design Name: 
// Module Name: sim_FSM_case
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


module sim_FSM_case(

    );
    reg clk,reset;
    wire y;
    
    initial begin
    fork
        clk=0;forever #10 clk=~clk;
        reset=0;#10 reset=1;#20 reset=0;;
    join
    end
    
    FSM_case test(clk,reset,y);
endmodule
