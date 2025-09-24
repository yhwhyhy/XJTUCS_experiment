`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 15:29:12
// Design Name: 
// Module Name: sim_MultInput
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


module sim_MultInput(

    );
    reg a,b,c,d,e;
    wire x;
    initial begin
        a=0;b=0;c=0;d=0;e=0;
            fork
                repeat(12) #1 a=~a;
                repeat(6) #2 b=~b;
                repeat(4) #3 c=~c;
                repeat(3) #4 d=~d;
                repeat(2) #6 e=~e;
             join
        end
        
        Multinput M(a,b,c,d,e,x);
endmodule
