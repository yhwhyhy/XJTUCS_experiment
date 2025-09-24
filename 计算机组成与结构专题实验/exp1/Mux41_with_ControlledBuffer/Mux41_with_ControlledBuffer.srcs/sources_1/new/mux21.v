`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/17 17:09:53
// Design Name: 
// Module Name: mux21
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


module mux21(
    In1,In2,sel,Out
    );
    
    input In1,In2,sel;
    output Out;
    wire In1,In2,sel,sg1,sg2;
    reg Out;
    
    ControlledBuffer sig1(~sel,In1,sg1);
    ControlledBuffer sig2(sel,In2,sg2);
    
    always @(*) begin
        if (sg1===1'bz) Out=sg2;
        else Out=sg1;
        end
endmodule
