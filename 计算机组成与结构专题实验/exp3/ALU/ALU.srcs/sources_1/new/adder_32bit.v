`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 10:40:40
// Design Name: 
// Module Name: adder_32bit
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


module adder_32bit(
    Cin,A,B,C,Cout
    );
     input Cin;
       input [31:0] A,B;
       output wire Cout;
       output wire[31:0]C;
       
       wire [3:0] carry;
       
       adder_8bit add0(Cin,A[7:0],B[7:0],C[7:0],carry[0]);
       adder_8bit add1(carry[0],A[15:8],B[15:8],C[15:8],carry[1]);
       adder_8bit add2(carry[1],A[23:16],B[23:16],C[23:16],carry[2]);
       adder_8bit add3(carry[2],A[31:24],B[31:24],C[31:24],carry[3]);
       
       assign Cout=carry[3];
endmodule
