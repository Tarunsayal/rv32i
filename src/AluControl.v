module AluControl(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7,
    input ALUSrc,
    output reg [3:0] sel
);

always @(*) begin
    case(ALUOp)
        2'b00: sel = 4'd0;  // LOAD/STORE always ADD
        2'b01: sel = 4'd1;  // BRANCH always SUB

        2'b10: case(funct3)
            3'b000: sel = (funct7 && !ALUSrc) ? 4'd1 : 4'd0; // SUB only R-type, ADDI always ADD
            3'b111: sel = 4'd2;  // AND/ANDI
            3'b110: sel = 4'd3;  // OR/ORI
            3'b100: sel = 4'd4;  // XOR/XORI
            3'b001: sel = 4'd5;  // SLL/SLLI
            3'b101: sel = (funct7) ? 4'd7 : 4'd6; // SRA/SRAI vs SRL/SRLI
            3'b010: sel = 4'd8;  // SLT/SLTI
            3'b011: sel = 4'd9;  // SLTU/SLTIU
            default: sel = 4'd0;
        endcase

        default: sel = 4'd0;
    endcase
end

endmodule