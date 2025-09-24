`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/03 15:20:15
// Design Name: 
// Module Name: RAM_4Kx32
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


module DataMemory_4Kx32(
ReadData,Address,Rst,MemRead,MemWrite,clk,WriteData
    );
    parameter Addr_Width=12;
    parameter Data_Width=32;
    output [Data_Width-1:0] ReadData;
    input [Addr_Width-1:0] Address;
    input Rst;
    input MemRead;
    input MemWrite;
    input clk;
    input [Data_Width-1:0] WriteData;
    
    wire [3:0] CS_i;
    Decoder24 Decoder24_1(CS_i,Address[Addr_Width-1:Addr_Width-2]);
    
    RAM_1Kx16 CS0_H_16bit(ReadData[Data_Width-1:Data_Width/2],Address[Addr_Width-3:0],Rst,MemRead,MemWrite,CS_i[0],clk,WriteData[Data_Width-1:Data_Width/2]),
              CS0_L_16bit(ReadData[Data_Width/2-1:0],Address[Addr_Width-3:0],Rst,MemRead,MemWrite,CS_i[0],clk,WriteData[Data_Width/2-1:0]);
    RAM_1Kx16 CS1_H_16bit(ReadData[Data_Width-1:Data_Width/2],Address[Addr_Width-3:0],Rst,MemRead,MemWrite,CS_i[1],clk,WriteData[Data_Width-1:Data_Width/2]),
              CS1_L_16bit(ReadData[Data_Width/2-1:0],Address[Addr_Width-3:0],Rst,MemRead,MemWrite,CS_i[1],clk,WriteData[Data_Width/2-1:0]);
    RAM_1Kx16 CS2_H_16bit(ReadData[Data_Width-1:Data_Width/2],Address[Addr_Width-3:0],Rst,MemRead,MemWrite,CS_i[2],clk,WriteData[Data_Width-1:Data_Width/2]),
              CS2_L_16bit(ReadData[Data_Width/2-1:0],Address[Addr_Width-3:0],Rst,MemRead,MemWrite,CS_i[2],clk,WriteData[Data_Width/2-1:0]);          
    RAM_1Kx16 CS3_H_16bit(ReadData[Data_Width-1:Data_Width/2],Address[Addr_Width-3:0],Rst,MemRead,MemWrite,CS_i[3],clk,WriteData[Data_Width-1:Data_Width/2]),
              CS3_L_16bit(ReadData[Data_Width/2-1:0],Address[Addr_Width-3:0],Rst,MemRead,MemWrite,CS_i[3],clk,WriteData[Data_Width/2-1:0]);                                  
              
endmodule
