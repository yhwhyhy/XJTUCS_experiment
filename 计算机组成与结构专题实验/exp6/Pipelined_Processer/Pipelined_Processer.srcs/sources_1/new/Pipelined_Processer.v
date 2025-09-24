`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/19 22:48:08
// Design Name: 
// Module Name: Pipelined_Processer
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


module Pipelined_Processer(
	input clk
    );
	//Fetch Instruction
	reg[31:0] PC_in;
	wire[31:0] PC_out;
	wire StallF;
	reg StallFReg;
	wire StallD;
	reg StallDReg;
	wire[31:0] Instr_in;
	wire[31:0] Instr_out;
	reg[31:0] PCPlusF;
	wire[31:0] PCPlusD;
	reg PCSrc;
	reg PCSrcD;
	reg FlushEReg;
	initial begin
		PC_in=0;
		StallFReg=0;
		StallDReg=0;
		PCSrcD=0;
		FlushEReg=0;
	end
	ProgramCounter PC (
		.En(~StallFReg),
        .clk(clk),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );
	always @(*)begin
		PCPlusF=PC_out+1;
	end
	InstructionMemory IM(
	.Address(PC_out),
	.Instruction(Instr_in)
	);
	FI_ID PipeLinedReg1(
		.clk(clk),
		.En(~StallDReg),
		.CLR(PCSrcD),
		.Instr_in(Instr_in),
		.PCPlus_in(PCPlusF),
		.Instr_out(Instr_out),
		.PCPlus_out(PCPlusD)
	);
	//Instruction Decode
	reg PCBranchD;
	wire RegWriteD;
	wire MemtoRegD;
	wire MemWriteD;
	wire MemReadD;
	wire[1:0] ALUOp;
	wire[3:0] ALUcontrolD;
	wire ALUSrcD;
	wire RegDstD;
	wire BranchD;
	wire[31:0]ImmD;
	wire[31:0] ReadData1D;
	wire[31:0] ReadData2D;
/* 	wire[4:0] RsD;
	wire[4:0] RtD;
	wire[4:0] RdD; */
	wire ForwardAD;
	wire ForwardBD;
	wire[4:0] WriteRegW;
	reg[31:0] ResultW;
	CU_completed CU(
	.Opcode(Instr_out[31:26]),
	.RegDst(RegDstD),
	.ALUSrc(ALUSrcD),
	.MemtoReg(MemtoRegD),
	.RegWrite(RegWriteD),
	.MemWrite(MemWriteD),
	.MemRead(MemReadD),
	.Branch(BranchD),
	.ALUOp(ALUOp)
	);
	ALUControlUnit ALUCU(
	.Funct(Instr_out[5:0]),
	.ALUOp(ALUOp),
	.ALUControl(ALUcontrolD)
	);
	RegFile rf(
	.clk(clk),
	.RegWrite(RegWriteW),
	.ReadReg1(Instr_out[25:21]),
	.ReadReg2(Instr_out[20:16]),
	.WriteReg(WriteRegW),
	.WriteData(ResultW),
	.ReadData1(ReadData1D),
	.ReadData2(ReadData2D)
	);
	SignExt exten(
	.IR(Instr_out[15:0]),
	.SignExtImm(ImmD)
	);
	always @(*) begin
	PCBranchD=PCPlusD+ImmD;
	end
	wire FlushE;
	wire RegWriteE;
	wire MemToRegE;
	wire MemWriteE;
	wire MemReadE;
	wire[3:0] ALUControlE;
	wire ALUSrcE;
	wire RegDstE;
	wire[31:0] ReadData1E;
	wire[31:0] ReadData2E;
	wire[4:0] RsE;
	wire[4:0] RtE;
	wire[4:0] RdE;
	wire[31:0] ImmE;
	ID_EX PipeLinedReg2(
	.clk(clk),
	.CLR(FlushEReg),
	.RegWrite_in(RegWriteD),
	.MemToReg_in(MemtoRegD),
	.MemWrite_in(MemWriteD),
	.MemRead_in(MemReadD),
	.ALUControl_in(ALUcontrolD),
	.ALUSrc_in(ALUSrcD),
	.RegDst_in(RegDstD),
	.ReadData1_in(ReadData1D),
	.ReadData2_in(ReadData2D),
	.Rs_in(Instr_out[25:21]),
	.Rt_in(Instr_out[20:16]),
	.Rd_in(Instr_out[15:11]),
	.Imm_in(ImmD),
	.RegWrite_out(RegWriteE),
	.MemToReg_out(MemToRegE),
	.MemWrite_out(MemWriteE),
	.MemRead_out(MemReadE),
	.ALUControl_out(ALUControlE),
	.ALUSrc_out(ALUSrcE),
	.RegDst_out(RegDstE),
	.ReadData1_out(ReadData1E),
	.ReadData2_out(ReadData2E),
	.Rs_out(RsE),
	.Rt_out(RtE),
	.Rd_out(RdE),
	.Imm_out(ImmE)
	);
	//Excute stage
	wire[1:0] ForwardAE;
	wire[1:0] ForwardBE;
	reg[31:0] SrcAE;
	reg[31:0] SrcBE;
	reg[31:0] WriteDataE;
	wire[31:0] ALUResultE;
	reg[4:0] WriteRegE;
	ALU_noclk alu(
	.A(SrcAE),
	.B(SrcBE),
	.ALUControl(ALUControlE),
	.Result(ALUResultE)
	);
	wire RegWriteM;
	wire MemToRegM;
	wire MemWriteM;
	wire MemReadM;
	wire[31:0] ALUOutM;
	wire[31:0] WriteDataM;
	wire[4:0] WriteRegM;
	EX_MA PipeLinedReg3(
	.clk(clk),
	.RegWrite_in(RegWriteE),
	.MemToReg_in(MemToRegE),
	.MemWrite_in(MemWriteE),
	.MemRead_in(MemReadE),
	.ALUResult_in(ALUResultE),
	.WriteData_in(WriteDataE),
	.WriteReg_in(WriteRegE),
	.RegWrite_out(RegWriteM),
	.MemToReg_out(MemToRegM),
	.MemWrite_out(MemWriteM),
	.MemRead_out(MemReadM),
	.ALUResult_out(ALUOutM),
	.WriteData_out(WriteDataM),
	.WriteReg_out(WriteRegM)
	);
	wire[31:0] ReadDataM;
	DataMemory DM(
	.ReadData(ReadDataM),
	.Address(ALUOutM),
	.MemRead(MemReadM),
	.MemWrite(MemWriteM),
	.WriteData(WriteDataM)
	);
	//Write Back
	wire MemToRegW;
	wire[31:0] ReadDataW;
	wire[31:0] ALUOutW;
	MA_WB PipeLinedReg4(
	.clk(clk),
	.RegWrite_in(RegWriteM),
	.MemToReg_in(MemToRegM),
	.ReadData_in(ReadDataM),
	.ALUResult_in(ALUOutM),
	.WriteReg_in(WriteRegM),
	.RegWrite_out(RegWriteW),
	.MemToReg_out(MemToRegW),
	.ReadData_out(ReadDataW),
	.ALUResult_out(ALUOutW),
	.WriteReg_out(WriteRegW)
	);
	HazardControlUnit HazardHandle(
	.RegWriteM(RegWriteM),
	.RegWriteW(RegWriteW),
	.RegWriteE(RegWriteE),
	.WriteRegM(WriteRegM),
	.WriteRegW(WriteRegW),
	.WriteRegE(WriteRegE),
	.BranchD(BranchD),
	.RsE(RsE),
	.RtE(RtE),
	.ForwardAE(ForwardAE),
	.ForwardBE(ForwardBE),
	.MemToRegE(MemToRegE),
	.MemToRegM(MemToRegM),
	.RsD(Instr_out[25:21]),
	.RtD(Instr_out[20:16]),
	.ForwardAD(ForwardAD),
	.ForwardBD(ForwardBD),
	.StallF(StallF),
	.StallD(StallD),
	.FlushE(FlushE)
	);
	always @(*) begin
		StallFReg=StallF;
		StallDReg=StallD;
		FlushEReg=FlushE;
		PCSrcD=PCSrc;
	end
	always @(*) begin
		if (PCSrc) PC_in=PCBranchD;
		else PC_in=PCPlusF;
	end
	reg[31:0] cmpA;
	reg[31:0] cmpB;
	always @(*) begin
		if (ForwardAD) cmpA=ALUOutM;
		else cmpA=ReadData1D;
	end
	always @(*) begin
		if (ForwardBD) cmpB=ALUOutM;
		else cmpB=ReadData2D;
	end
	always @(*) begin
		PCSrc=BranchD&(cmpA==cmpB);
	end
	always @(*) begin
		if (RegDstE) WriteRegE=RdE;
		else WriteRegE=RtE;
	end
	always @(*) begin
		if (MemToRegW) ResultW=ReadDataW;
		else ResultW=ALUOutW;
	end
	always @(*) begin
	case (ForwardAE)
		2'b00:SrcAE=ReadData1E;
		2'b01:SrcAE=ResultW;
		2'b10:SrcAE=ALUOutM;
		default:SrcAE=ReadData1E;
	endcase
	end
	always @(*) begin
	case (ForwardBE)
		2'b00:WriteDataE=ReadData2E;
		2'b01:WriteDataE=ResultW;
		2'b10:WriteDataE=ALUOutM;
		default:WriteDataE=ReadData2E;
	endcase
	end
	always @(*) begin
		if (ALUSrcE) SrcBE=ImmE;
		else SrcBE=WriteDataE;
	end
endmodule
