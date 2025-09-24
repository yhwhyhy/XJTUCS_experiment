`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 10:33:50
// Design Name: 
// Module Name: sim_adder8bit
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


module sim_adder8bit(

    );
    reg Cin;
    reg [7:0] A,B;
    wire Cout;
    wire [7:0] C;
    
    initial begin 
        Cin=1;A=8'b1111_1111;B=8'b1111_1111;
        forever #10 A=A-1;
        forever #20 B=B-1;
    end
    
    adder_8bit test(Cin,A,B,C,Cout);
endmodule
