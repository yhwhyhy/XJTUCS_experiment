`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/17 23:36:46
// Design Name: 
// Module Name: D_latch
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


module D_latch(
    Q,QN,D,EN,RST
    );
    input D,EN,RST;
    output reg Q,QN;
    
    always @(EN,RST,D) begin
        if (RST) begin
            Q=0;
            QN=1;
        end
        else if (EN) begin
            Q<=D;
            QN<=~D;
            end
        end        
endmodule
