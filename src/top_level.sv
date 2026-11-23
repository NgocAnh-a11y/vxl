module top_level (input logic clk,
                  input logic rst,
						output logic [31:0] write_data,
						output logic [31:0] da,
						output logic mem_write);
						
logic [31:0] pc, instr, read_data;

imem u_imem ( .a(pc),
              .rd(instr));
				  
arm u_arm ( .clk(clk),
            .rst(rst),
				.instr(instr),
				.read_data(read_data),
				.pc(pc),
				.mem_write(mem_write),
				.alu_result(da),
				.write_data(write_data));
				
dmem u_dmem ( .clk(clk),
              .we(mem_write),
				  .wd(write_data),
				  .a(da),
				  .rd(read_data));
				  
endmodule
