module alu(
    input logic [31:0] a ,b ,
    input logic [3:0]  alu_ctrl,
    output logic [31:0] result ,
    output logic  zero
);
always_comb begin
    case (alu_ctrl)
    4'b0000: result = a+b;
    4'b0001: result = a-b;
    4'b0010: result = a & b;
    4'b0011: result = a | b ;
    4'b0100: result =($signed(a)<$signed(b)) ? 32'd1 : 32'd0;
        default: result = 32'd0;
    endcase
end
assign zero =(result == 32'd0);
endmodule
