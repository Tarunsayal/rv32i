module AluControl
(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7,
    output reg [3:0]sel
);

always@(*)begin

    case(ALUOp)
    2'b00 : sel = 4'd0; // ADD
    2'b01 : sel = 4'd1; // SUB

    2'b10 : case(funct3)

    3'b000 : sel = (funct7) ? 4'd1 : 4'd0;// ADD if funct7 is 0 else sub
    3'b111 : sel = 4'd2; // AND
    3'b110 : sel = 4'd3; // OR
    3'b100 : sel = 4'd4; // XOR
    3'b001 : sel = 4'd5; // shift left
    3'b101 : sel = (funct7)? 4'd7 : 4'd6;//if funct7 0 then SRL else SRA
    3'b010 : sel = 4'd8; //SLT

    default : sel = 4'd0;

endcase

    default : sel = 0;

endcase

end

endmodule