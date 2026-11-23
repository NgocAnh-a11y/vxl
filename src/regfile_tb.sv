module regfile_tb();

logic clk, we3;
logic [3:0] ra1, ra2, wa3;

logic [31:0] rd1, rd2, r15, wd3;

regfile dut ( .clk(clk),
              .we3(we3),
				  .ra1(ra1),
				  .ra2(ra2),
				  .wa3(wa3),
				  .wd3(wd3),
				  .r15(r15),
				  .rd1(rd1),
				  .rd2(rd2));
				  
initial begin
   forever #5 clk = ~clk;
end

initial begin
   clk = 0; we3 = 0; ra1 = 0; ra2 = 0; wa3 = 0; r15 = 0; wd3 = 0;
	// R1
	we3 = 1; wa3 = 4'd1; wd3 = 32'h1111_1111;
	@(posedge clk); #1;
	
	// R2
	we3 = 1; wa3 = 4'd2; wd3 = 32'h4444_4444;
	@(posedge clk); #1;
	
	// R7
	we3 = 1; wa3 = 4'd7; wd3 = 32'h4949_4949;
	@(posedge clk); #1;
	
	we3 = 0;
	
	ra1 = 4'd1; ra2 = 4'd2; #1;
	assert (rd1 == 32'h1111_1111 && rd2 == 32'h4444_4444)
	    else $error ("Loi doc rd1 va rd2");
		 
	ra1 = 4'd2; ra2 = 4'd7; #1;
	assert (rd1 == 32'h4444_4444 && rd2 == 32'h4949_4949)
	    else $error ("Loi doc rd1 va rd2");
		 
	ra1 = 4'd7; ra2 = 4'd7; #1;
	assert (rd1 == 32'h4949_4949 && rd2 == 32'h4949_4949)
	    else $error ("Loi doc rd1 va rd2 dong thoi");
		 
	// we3 = 0
	we3 = 0; wa3 = 4'd1; wd3 = 32'h8888_8888;
	@(posedge clk); #1;
	
	ra1 = 4'd1; #1;
	assert (rd1 == 32'h1111_1111)
	    else $error ("Loi doc rd1 khi we3 = 0");
		 
	// Test R15
	r15 = 32'h1211_1211;
	ra1 = 4'd15; ra2 = 4'd15; #1;
	assert (rd1 == 32'h1211_1211 && rd2 == 32'h1211_1211)
	    else $error ("Loi ghi du lieu thanh ghi R15");
		 
	r15 = 32'h1112_1112;
	ra1 = 4'd15; ra2 = 4'd15; #1;
	assert (rd1 == 32'h1112_1112 && rd2 == 32'h1112_1112)
	    else $error ("Loi ghi du lieu thanh ghi R15");
		 
	// Ghi vao thanh ghi R15
	we3 = 1; wa3 = 4'd15; wd3 = 32'h5678_9012;
	@(posedge clk); #1;
	
	we3 = 0;
	ra1 = 4'd1; ra2 = 4'd2; #1;
	assert (rd1 == 32'h1111_1111 && rd2 == 32'h4444_4444)
	    else $error ("Loi thay doi gia tri R1, R2");
		 
	$finish;
end

endmodule
