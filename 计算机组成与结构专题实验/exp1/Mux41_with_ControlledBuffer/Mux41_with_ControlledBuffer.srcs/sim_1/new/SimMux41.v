`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/17 23:04:21
// Design Name: 
// Module Name: SimMux41
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


module SimMux41(

    );
    reg In0,In1,In2,In3;
         reg [1:0] sel;
         wire Out;
           initial begin
               fork
               In0=0;In1=1;In2=0;In3=1;sel=2'b00;
               forever #5 In0=~In0;
               forever #10 In1=~In1;
               forever #10 In2=~In2;
               forever #5 In3=~In3;
               forever #10 sel=(sel+1)%4;
               join
               end
               
            mux41 mux41_1(In0,In1,In2,In3,sel,Out);  
endmodule
