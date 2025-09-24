`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/08 19:44:56
// Design Name: 
// Module Name: sim_4Kx32
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


module sim_4Kx32(

    );
    reg [11:0] Addr;
    reg [31:0] Data_in;
    wire [31:0] Data_out;
    reg Rst,RE,WE,CLK;    

    initial begin
    Rst=0;RE=1;WE=0;CLK=0;
    Data_in=32'hFF00_ABCD;
    Addr=12'b1;
    forever #10 CLK=~CLK;
    end
    
    initial begin
      #50 Addr=12'b0010_1110_0101;
      #50 Addr=12'b0110_0011_0000;  
      Rst=1;
      #50 fork Rst=0;RE=1;join
      #50 fork RE=0;WE=1;join
      #50 fork RE=1;WE=0;join
      end
      
      RAM_4Kx32 test(Data_out,Addr,Rst,RE,WE,CLK,Data_in);    
endmodule
