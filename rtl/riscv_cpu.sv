module riscv_cpu (
    input logic clk , rst 
);
// pc 
logic [31:0] pc, pc_plus4 , pc_next;
assign pc_plus4 = pc + 32'd4;

always_ff @( posedge clk or posedge rst ) begin
    if(rst)
    pc <= 32'd0;
    else
    pc <= pc_next;
end
// instruction fetch
logic [31:0] instr;
imem u_imem(
    .addr(pc),
    .instr(instr)
);
// instruction fields
logic [6:0] opcode;
logic [4:0] rd , rs1 ,rs2 ;
logic [2:0] funct3;
logic f7_5;

assign opcode = instr[6:0];
assign rd     = instr[11:7];
assign funct3 = instr[14:12];
assign rs1    = instr[19:15];
assign rs2    = instr[24:20];
assign f7_5   = instr[30];

//control
logic reg_write , alu_src , mem_read , mem_write , mem_to_reg ,branch ,jump ;
logic [1:0] alu_op;

control u_ctrl (
     .opcode(opcode),
     .reg_write(reg_write),
     .alu_src(alu_src),
     .mem_read(mem_read),
     .mem_write(mem_write),
     .mem_to_reg(mem_to_reg),
     .branch(branch),
     .jump(jump),
     .alu_op(alu_op)
);
//Register file 
logic [31:0] rd1 , rd2 , wb_data;
regfile u_rf(
        .clk(clk),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wb_data),
        .rd1(rd1),
        .rd2(rd2)
);
//immediate
logic [31:0] imm;
imm_gen u_imm(
       .instr(instr),
       .imm(imm)
);

//alu
logic [3:0] alu_ctrl;
logic [31:0] alu_b, alu_result;
logic  zero;
assign alu_b = alu_src ? imm:rd2;

alu_control u_aluctrl(
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7_5(f7_5),
        .alu_ctrl(alu_ctrl)
);
 alu u_alu(
        .a(rd1),
        .b(alu_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
 );

//data memory
logic [31:0] mem_data;
dmem u_dmem(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .wd(rd2),
        .rd(mem_data)
);

//write back
assign wb_data = jump  ? pc_plus4 : mem_to_reg ? mem_data: alu_result ;
// next pc 
logic take_branch;
assign take_branch= branch & zero ;
assign pc_next =(take_branch | jump ) ? (pc + imm): pc_plus4;
endmodule