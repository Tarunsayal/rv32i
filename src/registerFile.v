module RegisterFile 
(
input [4:0] rs1,
input [4:0] rs2,
input [4:0] rd,
input clk,
input [31:0] WriteData,
input RegWrite,

output reg[31:0] ReadData1,
output reg[31:0] ReadData2

);

reg [31:0] registers [0:31];
//combinational part
always@(*)begin
    ReadData1= registers[rs1];
    ReadData2= registers[rs2];
end
//sequential part 
always@(posedge clk)begin
    if(RegWrite)begin
        registers[rd] <= WriteData;
    end
end

endmodule