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
    input CEP,CET,PE,CLK,CR;//�����ź�
    input [N-1:0] D;//��������
    output reg TC;//��λ���
    output reg [N-1:0] Q;//�������
    wire CE;
    assign CE=CEP&CET;//CE=1������������
    always @(posedge CLK,negedge CR)
        if (~CR) begin Q<=0;TC=0;end//�첽����
        else if (~PE) Q<=D;//PE=0��ͬ��װ����������
        else if (CE) begin//����
            if (Q==M-1) begin
                TC<=1;//��λ
                Q<=0;//��������
            end
            else Q<=Q+1;//����
        end
        else Q<=Q;//����        
        
endmodule
