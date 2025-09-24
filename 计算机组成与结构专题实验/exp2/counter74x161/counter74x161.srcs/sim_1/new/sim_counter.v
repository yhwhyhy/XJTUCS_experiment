`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/20 10:24:10
// Design Name: 
// Module Name: sim_counter
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


module sim_counter(

    );
    reg CEP,CET,PE,CLK,CR;
    reg [7:0] D;
    wire TC;
    wire [7:0] Q;
    
    initial begin
        fork 
        D=32;
        CR=1;#20 CR=0;#30 CR=1;
        CLK=0;forever #10 CLK=~CLK;
        CEP=0;#30 CEP=1;#200 CEP=0;
        CET=0;#30 CET=1;#160 CET=0;
        PE=1;#50 PE=0;#60 PE=1;
        join
    end
    
    counter74x161 text(CEP,CET,PE,CLK,CR,D,TC,Q);
endmodule
