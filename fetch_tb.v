`timescale 1ns/1ps

module fetch_tb;

reg clk;
reg reset;

wire [31:0] PcNxt;
wire [31:0] instruction;

// Instantiate PC
pc_counter pc_inst (
    .PcIn(PcNxt),   // feedback
    .clk(clk),
    .reset(reset),
    .PcNxt(PcNxt)
);

// Instantiate Instruction Memory
instructionMemory imem_inst (
    .add(PcNxt),
    .instruction(instruction)
);

// Clock generation: 10ns period
always #5 clk = ~clk;

initial begin
    $dumpfile("fetch_stage.vcd");
    $dumpvars(0, fetch_tb);

    clk = 0;
    reset = 1;

    #10;          // hold reset
    reset = 0;    // release reset

    #80;          // run for some cycles

    $finish;
end

endmodule
