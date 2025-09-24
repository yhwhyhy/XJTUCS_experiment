`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/09 15:54:48
// Design Name: 
// Module Name: sim_mux41
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


module sim_mux41(

    );
    reg D0,D1,D2,D3;
    reg [1:0] S;
    mux41 mux(D0,D1,D2,D3,S,Y);
    initial begin
            D0=0;D1=0;D2=0;D3=0;S=2'b00;
            fork
                repeat(100) #10 D0=~D0;
                repeat(500) #20 D1=~D1;
                repeat(25) #40 D2=~D2;
                repeat(10) #100 D3=~D3;
                repeat(5) #200 S=S+1;
             join
            end
endmodule
