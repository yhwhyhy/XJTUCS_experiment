`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 15:41:19
// Design Name: 
// Module Name: mux41
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


module mux41(
    input D0, input D1, input D2, input D3,
    input [1:0] S,
    output Y
    );
    reg temp;
    always @(*)
        begin 
            case (S)
            2'b00:temp=D0;
            2'b01:temp=D1;
            2'b10:temp=D2;
            2'b11:temp=D3;
            default:temp=D0;
            endcase
        end
        assign Y=temp;
endmodule
