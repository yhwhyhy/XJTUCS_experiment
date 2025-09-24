`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/20 09:58:10
// Design Name: 
// Module Name: sim_shift_register
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


module sim_shift_register(

    );
    reg S1,S0,Dsl,Dsr,CLK,CR;
    reg[3:0] D;
    wire[3:0] Q;
    
    initial begin
        fork
            D=4'b0101;Dsl=0;Dsr=1;S1=1;S0=1;CLK=0;CR=0;
            #10 CR=1;
            #30 CR=0;
            forever #10 CLK=~CLK;
            forever #30 S0=~S0;
            forever #60 S1=~S1;
        join
    end
    
    shift_register test(S1,S0,D,Dsl,Dsr,Q,CLK,CR);
endmodule

