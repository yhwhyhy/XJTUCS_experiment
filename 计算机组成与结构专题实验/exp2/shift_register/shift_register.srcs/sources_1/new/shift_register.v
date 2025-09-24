`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 09:35:23
// Design Name: 
// Module Name: shift_register
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


module shift_register(
    S1,S0,D,Dsl,Dsr,Q,CLK,CR
    );
    
    parameter N=4;
    input S1,S0;//control input
    input Dsl,Dsr;//��������
    input CLK,CR;//ʱ�ӡ��첽����
    input [N-1:0] D;//���������
    output reg [N-1:0] Q;
    
    always @(posedge CLK or posedge CR)
        if (CR)
            Q<=0;
        else
            case ({S1,S0})
                2'b00:Q<=Q;
                2'b01:Q<={Dsr,Q[N-1:1]};//����
                2'b10:Q<={Q[N-2:0],Dsl};
                2'b11:Q<=D;
            endcase        
    
    
endmodule
