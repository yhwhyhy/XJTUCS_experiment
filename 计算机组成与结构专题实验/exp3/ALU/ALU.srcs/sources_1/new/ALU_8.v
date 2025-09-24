`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 08:44:07
// Design Name: 
// Module Name: ALU_8
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


module ALU_8(
    F,CF,A,B,OP
    );
    parameter size=32;
    output reg [size-1:0]F;//output result
    output CF;//ouput carry flag
    input [size-1:0] A,B;
    input [3:0]OP;//select function
    
    parameter ALU_AND=4'b0000;
    parameter ALU_OR=4'b0001;
    parameter ALU_XOR=4'b0010;
    parameter ALU_NOR=4'b0011;
    parameter ALU_ADD=4'b0100;
    parameter ALU_SUB=4'b0101;
    parameter ALU_SLT=4'b0110;//compare,if A<B,output1;otherwise 0
    parameter ALU_SLL=4'b0111;//B shift left  A bits
    
    wire [7:0] EN;
    wire [size-1:0]Fw,Fa;
    
    assign Fa=A&B;
    
    always @(*) begin
        case(OP)
            ALU_AND:F<=Fa;
            ALU_OR:F<=A|B;
            ALU_XOR:F<=A^B;
            ALU_NOR:F<=~(A|B);
            default:F=Fw;
        endcase
    end
    
    Decoder38 decoder38_1(OP[2:0],EN);
    ADD add_1(Fw,CF,A,B,EN[4]);
    SUB sub_1(Fw,CF,A,B,EN[5]);
    SLT slt_1(Fw,A,B,EN[6]);
    SLL sll_1(Fw,A,B,EN[7]);
endmodule
