module alu(
    input  [31:0] rs1,
    input  [31:0] rs2,
    input  [31:0] immediate,
    input  [3:0]  sel,        // changed to 4 bits
    input         AluSrc,
    output reg    zeroflag,
    output reg [31:0] out
);

    wire [31:0] b;

    assign b = (AluSrc == 1'b0) ? rs2 : immediate;

    always @(*) begin
        case(sel)

            4'd0:  out = rs1 + b;        // add
            4'd1:  out = rs1 - b;        // sub
            4'd2:  out = rs1 & b;        // and
            4'd3:  out = rs1 | b;        // or
            4'd4:  out = rs1 ^ b;        // xor
            4'd5:  out = ~(rs1 & b);     // nand
            4'd6:  out = ~(rs1 | b);     // nor
            4'd7:  out = rs1 << 4;       // shift left by 4
            4'd8:  out = rs1 >> 4;       // shift right by 4
//4'd9:  out = b >> 1;

            default: out = 32'd0;

        endcase

        zeroflag = (out == 32'd0);

    end

endmodule