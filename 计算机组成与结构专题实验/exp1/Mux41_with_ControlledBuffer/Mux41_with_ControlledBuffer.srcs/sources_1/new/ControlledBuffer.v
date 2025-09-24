`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 23:25:41
// Design Name: 
// Module Name: ControlledBuffer
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


module ControlledBuffer(
    E,A,Y
    );
    input E,A;
    output Y;
    wire E,A;
    reg Y;
    always @(*) 
    begin
        if (E==0) Y=1'bz;
        else Y=A;
    end  
endmodule
