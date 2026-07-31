`timescale 1ps/1ps

module DataMemoTB;
reg clk;
reg mem_read;
reg mem_write;
reg [31:0] address;
reg [31:0] write_data;

wire [31:0] read_data;

DataMemo DTU (
    .clk(clk),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .address(address),
    .write_data(write_data),
    .read_data(read_data)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("DataMemoTB.vcd");
    $dumpvars(0, DataMemoTB);

    // initialization
    clk       = 0;
    mem_read  = 0;
    mem_write = 0;
    address   = 32'h00000000;
    write_data = 32'd0;

    // Test 1 — write 5 to address 0, then read it back
    @(posedge clk); #1;
    mem_write  = 1;
    address    = 32'h00000000;
    write_data = 32'd5;

    @(posedge clk); #1;
    mem_write = 0;

    mem_read = 1;
    address  = 32'h00000000;
    #1;

    if (read_data == 32'd5)
        $display("Test 1 PASSED — read back correct value");
    else
        $display("Test 1 FAILED — expected 5, got %0d", read_data);

mem_read =0;
    // test 2 to check if assign read_data = (mem_read) ? mem[address[11:2]] : 32'b0; this branch statement is running properly 

   #1; 
    
    if(read_data == 0)
    $display("test 2 passed");
    else
    $display("Test 2 FAILED — expected 0, got %0d", read_data);

    $finish;
end

endmodule