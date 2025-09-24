`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/18 15:10:50
// Design Name: 
// Module Name: StreamCPU
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


module SimpleCycleCPU(
	input clk,
	input reset
    );
	
	reg [31:0] PC_in;
    wire [31:0] PC_out, Instruction;
	reg [31:0]pc_temp;
	reg [31:0]next_pc;
	reg [31:0]IR;
    wire [31:0] ReadData1, ReadData2, ALUResult, MemReadData;
    reg [31:0] SignExtImm;
    reg [31:0] ALUInputB;
    reg [4:0] WriteReg; // 修改为 reg 类型
    wire [3:0] ALUControl;
    wire Zero;
	// 控制信号
    wire RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemToReg, Jump, PCSrc;
    wire [1:0] ALUOp;
	
/* 	reg [31:0] IR12; // 12阶段间指令寄存器
	reg [31:0] next_pc_12;
	
	reg [31:0] next_pc_23;
	reg [31:0] Rs;//暂存ReadData1
	reg [31:0] Rt23;//暂存ReadData2
	reg [31:0] Imm;//暂存立即数
	reg [31:0] IR23;
	
	reg [31:0] next_pc_34;
	reg [31:0] next_pc_j;
	reg [31:0] next_pc_branch;
	reg  ZF;
	reg [31:0] ALUOut34;
	reg [31:0]Rt34;
	reg [31:0] IR34;
	
	reg [31:0] ALUOut45;
	reg [31:0] Memout;
	reg [31:0] IR45; */
	
	
	    // 初始化 PC_in
    initial begin
        PC_in = 0;
    end// 实例化程序计数器
    ProgramCounter PC (
        .clk(clk),
        .reset(reset),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );
	always @(*) begin
		next_pc=PC_out+1;
	end
    // 实例化指令存储器
    InstructionMemory IM (
        .Address(PC_out),
        .Instruction(Instruction)
    );
	always @(*) begin
		IR<=Instruction;
	end
	// 寄存器组
    RegFile RF(
        .clk(clk),
        .RegWrite(RegWrite),
        .ReadReg1(Instruction[25:21]),
        .ReadReg2(Instruction[20:16]),
        .WriteReg(WriteReg),
        .WriteData(MemtoReg ? MemReadData : ALUResult),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
	// 实例化数据存储器
    DataMemory DM (
        //.clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(MemReadData)
    );
// 控制单元
        CU_completed CU(
            //.clk(clk),
            .Opcode(Instruction[31:26]),
            .RegDst(RegDst),
            .ALUSrc(ALUSrc),
            .MemtoReg(MemtoReg),
            .RegWrite(RegWrite),
            .MemRead(MemRead),
            .MemWrite(MemWrite),
            .Branch(Branch),
            .ALUOp(ALUOp),
			.Jump(Jump)
        );
// ALU控制单元
        ALUControlUnit ALUCtrl(
            .ALUOp(ALUOp),
            .Funct(Instruction[5:0]),
            .ALUControl(ALUControl)
        );
		
 // 符号扩展逻辑
    always @(*) begin
        SignExtImm = {{16{IR[15]}}, IR[15:0]}; // 使用 IR
    end
 // ALU 输入选择逻辑
    always @(*) begin
        if (ALUSrc)
            ALUInputB = SignExtImm;
        else
            ALUInputB = ReadData2;
    end
// ALU 操作
    ALU_noclk alu (
        //.clk(clk),
        .A(ReadData1),
        .B(ALUInputB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );
	
	    always @(*) begin
        if (RegDst)
            WriteReg = IR[15:11]; // R-type 指令写入 rd
        else
            WriteReg = IR[20:16]; // I-type 指令写入 rt
		end
		
		always @(*) begin

			if (Branch&Zero==1) pc_temp=PC_out+SignExtImm;
			else pc_temp=next_pc;
			if (Jump==1) PC_in={next_pc[31:28],Instruction[27:0]};
			else PC_in=pc_temp;
		end
endmodule
