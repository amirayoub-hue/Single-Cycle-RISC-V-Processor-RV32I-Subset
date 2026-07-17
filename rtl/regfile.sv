module regfile (
    input  logic  clk, rst ,we,
    input  logic [4:0]  rs1, rs2,  rd, //Cuz we have 32bit reg then  2 power 5 
    input  logic [31:0] wd,
    output logic [31:0] rd1, rd2  //read data from rs1 and rs2
);
    logic [31:0] regs [0:31];
    integer i;

    assign rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'd0;
        end else if (we && rd != 5'd0) begin
            regs[rd] <= wd;
        end
    end
endmodule
