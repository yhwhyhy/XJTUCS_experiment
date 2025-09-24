`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 22:29:46
// Design Name: 
// Module Name: sim_IMem
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


module sim_IMem(

    );
    reg [5:0] A;
    wire [7:0] RD;
    integer i;
    
    initial begin
    A=6'b000001;
    for (i=0;i<64;i=i+1) #10 A=A+1;
    end
    
    IMem test(A,RD);
endmodule
