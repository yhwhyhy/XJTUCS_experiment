`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/20 08:54:36
// Design Name: 
// Module Name: sim_D_latch
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


module sim_D_latch(

    );
    reg D,EN,RST;
    wire Q,QN;
    initial begin
        fork
            D=1;EN=0;RST=0;
            #10 RST=~RST;
            #50 RST=~RST;
            forever #20 D=~D;
            forever #30 EN=~EN;
        join
    end
    
    
    D_latch test(Q,QN,D,EN,RST);
endmodule
