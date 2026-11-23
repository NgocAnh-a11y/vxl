module extend (input logic [23:0] instr,
               input logic [1:0] immsrc, // 00: add/sub; 01: ldr/str; 10: branch
					output logic signed [31:0] extimm);
					
always_comb begin
    case (immsrc)
	      2'b00: begin
			       extimm = {24'b0, instr[7:0]};
			end
			
			2'b01: begin
			       extimm = {20'b0, instr[11:0]};
			end
			
			2'b10: begin
			       extimm = {{6{instr[23]}}, instr[23:0], 2'b00};
			end
			
			default: begin
			       extimm = 32'bx;
			end
	 endcase
end

endmodule
