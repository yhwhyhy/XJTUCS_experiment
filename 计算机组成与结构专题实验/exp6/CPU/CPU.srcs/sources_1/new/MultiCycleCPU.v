`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/14 10:07:53
// Design Name: 
// Module Name: MultiCycleCPU
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


module MultiCycleCPU(
input clk,input reset
    );
	// 定义状态
    parameter FETCH = 3'b000;
    parameter DECODE = 3'b001;
    parameter EXECUTE = 3'b010;
    parameter MEM_ACCESS = 3'b011;
    parameter WRITE_BACK = 3'b100;

    reg [2:0] state, next_state;
	// 内部信号
    reg [31:0] PC_in;
    wire [31:0] PC_out, Instruction;
    reg [31:0] IR; // 指令寄存器
    wire [31:0] ReadData1, ReadData2, ALUResult, MemReadData;
    reg [31:0] SignExtImm;
    reg [31:0] ALUInputB;
    reg [4:0] WriteReg; // 修改为 reg 类型
    wire [3:0] ALUControl;
    wire Zero;
	// 控制信号
    wire RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemToReg, Jump, PCSrc;
    wire [1:0] ALUOp;

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
    DataMemory_4Kx32 DM (
        .clk(clk),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(MemReadData),
		.Rst(reset)
    );
// 控制单元
        ControlUnit CU(
            .clk(clk),
            .Opcode(Instruction[31:26]),
            .RegDst(RegDst),
            .ALUSrc(ALUSrc),
            .MemtoReg(MemtoReg),
            .RegWrite(RegWrite),
            .MemRead(MemRead),
            .MemWrite(MemWrite),
            .Branch(Branch),
            .ALUOp(ALUOp)
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
    ALU alu (
        .clk(clk),
        .A(ReadData1),
        .B(ALUInputB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero)
    );
// 状态机
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= FETCH;
            IR <= 0;
            PC_in <= 0; // 重置时 PC 归零
        end else begin
            state <= next_state;
                // 控制信号设置
            if (state == FETCH) begin
                IR <= Instruction; // 在 FETCH 状态下写入新的指令
				if (Zero&Branch==1) PC_in<=PC_out+SignExtImm;
                else PC_in <= PC_out + 1; // 在 FETCH 状态下更新 PC
            end
        end
    end
// 下一状态逻辑
    always @(*) begin
        case (state)
            FETCH: next_state = DECODE;
            DECODE: next_state = EXECUTE;
            EXECUTE: begin
                case (IR[31:26])
                    6'b100011, 6'b101011: next_state = MEM_ACCESS; // LW, SW
                    6'b000100: next_state = FETCH; // BEQ
                    6'b001000: next_state = WRITE_BACK; // ADDI
                    6'b000000: next_state = WRITE_BACK; // R-type
                    default: next_state = FETCH;
                endcase
            end
			MEM_ACCESS: begin
                if (IR[31:26] == 6'b100011) // LW
                    next_state = WRITE_BACK;
                else
                    next_state = FETCH; // SW
            end
            WRITE_BACK: next_state = FETCH;
            default: next_state = FETCH;
        endcase
    end

    // 写寄存器选择逻辑
    always @(*) begin
        if (RegDst)
            WriteReg = IR[15:11]; // R-type 指令写入 rd
        else
            WriteReg = IR[20:16]; // I-type 指令写入 rt
    end
endmodule


