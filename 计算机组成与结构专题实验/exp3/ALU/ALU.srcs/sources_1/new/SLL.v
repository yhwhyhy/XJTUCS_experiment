`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 08:29:10
// Design Name: 
// Module Name: SLL
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


module SLL(
    F,A,B,EN
    );//逻辑左移，B左移A指定位数
    parameter N=32;
    output reg[N-1:0] F;
    input [N-1:0] A,B;
    input EN;
    
    always@(A,B,EN) begin
    if (EN==1) F<=B<<A;
    else F<=32'bz;
    end
endmodule
    
