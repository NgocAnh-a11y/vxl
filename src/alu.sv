module alu (input logic [31:0] a, b,
            input logic [2:0] alu_control, // ADD, STR, LDR, B: 000; SUB, CMP: 001; AND: 010
				output logic [31:0] out, // ORR: 011; MOV, LSL, LSR: 100
				output logic [3:0] flag);
				
logic [32:0] add_sub;
logic [31:0] b_mux;
logic n, z, c, v;

assign b_mux = (alu_control == 3'b001) ? ~b : b;
assign add_sub = {1'b0, a} + {1'b0, b_mux} + ((alu_control == 3'b001) ? 1'b1 : 1'b0);

always_comb begin
	 out = 32'b0;
	 c = 1'b0;
	 v = 1'b0;
	 
    case (alu_control)
	      3'b000: begin
			out = add_sub[31:0];
			c = add_sub[32];
			v = ~(a[31] ^ b[31]) & (out[31] ^ a[31]);
			end
			
			3'b001: begin
			out = add_sub[31:0];
			c = add_sub[32];
			v = (a[31] ^ b[31]) & (out[31] ^ a[31]);
			end
			
			3'b010: begin
			out = a & b;
			end
			
			3'b011: begin
			out = a | b;
			end
			
			3'b100: begin
			out = b;
			end
			
			default: begin
			out = 32'b0;
			end
	 endcase
	 
	 n = out[31];
	 z = (out == 32'b0);
	 flag = {n, z, c, v};
end

endmodule
