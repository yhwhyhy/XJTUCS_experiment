`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 16:08:38
// Design Name: 
// Module Name: pre_encoder83_case
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


module pre_encoder83_case(
    I,Y
    );
    input I;
    output Y;
    wire [7:0] I;
    reg [3:1] Y;
    
    always @(I) begin 
                casex (I)
                    8'b0000_0001:Y=3'b000;
                    8'b0000_001X:Y=3'b001;
                    8'b0000_01XX:Y=3'b010;
                    8'b0000_1XXX:Y=3'b011;
                    8'b0001_XXXX:Y=3'b100;
                    8'b001X_XXXX:Y=3'b101;
                    8'b01XX_XXXX:Y=3'b110;
                    8'b1XXX_XXXX:Y=3'b111;
                    default: Y=3'b000;
                 endcase
                 end
endmodule
