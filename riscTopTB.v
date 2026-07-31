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
        #222
        $display("x1 = %0d", dut.registerFileInst.registers[1]);
        $display("x2 = %0d", dut.registerFileInst.registers[2]);
        $display("x1 after instruction 1= %0d", dut.registerFileInst.registers[1]);
        $display("x3 = %0d", dut.registerFileInst.registers[3]);
        $display("x4 = %0d", dut.registerFileInst.registers[4]);
       
        $display("PC after run = %0d", dut.PC.PcNxt);
        $display("instruction at 0 = %h", dut.InstructionMemoryInst.instruction);

        $finish;
        
    end

    
endmodule