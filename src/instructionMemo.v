module instructionMemory(
    input [31:0]add,
    output reg [31:0]instruction 
);
always@(*)begin
    case(add)
    32'h00000000:instruction=32'b10101100101011001010110010101100;
    32'h00000004: instruction=32'b01010111000111001010101100011100;
    32'h00000008: instruction=32'b11100011001010101111000011001101;
default instruction=32'd0;
endcase
end

endmodule