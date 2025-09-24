`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 10:22:47
// Design Name: 
// Module Name: adder_8bit
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


module adder_8bit(
    Cin,A,B,C,Cout
    );
    input Cin;
    input [7:0] A,B;
    output wire Cout;
    output wire[7:0]C;
    
    wire [7:0] carry;
    
    adder_1bit add0(Cin,A[0],B[0],C[0],carry[0]);
    adder_1bit add1(carry[0],A[1],B[1],C[1],carry[1]);
    adder_1bit add2(carry[1],A[2],B[2],C[2],carry[2]);
    adder_1bit add3(carry[2],A[3],B[3],C[3],carry[3]);
    adder_1bit add4(carry[3],A[4],B[4],C[4],carry[4]);
    adder_1bit add5(carry[4],A[5],B[5],C[5],carry[5]);
    adder_1bit add6(carry[5],A[6],B[6],C[6],carry[6]);
    adder_1bit add7(carry[6],A[7],B[7],C[7],carry[7]);
    
    assign Cout=carry[7];
    
    
endmodule
