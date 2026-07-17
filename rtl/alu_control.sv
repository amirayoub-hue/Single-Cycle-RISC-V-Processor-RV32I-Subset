module alu_control (
    input logic [1:0] alu_op ,
    input logic [2:0] funct3 ,
    input logic  funct7_5, 
    output logic [3:0] alu_ctrl
);
    always_comb begin 
        case (alu_op)
            2'b00: alu_ctrl = 4'b0000; // lw/sw -> ADD
            2'b01: alu_ctrl = 4'b0001; // beq   -> SUB
            2'b10: begin               // R-Type
                case (funct3)
                    3'b000:  alu_ctrl = funct7_5 ? 4'b0001 : 4'b0000; // sub/add
                    3'b111:  alu_ctrl = 4'b0010; // and
                    3'b110:  alu_ctrl = 4'b0011; // or
                    3'b010:  alu_ctrl = 4'b0100; // slt
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            2'b11: begin               // I-Type (addi)
                case (funct3)
                    3'b000:  alu_ctrl = 4'b0000; // addi
                    default: alu_ctrl = 4'b0000;
                endcase
            end
            default: alu_ctrl = 4'b0000;

        endcase
        
    end
endmodule