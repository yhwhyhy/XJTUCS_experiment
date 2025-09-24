`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 16:55:32
// Design Name: 
// Module Name: sim_decoder38
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


module sim_decoder38(

    );
    reg[3:1] I;
    wire [7:0] Y;
    integer i;
    
    initial begin
        I=3'b000;
        for (i=0;i<7;i=i+1) #10 I=I+1;
        end
        
     decoder38 decoder38_1(I,Y);
endmodule
