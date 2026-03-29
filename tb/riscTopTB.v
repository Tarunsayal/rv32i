`timescale 1ps/1ps

module TB_riscTop; 
    reg clk;
    reg reset;

    riscTop dut(
        .clk(clk),
        .reset(reset)
    );

    
    always #5 clk = ~clk;

    initial begin
        clk=0;

        $dumpfile("riscTopTB.vcd");
        $dumpvars(0,TB_riscTop);
        
        #2
        reset=1;
        #22
        reset=0;
        #10;
        $display("PC at first cycle = %0d", dut.PC.PcNxt);
        #10;
        $display("ALUResult = %0d", dut.ALUInst.aluResult);
$display("MemtoReg = %0d", dut.DecoderInst.MemtoReg);
$display("immediate = %0d", dut.ImmediateGenInst.immediate);
$display("ALUSrc = %0d", dut.DecoderInst.ALUSrc);
$display("sel = %0d", dut.AluControlInst.sel);
$display("PC at first cycle = %0d", dut.PC.PcNxt);
$display("RegWrite = %0d", dut.DecoderInst.RegWrite);
$display("instruction = %h", dut.InstructionMemoryInst.instruction);
$display("rd_addr = %0d", dut.DecoderInst.rd_addr);
$display("WriteData = %0d", dut.registerFileInst.WriteData);
        #222
        $display("x1 = %0d", dut.registerFileInst.registers[1]);
        $display("x2 = %0d", dut.registerFileInst.registers[2]);
        $display("x3 = %0d", dut.registerFileInst.registers[3]);
        $display("x4 = %0d", dut.registerFileInst.registers[4]);
        $display("x5 = %0d", dut.registerFileInst.registers[5]);
        $display("x6 = %0d", dut.registerFileInst.registers[6]);

        $display("PC after run = %0d", dut.PC.PcNxt);
        $display("instruction at 0 = %h", dut.InstructionMemoryInst.instruction);
        
        $finish;
        
    end

    
endmodule