`timescale 1ps/1ps

module TB_riscTop;
    reg clk;
    reg reset;

    riscTop dut(
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;
        always @(posedge clk) begin
    $display("PC=%0d | instr=%h | imm=%h | aluResult=%h | rd=%0d | RegWrite=%b | rs1_value = %b | sel=%b |b=%b",
        dut.PC.PcNxt,
        dut.InstructionMemoryInst.instruction,
        dut.ImmediateGenInst.immediate,
        dut.ALUInst.aluResult,
        dut.DecoderInst.rd_addr,
        dut.DecoderInst.RegWrite,
        dut.ALUInst.rs1_Value,
        dut.AluControlInst.sel,
        dut.ALUInst.b
        );
end
    initial begin
        clk   = 0;
        reset = 1;

        $dumpfile("riscTopTB.vcd");
        $dumpvars(0, TB_riscTop);

        // hold reset 3 cycles
        #30;
        reset = 0;

        // wait 10 cycles for 5 instructions to complete
        #200;

        $display("x1 = %0d", dut.registerFileInst.registers[1]);
        $display("x2 = %0d", dut.registerFileInst.registers[2]);
        $display("x3 = %0d", dut.registerFileInst.registers[3]);
        $display("x4 = %0d", dut.registerFileInst.registers[4]);
        $display("x5 = %0d", dut.registerFileInst.registers[5]);
        $display("x6 = %0d", dut.registerFileInst.registers[6]);
        $display("x7 = %0d", dut.registerFileInst.registers[7]);
        $display("x8 = %0d", dut.registerFileInst.registers[8]);
        $display("x9 = %0d", dut.registerFileInst.registers[9]);
        $display("x10 = %0d", dut.registerFileInst.registers[10]);
        $display("x11= %0d", $signed(dut.registerFileInst.registers[11]));
        $display("x12= %0d", $signed(dut.registerFileInst.registers[12]));
        $display("x13= %0d", $signed(dut.registerFileInst.registers[13]));
  
        $display("imm        = %h", dut.ImmediateGenInst.immediate);
        $display("ALU b      = %h", dut.ALUInst.b);
        $display("ALU result = %h", dut.ALUInst.aluResult);
        $display("WriteData  = %h", dut.WriteData);
        $display("x11 raw    = %h", dut.registerFileInst.registers[11]);
        $display("PC = %0d", dut.PC.PcNxt);
        $display("ALU b = %h", dut.ALUInst.b);

        $finish;
    end

endmodule