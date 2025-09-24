`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/09 17:02:40
// Design Name: 
// Module Name: sim_RAM1Kx16_io
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


module sim_RAM1Kx16_io(

    );
    reg [9:0] Addr;
    reg Rst,R_W,CS,CLK;
    wire [15:0] Data;
    integer i;
    
    initial begin
    CS=1;Rst=0;R_W=1;CLK=0;i=0;
    Addr=10'b1;
    forever #10 CLK=~CLK;
    end
    
    initial begin
    for (i=0;i<10;i=i+1) #20 Addr=Addr<<1;
    Rst=1;
    #50 Rst=0;R_W=1;
    #50 R_W=0;
    #50 R_W=1;    
    end
    
    assign Data=(R_W)? 16'bz:16'hFFFF;
    
    RAM_1Kx16_inout test(Data,Addr,Rst,R_W,CS,CLK);
endmodule
