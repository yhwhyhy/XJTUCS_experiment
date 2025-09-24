`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/17 18:16:44
// Design Name: 
// Module Name: sim_mux21
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


module sim_mux21(
    
    );
    reg In1,In2,sel;
    wire Out;
    initial begin
        fork
        In1=0;In2=1;sel=0;
        #30 sel=~sel;
        forever #5 In1=~In1;
        forever #10 In2=~In2;
        join
        end
        
     mux21 mux21_1(In1,In2,sel,Out);   
        
endmodule
