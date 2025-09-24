`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/07 20:18:13
// Design Name: 
// Module Name: sim_RAM1Kx16b
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


module sim_RAM1Kx16b(

    );
    reg [9:0] Addr;
    reg [15:0] Data_in;
    wire [15:0] Data_out;
    reg Rst,RE,WE,CS,CLK;
    integer i;
    
    initial begin
    CS=1;Rst=0;RE=1;WE=0;CLK=0;i=0;
    Data_in=16'hFF00;
    Addr=10'b1;
    forever #10 CLK=~CLK;
    end
    
    always @(*) begin
      for (i=0;i<10;i=i+1) #20 Addr=Addr<<1;
      Rst=1;
      #50 fork Rst=0;RE=1;join
      #50 fork RE=0;WE=1;join
      #50 fork RE=1;WE=0;join
      end
    

    
//    #200 {CS,Rst,RE,WE}=1100;
//    #50  {CS,Rst,RE,WE}=1010;
//    #50  {CS,Rst,RE,WE}=1001;
//    #50  {CS,Rst,RE,WE}=1010;

    

    
    
    RAM_1Kx16 test(Data_out,Addr,Rst,RE,WE,CS,CLK,Data_in);
endmodule
