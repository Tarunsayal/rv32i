module DataMemo (
    input  clk,
    input  mem_read,
    input  mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

    reg [31:0] mem [0:1023];

    // Asynchronous read
    assign read_data = (mem_read) ? mem[address[11:2]] : 32'b0;

    // Synchronous write
    always @(posedge clk) begin
        if (mem_write)
            mem[address[11:2]] <= write_data;
    end

endmodule