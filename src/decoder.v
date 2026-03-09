module decoder(
    input  [31:0] instruction,

    output reg [6:0] opcode,
    output reg [4:0] rd,
    output reg [2:0] funct3,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [6:0] funct7,

    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg ALUSrc,
    output reg Branch,
    output reg [1:0] ALUOp
);

always @(*) begin

    // -------- Field Extraction --------
    opcode = instruction[6:0];
    rd     = instruction[11:7];
    funct3 = instruction[14:12];
    rs1    = instruction[19:15];
    rs2    = instruction[24:20];
    funct7 = instruction[31:25];

    // -------- Default Safe Values --------
    RegWrite = 0;
    MemRead  = 0;
    MemWrite = 0;
    MemtoReg = 0;
    ALUSrc   = 0;
    Branch   = 0;
    ALUOp    = 2'b00;

    // -------- Control Logic --------
    case (opcode)
  
        // R-Type (0110011)
        7'b0110011: begin
            RegWrite = 1;
            ALUSrc   = 0;
            ALUOp    = 2'b10;
        end

        // I-Type ALU (0010011)
        7'b0010011: begin
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b10;
        end

        // LOAD (0000011)
        7'b0000011: begin
            RegWrite = 1;
            MemRead  = 1;
            MemtoReg = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;  // address calculation (ADD)
        end

        // STORE (0100011)
        7'b0100011: begin
            MemWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00;  // address calculation (ADD)
        end

        // BRANCH (1100011)
        7'b1100011: begin
            Branch = 1;
            ALUOp  = 2'b01;   // subtract for comparison
        end

        default: begin
            // already safe due to defaults
        end

    endcase

end

endmodule