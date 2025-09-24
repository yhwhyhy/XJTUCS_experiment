`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 16:43:49
// Design Name: 
// Module Name: sim_controller
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


module sim_controller(

    );
	reg[5:0] Op,Funct;
	reg Zero,clk1,clk2;
	wire MemToReg,MemWrite,PCSrc,ALUSrc,RegDst,RegWrite,Jump;
	wire[2:0] ALUControl;
	
	reg[5:0] nextOp,nextFunct;
	initial begin
		Zero=0;
		Op=6'b000000;
		Funct=6'b100000;
		clk1=0;
		clk2=0;
	end
	initial begin
		forever #30 clk1=~clk1;
	end
	initial begin
		forever #5 clk2=~clk2;
	end
	always @(posedge clk1) begin
		case(Op)
			6'b000000: begin nextOp=6'b100011; Op=nextOp;end
			6'b100011: begin nextOp=6'b101011; Op=nextOp;end
			6'b101011: begin nextOp=6'b000100; Op=nextOp;end
			6'b000100: begin nextOp=6'b001000; Op=nextOp;end
			6'b001000: begin nextOp=6'b000010; Op=nextOp;end
			6'b000010: begin nextOp=6'b000000; Op=nextOp;end
			default: begin nextOp=6'b000000; Op=nextOp;end
		endcase
	end
	always @(posedge clk2) begin
		case(Funct)
			6'b100000:begin nextFunct=6'b100010; Funct=nextFunct;end
			6'b100010:begin nextFunct=6'b100100; Funct=nextFunct;end
			6'b100100:begin nextFunct=6'b100101; Funct=nextFunct;end
			6'b100101:begin nextFunct=6'b101010; Funct=nextFunct;end
			6'b101010:begin nextFunct=6'b100000; Funct=nextFunct;end
			default:begin nextFunct=6'b100000; Funct=nextFunct;end
		endcase
	end
	Controller test(Op,Funct,Zero,MemToReg,MemWrite,PCSrc,ALUSrc,RegDst,RegWrite,Jump,ALUControl);
endmodule
