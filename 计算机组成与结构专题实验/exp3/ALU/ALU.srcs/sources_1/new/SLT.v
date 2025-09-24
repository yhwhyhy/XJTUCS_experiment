`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 08:28:53
// Design Name: 
// Module Name: SLT
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


module SLT(
    F,A,B,EN
    );//compare,if A<B,output 1;otherwise 0
    output reg[31:0] F;
    input [31:0]A,B;
    input EN;
    
    always @(A,B,EN) begin
        if (EN==0) F<=32'bz;
        else begin
            if (A<B) F<=1;
            else F<=0;
            end
    end
endmodule
