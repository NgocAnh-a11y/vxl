module control_unit (input logic clk,
                     input logic rst,
							input logic [31:12] instr,
							input logic [3:0] flag,
							output logic pc_src,
							output logic mem_toreg,
							output logic mem_write,
							output logic [2:0] alu_control,
							output logic alu_src,
							output logic [1:0] immsrc,
							output logic [1:0] reg_src,
							output logic reg_write);
							
logic pcs, regw, memw;
logic [1:0] flag_w;

decoder u_decode ( .op(instr[27:26]),
                   .funct(instr[25:20]),
						 .rd(instr[15:12]),
						 .flag_w(flag_w),
						 .pcs(pcs),
						 .regw(regw),
						 .memw(memw),
						 .mem_toreg(mem_toreg),
						 .alu_src(alu_src),
						 .immsrc(immsrc),
						 .reg_src(reg_src),
						 .alu_control(alu_control));
						 
cond_logic u_cond ( .clk(clk),
                    .rst(rst),
						  .cond(instr[31:28]),
						  .flag(flag),
						  .flag_w(flag_w),
						  .pcs(pcs),
						  .regw(regw),
						  .memw(memw),
						  .pc_src(pc_src),
						  .reg_write(reg_write),
						  .mem_write(mem_write));
						  
endmodule
