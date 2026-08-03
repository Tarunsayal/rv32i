module pc_counter(
    input clk,
    input reset,
    input Branch,
    input zeroflag,
    input [31:0] aluResult,
    input [2:0] funct3,          // ← add this
    input [31:0] branchTarget,
    output reg [31:0] PcNxt
);

always @(posedge clk) begin
    if (reset)
        PcNxt <= 32'd0;
    else if (Branch) begin
        case(funct3)
            3'b000: PcNxt <= zeroflag            ? branchTarget : PcNxt + 4; // BEQ
            3'b001: PcNxt <= !zeroflag           ? branchTarget : PcNxt + 4; // BNE
            3'b100: PcNxt <= aluResult[0]        ? branchTarget : PcNxt + 4; // BLT  (SLT result)
            3'b101: PcNxt <= !aluResult[0]       ? branchTarget : PcNxt + 4; // BGE
            3'b110: PcNxt <= aluResult[0]        ? branchTarget : PcNxt + 4; // BLTU (SLTU result)
            3'b111: PcNxt <= !aluResult[0]       ? branchTarget : PcNxt + 4; // BGEU
            default: PcNxt <= PcNxt + 4;
        endcase
    end
    else
        PcNxt <= PcNxt + 4;
end

endmodule