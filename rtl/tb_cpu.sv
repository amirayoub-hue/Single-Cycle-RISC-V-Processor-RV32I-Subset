`timescale 1ns/1ps
module tb_cpu;
    logic clk;
    logic rst;

 riscv_cpu dut (
     .clk(clk),
     .rst(rst)
 );

 always #5 clk = ~clk;
 integer i;
 initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_cpu);

        clk = 0;
        rst = 1;
        
        #12 rst = 0;

     #500;
        $display("==== Register File ====");
        for (i = 0; i < 16; i = i + 1) begin
            $display("x%0d = %0d", i, dut.u_rf.regs[i]);
        end

        $display("==== Data Memory ====");
        for (i = 0; i < 4; i = i + 1) begin
            $display("mem[%0d] = %0d", i, dut.u_dmem.mem[i]);
        end

        $finish;
    end
endmodule
