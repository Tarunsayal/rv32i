module alu(
    input  [31:0] rs1_Value,
    input  [31:0] rs2_Value,
    input  [31:0] immediate,
    input  [3:0]  sel,        // changed to 4 bits
    input         AluSrc,
    output reg    zeroflag,
    output reg [31:0] aluResult
);

    wire [31:0] b;

    assign b = (AluSrc == 1'b0) ? rs2_Value : immediate;

    always @(*) begin
        case(sel)

            4'd0:  aluResult = rs1_Value + b;        // add
            4'd1:  aluResult = rs1_Value - b;        // sub
            4'd2:  aluResult = rs1_Value & b;        // and
            4'd3:  aluResult = rs1_Value | b;        // or
            4'd4:  aluResult = rs1_Value ^ b;        // xor
            4'd5:  aluResult = rs1_Value << b[4:0];       // shift left by 4
            4'd6:  aluResult = rs1_Value >> b[4:0];      // shift right by 4 srl
            4'd7: aluResult=($signed(rs1_Value)) >>> b[4:0]   ;       // SRA shift right arithmatic
            4'd8: aluResult=($signed(rs1_Value)<$signed(b))? 32'd1:32'd0;       // SLT set less than
            
            default: aluResult = 32'd0;

        endcase

        zeroflag = (aluResult == 32'd0);

    end

endmodule