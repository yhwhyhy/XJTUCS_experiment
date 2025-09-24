`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/20 10:57:39
// Design Name: 
// Module Name: sim_FSM_cf
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


module sim_FSM_cf(

    );
    reg clk,reset,a;
    wire y;
    reg [7:0] string;
    integer i;
    
    initial begin 
        fork
        i=7;
        string=8'b1001_1101;
        clk=0;forever #10 clk=~clk;
        reset=0; #10 reset=1;#20 reset=0;
        join
    end
    
    always @(posedge clk)
        begin
            if (i>=0) 
                begin 
                    a=string[i];
                    i=i-1;
                end
         end               
    FSM_caseif test(clk,reset,a,y);
endmodule
