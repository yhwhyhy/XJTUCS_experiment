`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 09:16:12
// Design Name: 
// Module Name: sim_ALU_8
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


module sim_ALU_8(

    );
    reg [3:0]OP;
    reg [31:0]A,B;
    wire C;
    wire [31:0] F;
    integer i;
    
    initial begin
        A=2;B=32'hFFFF_FFFE;OP=4'b0000;
        for (i=0;i<7;i=i+1) #25 OP=OP+1;
    end
    
    ALU_8 test(F,C,A,B,OP);
endmodule
