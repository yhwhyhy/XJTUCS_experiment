`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/17 22:56:42
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
    In0,In1,In2,In3,sel,Out
    );
    
    input In0,In1,In2,In3,sel;
    output Out;
    wire In0,In1,In2,In3,tmp0,tmp1;
    wire [1:0] sel;
    wire Out;
    
    mux21 mux21_1_0(In0,In1,sel[0],tmp0);
    mux21 mux21_1_1(In2,In3,sel[0],tmp1);
    mux21 mux21_2(tmp0,tmp1,sel[1],Out);
endmodule
