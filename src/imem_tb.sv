module imem_tb();

logic [31:0] a, rd;

imem dut ( .a(a),
           .rd(rd));
			  
initial begin
    a = 32'd0; #10;
	 assert (rd == 32'hE3A01005)
	        else $error ("Loi o byte 0");
			  
	 a = 32'd4; #10;
	 assert (rd == 32'hE3A0200A)
	        else $error ("Loi o byte 4");
			  
	 a = 32'd8; #10;
	 assert (rd == 32'hE0821003)
	        else $error ("Loi o byte 8");
			  
	 a = 32'd12; #10;
	 assert (rd == 32'h11111111)
	        else $error ("Loi o byte 12");
			  
	 a = 32'd16; #10;
	 assert (rd == 32'h22222222)
	        else $error ("Loi o byte 16");
			  
	 a = 32'd5; #10;
	 assert (rd == 32'hE3A0200A)
	        else $error ("Loi o byte 5");
			  
	 a = 32'd6; #10;
	 assert (rd == 32'hE3A0200A)
	        else $error ("Loi o byte 6");
			  
	 a = 32'd7; #10;
	 assert (rd == 32'hE3A0200A)
	        else $error ("Loi o byte 7");
			  
	 $finish;
end

endmodule
