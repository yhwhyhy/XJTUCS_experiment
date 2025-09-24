`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 23:49:16
// Design Name: 
// Module Name: sim_ControlledBuffer
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


module sim_ControlledBuffer(

    );
    reg A,E;;
    wire Y;
    initial 
        begin
            fork
                E=0;A=0;
                #30 E=~E;
                repeat(10) #10 A=~A;
            join
        end
     ControlledBuffer TripleStateGate1(.A(A),.E(E),.Y(Y));       
endmodule
