`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/17 19:31:57
// Design Name: 
// Module Name: mux_41
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


module mux_41(
    In0,In1,In2,In3,sel,Out
    );
    
    input In1,In2,In3,In0,sel;
    output Out;
    
    wire In1,In2,In3,In0,tmp1,tmp0;
    wire [1:0] sel;
    wire Out;
    
        mux21 mux21_1_1(In0,In1,sel[0],tmp0);
        mux21 mux21_1_2(In2,In3,sel[0],tmp1);
        mux21 mux21_2(tmp0,tmp1,sel[1],Out);

    
endmodule
