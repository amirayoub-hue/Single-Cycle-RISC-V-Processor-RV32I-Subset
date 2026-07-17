module control (
    input logic [6:0] opcode ,
    output logic reg_write , alu_src, mem_read, mem_write, mem_to_reg, branch, jump , 
    output logic [1:0] alu_op
);

always_comb begin
    reg_write  = 1'b0;
    alu_src    = 1'b0;
    mem_read   = 1'b0;
    mem_write  = 1'b0;
    mem_to_reg = 1'b0;
    branch     = 1'b0;
    jump       = 1'b0;
    alu_op     = 2'b00;

    case (opcode)
        7'b0110011: begin // R-Type
            reg_write = 1'b1;
            alu_op    = 2'b10;
                end
        7'b0010011: begin // addi
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b11;
                end
        7'b0000011: begin // lw
            reg_write  = 1'b1;
            alu_src    = 1'b1;
            mem_read   = 1'b1;
            mem_to_reg = 1'b1;
            alu_op     = 2'b00; // add for address
                end
        7'b0100011: begin // sw
            alu_src   = 1'b1;
            mem_write = 1'b1;
            alu_op    = 2'b00; // add for address  
                end
        7'b1100011: begin // beq
            branch = 1'b1;
            alu_op = 2'b01; //  sub for comparsion
                end
        7'b1101111: begin // jal
            reg_write = 1'b1;
            jump      = 1'b1;
                end 
    endcase
end
endmodule