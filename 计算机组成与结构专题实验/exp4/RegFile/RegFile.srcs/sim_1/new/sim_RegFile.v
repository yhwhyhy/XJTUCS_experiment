`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 23:13:35
// Design Name: 
// Module Name: sim_RegFile
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


module sim_RegFile(

    );
    reg CLK,WE3;
    reg [31:0] WD3;
    reg [4:0]  WA3,RA1,RA2;
    wire [31:0] RD1,RD2;
    
    initial begin
        CLK=0;WE3=0;RA1=0;RA2=0;WA3=5'b01101;WD3=32'hFEDC_BA98;
        forever #10 CLK=~CLK;
    end
    
    initial begin
        #50 RA1=5'b11011;RA2=5'b00010;
        #50 WE3=1;
        #50 WE3=0;RA1=WA3;
    end
    
    RegFile test(CLK,WE3,RA1,RA2,WA3,WD3,RD1,RD2);
endmodule
