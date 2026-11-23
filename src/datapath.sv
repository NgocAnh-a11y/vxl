module datapath (input logic clk,
                 input logic rst,
                 input logic pc_src,
					  input logic [1:0] reg_src,
					  input logic reg_write,
					  input logic [1:0] immsrc,
					  input logic alu_src,
					  input logic [2:0] alu_control,
					  input logic mem_write,
					  input logic mem_toreg,
					  input logic [31:0] instr,
					  input logic [31:0] read_data,
					  output logic [31:0] pc,
					  output logic [31:0] write_data,
					  output logic [31:0] alu_result,
					  output logic [3:0] flag);
	
logic [31:0] pc_plus4, pc_plus8;
logic [31:0] result;

logic [31:0] pc_mux;	
always_comb begin
    if (pc_src) begin
	    pc_mux = result;
	 end else begin
	    pc_mux = pc_plus4;
	 end
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
	    pc <= 32'b0;
	 end else begin
	    pc <= pc_mux;
	 end
end
				
adder u_4 ( .a(pc),
            .b(32'd4),
				.y(pc_plus4));
				
adder u_8 ( .a(pc_plus4),
            .b(32'd4),
				.y(pc_plus8));
		
logic [3:0] ra1, ra2;		
always_comb begin
    if (reg_src[1]) begin
	    ra2 = instr[15:12];
	 end else begin
	    ra2 = instr[3:0];
	 end
end

always_comb begin
    if (reg_src[0]) begin
	    ra1 = 4'd15;
	 end else begin
	    ra1 = instr[19:16];
	 end
end

logic [31:0] rd1, rd2;
regfile u_regfile ( .clk(clk),
                    .we3(reg_write),
						  .ra1(ra1),
						  .ra2(ra2),
						  .wa3(instr[15:12]),
						  .wd3(result),
						  .r15(pc_plus8),
						  .rd1(rd1),
						  .rd2(rd2));
		
logic [31:0] extimm;		
extend u_extend ( .instr(instr[23:0]),
                  .immsrc(immsrc),
						.extimm(extimm));
						
logic [31:0] out_shift;
shifter u_shift ( .in(rd2),
                  .shamt(instr[11:7]),
						.shtype(instr[6:5]),
						.out(out_shift));
	
logic [31:0] src_b;	
always_comb begin
    if (alu_src) begin
	    src_b = extimm;
	 end else begin
	    src_b = out_shift;
	 end
end

alu u_alu ( .a(rd1),
            .b(src_b),
				.alu_control(alu_control),
				.out(alu_result),
				.flag(flag));
			
assign write_data = rd2;
				  
always_comb begin
    if (mem_toreg) begin
	    result = read_data;
	 end else begin
	    result = alu_result;
	 end
end

endmodule
