`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 09:54:32
// Design Name: 
// Module Name: counter74x161
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


module counter74x161(
    CEP,CET,PE,CLK,CR,D,TC,Q
    );
    
    parameter N=8;
    parameter M=34;
    input CEP,CET,PE,CLK,CR;//控制信号
    input [N-1:0] D;//并行输入
    output reg TC;//进位输出
    output reg [N-1:0] Q;//数据输出
    wire CE;
    assign CE=CEP&CET;//CE=1，计数器计数
    always @(posedge CLK,negedge CR)
        if (~CR) begin Q<=0;TC=0;end//异步清零
        else if (~PE) Q<=D;//PE=0，同步装入输入数据
        else if (CE) begin//计数
            if (Q==M-1) begin
                TC<=1;//进位
                Q<=0;//计数归零
            end
            else Q<=Q+1;//计数
        end
        else Q<=Q;//保持        
        
endmodule
