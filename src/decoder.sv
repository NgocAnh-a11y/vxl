module decoder (input logic [1:0] op,
                input logic [5:0] funct,
					 input logic [3:0] rd,
					 output logic [1:0] flag_w,
					 output logic pcs,
					 output logic regw,
					 output logic memw,
					 output logic mem_toreg,
					 output logic alu_src,
					 output logic [1:0] immsrc,
					 output logic [1:0] reg_src,
					 output logic [2:0] alu_control);
					 
logic branch, alu_op;

always_comb begin
    case (op)
	      2'b00: begin
			      regw = (funct[4:1] == 4'b1010) ? 1'b0 : 1'b1;
					// data-processing with immediate
			      if (funct[5]) begin
					   reg_src = 2'b00; memw = 0; branch = 0;
						mem_toreg = 0; alu_src = 1; immsrc = 2'b00; alu_op = 1;
					// with register
					end else begin
					   reg_src = 2'b00; memw = 0; branch = 0;
						mem_toreg = 0; alu_src = 0; immsrc = 2'b00; alu_op = 1;
					end
			end
					
			2'b01: begin
			      // LDR
					if (funct[0]) begin
					   reg_src = 2'b00; regw = 1; memw = 0; branch = 0;
						mem_toreg = 1;
					   if (funct[5]) begin
					      alu_src = 0;
						   immsrc = 2'b01;
						   alu_op = 0;
						end else begin
					      alu_src = 1;
						   immsrc = 2'b01;
						   alu_op = 0;
						end
					// STR
					end else begin
				      reg_src = 2'b10; regw = 0; memw = 1; branch = 0;
						mem_toreg = 1'bx;
						if (funct[5]) begin
					      alu_src = 0;
						   immsrc = 2'b01;
						   alu_op = 0;
						end else begin
					      alu_src = 1;
						   immsrc = 2'b01;
						   alu_op = 0;
						end
					end
			end
			
			2'b10: begin
			      reg_src = 2'b01; regw = 0; memw = 0; branch = 1;
					mem_toreg = 0; alu_src = 1; immsrc = 2'b10; alu_op = 0;
			end
			
			default: begin
			      reg_src = 2'bx; regw = 1'bx; memw = 1'bx; branch = 1'bx;
					mem_toreg = 1'bx; alu_src = 1'bx; immsrc = 2'bx; alu_op = 1'bx;
			end
	 endcase
end

always_comb begin
    if (alu_op && op == 2'b00) begin
	    case (funct[4:1])
		      4'b0100: begin // ADD
				        alu_control = 3'b000;
						  flag_w = funct[0] ? 2'b11 : 2'b00;
				end
				
				4'b0010: begin // SUB
				        alu_control = 3'b001;
						  flag_w = funct[0] ? 2'b11 : 2'b00;
				end
				
				4'b1010: begin // CMP
				        alu_control = 3'b001;
						  flag_w = 2'b11;
				end
				
				4'b0000: begin // AND
				        alu_control = 3'b010;
						  flag_w = funct[0] ? 2'b10 : 2'b00;
				end
				
				4'b1100: begin // ORR
				        alu_control = 3'b011;
						  flag_w = funct[0] ? 2'b10 : 2'b00;
				end
				
				4'b1101: begin // MOV
				        alu_control = 3'b100;
						  flag_w = funct[0] ? 2'b10 : 2'b00;
				end
				
				default: begin
				        alu_control = 3'b000;
						  flag_w = 2'b00;
				end
		 endcase
	 end else if (op == 2'b01) begin
		 alu_control = 3'b000; // LDR
		 flag_w = 2'b00;
	 end else if (op == 2'b10) begin
	    alu_control = 3'b000; // B
		 flag_w = 2'b00;
	 end else begin
	    alu_control = 3'b000;
		 flag_w = 2'b00;
	 end
end

assign pcs = branch | (regw & (rd == 4'b1111));

endmodule
