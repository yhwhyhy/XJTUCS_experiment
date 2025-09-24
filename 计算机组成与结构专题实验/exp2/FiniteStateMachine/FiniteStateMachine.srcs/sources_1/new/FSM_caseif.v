`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 10:18:26
// Design Name: 
// Module Name: FSM_caseif
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


module FSM_caseif(
    input clk,input reset,input a,output y
    );
    reg [1:0] state,nextstate;
    
    always @(posedge clk,posedge reset)
        if (reset) state=2'b00;
        else state=nextstate;
    always @ (posedge clk)
        case(state)
            'b00:if(a) nextstate='b01;
                else nextstate='b00;    
            'b01:if(a) nextstate='b11;
                else nextstate='b10;
            'b10:if(a) nextstate='b01;
                else nextstate='b00;
            'b11:if(a) nextstate='b11;
                else nextstate='b10;    
            default:nextstate='b00;
        endcase
        assign y=(state=='b01);                  
endmodule
