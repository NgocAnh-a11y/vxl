module shifter (input logic [31:0] in,
                input logic [4:0] shamt,
					 input logic [1:0] shtype, // 00: LSL, 01: LSR
					 output logic [31:0] out);
					 
always_comb begin
    out = 32'b0;
	 case (shtype)
	      2'b00: begin
			       out = in << shamt;
			end
			
			2'b01: begin
			       out = in >> shamt;
			end
			
			2'b10: begin
			       out = $signed(in) >>> shamt;
			end
			
			2'b11: begin
			       out = (in >> shamt) | (in << (32 - shamt));
			end
			
			default: begin
			       out = 32'b0;
			end
	 endcase
end

endmodule
