`timescale 1ps/1ps
module registerFile_TB;

reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;
reg clk;
reg [31:0] WriteData;
reg RegWrite;

wire [31:0] ReadData1;
wire [31:0] ReadData2;

RegisterFile dut
(
    .rs1(rs1),
    .rs2(rs2),
    .clk(clk),
    .rd(rd),
    .WriteData(WriteData),
    .RegWrite(RegWrite),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("registerFile_TB.vcd");
    $dumpvars(0,registerFile_TB);

    rs1 = 0;
    rs2 = 0;
    rd  = 0;
    clk = 0;
    WriteData = 0;
    RegWrite  = 0;

    // TEST 1 : Write to register 5

    #2;                          
    WriteData = 32'hAAAAAAAA;
    RegWrite  = 1;
    rd        = 5;

    #10;
    RegWrite  = 0;

    rs1 = 5;
    #2;

    if (ReadData1 !== 32'hAAAAAAAA)
        $display("TEST1 FAILED");
    else
        $display("TEST1 PASSED");

    // TEST 2 : RegWrite = 0 (should not update)

    #2;
    rd        = 5;
    WriteData = 32'hAAAAAAA9;
    RegWrite  = 0;

    #10;

    rs1 = 5;
    #2;

    if (ReadData1 !== 32'hAAAAAAAA)
        $display("TEST2 FAILED");
    else
        $display("TEST2 PASSED");

    // TEST 3 : Write to another register (4)

    #2;
    rd        = 4;
    WriteData = 32'hAAAAAAA8;
    RegWrite  = 1;

    #10;
    RegWrite  = 0;

    rs1 = 5;    
    rs2 = 4;    
    #2;

    if (ReadData1 !== 32'hAAAAAAAA)
        $display("TEST3 FAILED (reg5 wrong)");
    else if (ReadData2 !== 32'hAAAAAAA8)
        $display("TEST3 FAILED (reg4 wrong)");
    else
        $display("TEST3 PASSED");

    #20;
    $finish;
end


endmodule