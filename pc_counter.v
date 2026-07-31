module pc_counter
(
input clk,
input zeroflag,
input Branch,
input [31:0]branchTarget,
input reset,
output  reg [31:0]PcNxt);


always@(posedge clk)begin
    if(reset)begin
        PcNxt<=32'd0;
    end
    else if (Branch && zeroflag) begin
        PcNxt <= branchTarget;
    end
else begin
     PcNxt <= PcNxt + 4;
end
end
endmodule