module immediateGen
(
input [6:0]opcode,
input [31:0] instruction,

output reg [31:0] out

);

always@(*)begin

case(opcode)
    7'b0010011,7'b0000011 : out = (instruction[31])? {{20{1'b1}},instruction[31:20]}:{{20{1'b0}},instruction[31:20]}; //I - TYPE
    7'b0100011 : out =(instruction[31])?  {{20{1'b1}},instruction[31:25],instruction[11:7]} :{{20{1'b0}},instruction[31:25],instruction[11:7]} ; //S -TYPE
    7'b1100011 : out = (instruction[31])? { {19{1'b1}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0} : { {19{1'b0}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}; //B - TYPE
   default out = 32'b0;
endcase
 
end 
endmodule