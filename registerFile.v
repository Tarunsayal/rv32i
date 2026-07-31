module registerFile 
(
input [4:0] rs1_addr,
input [4:0] rs2_addr,
input [4:0] rd_addr,
input clk,
input [31:0] WriteData,
input RegWrite,

output reg[31:0] ReadData1,
output reg[31:0] ReadData2

);

reg [31:0] registers [0:31];
//making each register empty initially so no garbage value is thrown generally good practice

integer i;
initial begin
    for(i=0; i<32;i=i+1)begin
        registers[i]=0;
    end    
end
//combinational part
always@(*)begin
    ReadData1= registers[rs1_addr];
    ReadData2= registers[rs2_addr];
end
//sequential part 
always@(posedge clk)begin
    if(RegWrite && rd_addr != 5'd0)begin
        registers[rd_addr] <= WriteData;
    end
end

endmodule