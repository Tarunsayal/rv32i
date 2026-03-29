module pc_counter
(input [31:0]PcIn,
input clk,
input zeroflag,
input Branch,
input [31:0]branchTarget,
input reset,
output  reg [31:0]PcNxt);


always@(posedge clk)begin
    if(reset)begin
        PcNxt<=32'hFFFFFFFC;
    end
    else if (Branch == 1 && zeroflag == 1) begin
        PcNxt <= branchTarget;
    end
else begin
     PcNxt <= PcIn + 4;
end
end
endmodule