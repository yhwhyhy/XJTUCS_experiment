`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 00:01:33
// Design Name: 
// Module Name: register
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


module register(
    Q,D,OE,CLK
    );
    parameter N=8;
    output reg[N-1:0] Q;
    input [N:1] D;
    input OE,CLK;
    
    always @(posedge CLK or posedge OE)
        if (OE) Q<=8'bzzzz_zzzz;
        else Q<=D;
endmodule
