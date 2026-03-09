module pc_counter
(input [31:0]PcIn,
input clk,
input reset,
output  reg [31:0]PcNxt);

always@(posedge clk)begin
    if(reset)
    PcNxt<=0;
    else
    PcNxt<=PcIn+4;
end
endmodule