module instructionMemory(
    input [31:0]add,
    output reg [31:0]instruction 
);
always@(*)begin
    case(add)
    32'h00000000:instruction=32'h00500093; //addi x1, x0, 5      --> 00500093
    32'h00000004: instruction=32'h00300113; //addi x2, x0, 3      --> 00300113
    32'h00000008: instruction=32'h002081b3; //add  x3, x1, x2     --> 002081b3
    32'h0000000c: instruction=32'h40208233; //sub  x4, x1, x2     --> 40208233
    32'h00000010: instruction=32'h0020f2b3; //and  x5, x1, x2     --> 0020f2b3
    32'h00000014: instruction=32'h00302023; //sw   x3, 0(x0)      --> 00302023
    32'h00000018: instruction=32'h00002303; //lw   x6, 0(x0)      --> 00002303
    32'h0000001c: instruction=32'h00208463; //beq  x1, x2, 8      --> 00208463
    32'h00000020: instruction=32'h00500113; //addi x2, x0, 5      --> 00500113
    32'h00000024: instruction=32'hfe208ee3; //beq  x1, x2, -4     --> fe208ee3
default instruction=32'd0;
endcase
end

endmodule