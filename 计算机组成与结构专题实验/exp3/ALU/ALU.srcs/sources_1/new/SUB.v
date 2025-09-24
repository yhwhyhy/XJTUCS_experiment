`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 08:28:12
// Design Name: 
// Module Name: SUB
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


module SUB(
    F,C,A,B,EN
    );
    output reg[31:0]F;
    output reg C;
    input [31:0] A,B;
    input EN;
    
    always @(A,B,EN) begin
        if (EN==0) begin C=1'bz;F=32'bz;end
        else {C,F}=A-B;
    end
endmodule
