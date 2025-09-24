`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/03 15:32:05
// Design Name: 
// Module Name: Decoder24
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


module Decoder24(
Y,I
    );
    output reg [3:0]Y;
    input [1:0]I;
    
    always @(*) begin
        case(I)
            2'b00:Y=4'b0001;
            2'b01:Y=4'b0010;
            2'b10:Y=4'b0100;
            2'b11:Y=4'b1000;
        endcase
    end
endmodule
