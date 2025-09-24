`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 08:27:28
// Design Name: 
// Module Name: Decoder38
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


module Decoder38(
    OP,EN
    );
    input wire[2:0] OP;
    output reg[7:0] EN;
    
    always @(OP) begin
        case(OP)
            3'b000:EN<=8'b0000_0001;
            3'b001:EN<=8'b0000_0010;
            3'b010:EN<=8'b0000_0100;
            3'b011:EN<=8'b0000_1000;
            3'b100:EN<=8'b0001_0000;
            3'b101:EN<=8'b0010_0000;
            3'b110:EN<=8'b0100_0000;
            3'b111:EN<=8'b1000_0000;
        endcase
    end
endmodule
