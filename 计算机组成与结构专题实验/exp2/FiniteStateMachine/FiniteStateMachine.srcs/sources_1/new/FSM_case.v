`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 10:09:09
// Design Name: 
// Module Name: FSM_case
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


module FSM_case(
    input clk,input reset,output y
    );
    reg [2:0] state,nextstate;
    always @(posedge clk,posedge reset)
        if (reset) state=3'b001;
        else state=nextstate;
    always @(posedge clk)
        case (state)
            'b001:nextstate='b010;
            'b010:nextstate='b100;
            'b100:nextstate='b001;
            default:nextstate='b001;
        endcase        
        assign y=(state=='b001);
endmodule
