`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 16:47:35
// Design Name: 
// Module Name: decoder38
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


module decoder38(
    I,Y
    );
    input I;
    output Y;
    wire [3:1] I;
    reg [7:0] Y;
    
    always @(I) begin
        case(I)
            3'b000:Y=8'b1111_1110;
            3'b001:Y=8'b1111_1101;
            3'b010:Y=8'b1111_1011;
            3'b011:Y=8'b1111_0111;
            3'b100:Y=8'b1110_1111;
            3'b101:Y=8'b1101_1111;
            3'b110:Y=8'b1011_1111;
            3'b111:Y=8'b0111_1111;
            default:Y=8'b0000_0000;
         endcase
     end
endmodule
