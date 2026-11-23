module dmem_tb();

logic clk;
logic we;

logic [31:0] a, wd;
logic [31:0] rd;

dmem dut ( .clk(clk),
           .we(we),
			  .wd(wd),
			  .a(a),
			  .rd(rd));
			  
initial begin
    forever #5 clk = ~clk;
end

initial begin
    clk = 0; we = 0; a = 0; wd = 0;
	 
	 // ghi du lieu
	 #10; we = 1;
	 a = 32'd20;
	 wd = 32'h1111_2222;
	 
	 #10;
	 a = 32'd24;
	 wd = 32'h2222_1111;
	 
	 // doc du lieu
	 #10; we = 0;
	 a = 32'd20;
	 #1;
	 assert (rd == 32'h1111_2222)
	        else $error ("Loi doc tai byte 20");
			  
	 #10;
	 a = 32'd24; #1;
	 assert (rd == 32'h2222_1111)
	        else $error ("Loi doc tai byte 24");
			  
	 #10; a = 32'd22;
	 #1;
	 assert (rd == 32'h1111_2222)
	        else $error ("Loi doc tai byte 22");
			  
	 $finish;
end

endmodule
