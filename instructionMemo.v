module instructionMemory(
    input  [31:0] add,
    output reg [31:0] instruction
);

    // 256 words = 1KB of instruction memory
    // program.mem must be in the same directory as your simulation run
    reg [31:0] mem [0:255];

    initial begin
        $readmemh("program.mem", mem);
    end

    always @(*) begin
        instruction = mem[add >> 2];  // byte address → word index
    end

endmodule
