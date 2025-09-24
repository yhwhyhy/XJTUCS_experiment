`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 08:27:53
// Design Name: 
// Module Name: ADD
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


module ADD(
    F,C,A,B,EN
    );
    output reg [31:0]F;
    output reg C;
    input [31:0]A,B;
    input EN;
    
    wire[31:0] Ftmp;
    wire Ctmp;
    adder_32bit add1(0,A,B,Ftmp,Ctmp);
    
    always @(A,B,EN) begin
        if (EN==0) begin C=1'bz;F=32'bz;end
        //else {C,F}=A+B;
        else begin C=Ctmp;F=Ftmp;end
    end
endmodule
