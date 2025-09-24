`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 09:53:15
// Design Name: 
// Module Name: sim_adder_1bit
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


module sim_adder_1bit(

    );
    reg A,B,Cin;
    wire C,Cout;
    
    initial begin
        A=1;B=1;Cin=1;
        #10 A=0;
        #20 B=0;
        #30 Cin=0;
    end
    
    adder_1bit test(Cin,A,B,C,Cout);    
endmodule
