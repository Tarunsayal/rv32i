module alu (
    //input  wire        clk,
    input  wire signed [7:0]  a, b,
    input  wire [2:0]  op,
    output reg  [7:0]  result,
    output reg         overflow
);

always @(*) begin
    case (op)
        3'd0: result = a + b;
        3'd1: result = a - b;
        3'd2: result = a * b;
        3'd3: result = a >> b;
        3'd4: result = a >>> b;
        3'd5: {overflow, result} = a + b; // explicitly know we will get lower 8 bits
        3'd6: result = a >>2;
        3'd7: result = a & b;
        default result =0;
        default overflow=0;
    endcase
end

endmodule