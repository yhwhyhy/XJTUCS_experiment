`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/20 09:17:08
// Design Name: 
// Module Name: sim_D_ff
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


module sim_D_ff(

    );
    reg D,EN,RST,CLK;
    wire Q,QN;
    
    initial begin
        fork
            D=1;CLK=0;RST=0;EN=0;
            forever #30 CLK=~CLK;
            forever #50 D=~D;
            #40 EN=1;
            #20 RST=1;
            #60 RST=0;
            #500 EN=0;
        join
    end
    
    D_ff test(Q,QN,D,EN,RST,CLK);
endmodule
    
