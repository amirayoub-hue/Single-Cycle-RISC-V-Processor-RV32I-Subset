module dmem (
    input logic  clk , mem_read , mem_write ,
    input logic  [31:0] addr, wd ,
    output logic [31:0] rd 
);
    logic [31:0] mem [0:255];
    integer  i;

    initial begin
        for (i = 0 ;i<256 ;i=i+1 ) 
            mem[i] = 32'd0;
    end
    
    assign rd=mem_read ? mem[addr[9:2]] : 32'd0;

     always_ff @(posedge clk)begin
        if (mem_write)begin
            mem[addr[9:2]] <= wd;
        end
     end
endmodule