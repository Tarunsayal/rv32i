module riscTop(
input clk,
input reset
);

wire [31:0] PcNxt;
wire [31:0] instruction;
wire [31:0] immediate;
wire [31:0] rs1_Value;
wire [31:0] rs2_Value;
wire [31:0] ALUResult;
wire [31:0] read_data ;
wire [31:0] branchTarget;
wire [31:0] WriteData;
wire [4:0] rd_addr;
wire [4:0] r1_addr;
wire [4:0] r2_addr;
wire [3:0] sel;
wire [2:0] funct3;
wire [1:0] ALUOp;
wire funct7;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire ALUSrc;
wire Branch;




wire zeroflag;
wire [6:0] opcode;


assign branchTarget = PcNxt + immediate;
assign WriteData = (MemtoReg) ? read_data : ALUResult;

pc_counter PC(
    .clk(clk),
    .reset(reset),
    .Branch(Branch),
    .zeroflag(zeroflag),
    .branchTarget(branchTarget),
    .PcIn(PcNxt),
    .PcNxt(PcNxt)       // output connected
);

instructionMemory InstructionMemoryInst(
    .add(PcNxt),
    .instruction(instruction) // output connected
);

immediateGen ImmediateGenInst(
    .instruction(instruction),
    .immediate(immediate) // output connected
);

decoder DecoderInst(
    .instruction(instruction),
    .opcode(opcode), // output connected
    .rd_addr(rd_addr),
    .funct3(funct3),
    .rs1_addr(r1_addr),
    .rs2_addr(r2_addr),
    .funct7(funct7),

    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .ALUSrc(ALUSrc),
    .Branch(Branch),
    .ALUOp(ALUOp)

);

alu ALUInst(
    .rs1_Value(rs1_Value),
    .rs2_Value(rs2_Value),
    .immediate(immediate),
    .sel(sel),
    .AluSrc(ALUSrc),
    .zeroflag(zeroflag), // output connected
    .aluResult(ALUResult)

);

AluControl AluControlInst(
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),  
    .sel(sel) // output connected
);

registerFile registerFileInst   (
    .rs1_addr(r1_addr),
    .rs2_addr(r2_addr),
    .rd_addr(rd_addr),
    .clk(clk),
    .WriteData(WriteData),
    .RegWrite(RegWrite),

    .ReadData1(rs1_Value),   // output connected
    .ReadData2(rs2_Value) 
);

DataMemo DataMemoInst (
    .clk(clk),
    .mem_read(MemRead),
    .mem_write(MemWrite),
    .address(ALUResult),
    .write_data(rs2_Value),
    .read_data(read_data)  
);
    
endmodule