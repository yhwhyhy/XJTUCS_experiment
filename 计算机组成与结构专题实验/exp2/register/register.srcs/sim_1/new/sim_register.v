`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/20 09:44:32
// Design Name: 
// Module Name: sim_register
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


module sim_register(

    );
    wire [7:0] Q;
    reg [7:0] D;
    reg CLK,OE;
    integer i;
    
    initial begin
    fork
        OE=1;CLK=0;D=8'b0000_0001;
        #20 OE=0;
        forever #10 CLK=~CLK;
        for (i=0;i<7;i=i+1) #10 D=D<<1;
    join    
    end
    
    register test(Q,D,OE,CLK);
endmodule
