module top_level_tb();

logic clk, rst;
logic [31:0] write_data, da;
logic mem_write;

top_level dut ( .clk(clk),
                .rst(rst),
					 .write_data(write_data),
					 .da(da),
					 .mem_write(mem_write));

initial begin
   clk = 0;
   forever #5 clk = ~clk;
end

initial begin
   rst = 1;
   #22; 
   rst = 0;

   #500;
	$stop;
end

endmodule
