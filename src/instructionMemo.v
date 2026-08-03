module instructionMemory(
    input  [31:0] add,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:255]; // 256 words = 1KB

    initial begin
          $readmemh("C:/Projects/risc_v/program.mem", memory);
    end

    always @(*) begin
        instruction = memory[add >> 2]; // byte addr → word index
    end

endmodule