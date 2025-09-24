`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 16:18:04
// Design Name: 
// Module Name: RAM_1Kx16_inout
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


module RAM_1Kx16_inout(
Data,Addr,Rst,R_W,CS,CLK
    );
    parameter Addr_Width=10;
    parameter Data_Width=16;
    parameter Size=2**Addr_Width;
    inout [Data_Width-1:0] Data;
    input [Addr_Width-1:0] Addr;
    input Rst;
    input R_W;//1 for read,0 for write
    input CS,CLK;
    
    integer i;
    reg [Data_Width-1:0] RAM[Size-1:0];
    reg [Data_Width-1:0] Data_i;
    
    initial begin
        for (i=0;i<Size;i=i+1) RAM[i]=i;
    end
    
    assign Data=(R_W)? Data_i:16'bz;
    
    
    always @(CLK) begin
        casex({CS,Rst,R_W})
            3'bx1x:for (i=0;i<Size;i=i+1) RAM[i]=0;
            3'b101:Data_i<=RAM[Addr];
            3'b100:RAM[Addr]<=Data;
            default:Data_i=16'bz;
        endcase
    end
endmodule
