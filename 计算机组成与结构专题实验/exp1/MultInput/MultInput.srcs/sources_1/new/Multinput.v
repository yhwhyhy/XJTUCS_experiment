`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 15:13:17
// Design Name: 
// Module Name: Multinput
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


module Multinput(
    input a,input b, input c,input d,input e,
    output x
    );
    //reg x;
    //always @(*)
        //begin
           assign x = ~(a & ~b & c & (d|e));
        //end
endmodule
