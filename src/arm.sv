module arm (input logic clk,
            input logic rst,
				input logic [31:0] instr,
				input logic [31:0] read_data,
				output logic [31:0] pc,
				output logic mem_write,
				output logic [31:0] alu_result,
				output logic [31:0] write_data);
				
logic pc_src, reg_write, alu_src, mem_toreg;
logic [1:0] reg_src, immsrc;
logic [2:0] alu_control, flag;
logic [31:12] instr_ctl;
assign instr_ctl = instr[31:12];
				
datapath u_data ( .clk(clk),
                  .rst(rst),
						.pc_src(pc_src),
						.reg_src(reg_src),
						.reg_write(reg_write),
						.immsrc(immsrc),
						.alu_src(alu_src),
						.alu_control(alu_control),
						.mem_write(mem_write),
						.mem_toreg(mem_toreg),
						.instr(instr),
						.read_data(read_data),
						.pc(pc),
						.write_data(write_data),
						.alu_result(alu_result),
						.flag(flag));
						
control_unit u_ctl ( .clk(clk),
                     .rst(rst),
							.instr(instr_ctl),
							.flag(flag),
							.pc_src(pc_src),
							.mem_toreg(mem_toreg),
							.mem_write(mem_write),
							.alu_control(alu_control),
							.alu_src(alu_src),
							.immsrc(immsrc),
							.reg_src(reg_src),
							.reg_write(reg_write));
							
endmodule
