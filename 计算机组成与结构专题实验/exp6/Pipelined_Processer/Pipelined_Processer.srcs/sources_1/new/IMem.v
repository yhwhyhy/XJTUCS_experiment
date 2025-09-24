`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/03 15:56:07
// Design Name: 
// Module Name: IMem
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


module InstructionMemory(
Address,Instruction
    );
    parameter Instruction_Width=32;
    parameter IMEM_Size=64;
    input [31:0]Address;
    output [Instruction_Width-1:0]Instruction;
    reg [31:0] ROM[IMEM_Size-1:0];
    integer i=0;
    initial begin
        for (i=10;i<IMEM_Size;i=i+1) ROM[i]=i;
    end
	initial begin 
		ROM[0] = 32'h34080005;  // ori $0, $8, 5
        ROM[1] = 32'h3409000A;  // ori $0, $9, 10
        ROM[2] = 32'h01095021;  // addu $t8, $t9, $18
        ROM[3] = 32'h01085823;  // subu $8, $8, $11
        ROM[4] = 32'hAC080000;  // sw $0, 0($8)
        ROM[5] = 32'h8C180000;  // lw $0, 0($24)
        ROM[6] = 32'h10000007;  // beq $10, $t4, label=2
        ROM[7] = 32'h3C0A1234;  // lui $10, 0x1234
        ROM[8] = 32'h00000000;  // nop
        ROM[9] = 32'h00000000;  // nop (label 后续指令)
	end
    assign Instruction=ROM[Address];
endmodule
