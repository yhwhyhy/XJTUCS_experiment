`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 09:42:21
// Design Name: 
// Module Name: adder_1bit
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


module adder_1bit(
    Cin,A,B,C,Cout
    );
    input wire A,B,Cin;
    output wire C,Cout;
    
    assign C=A^B^Cin;
    assign Cout=(A&B)|(A&Cin)|(B&Cin);
endmodule
