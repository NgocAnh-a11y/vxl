module cond_logic (input logic clk,
                   input logic rst,
                   input logic [3:0] cond,
                   input logic [3:0] flag,
						 input logic [1:0] flag_w,
						 input logic pcs,
						 input logic regw,
						 input logic memw,
						 output logic pc_src,
						 output logic reg_write,
						 output logic mem_write);
						 
logic [1:0] flag_write;
logic cond_ex;
logic [3:0] flags;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
	    flags <= 4'b00;
	 end else begin
	    if (flag_write[1]) begin
		    flags[3:2] <= flag[3:2]; // n, z
		 end else if (flag_write[0]) begin
		    flags[1:0] <= flag[1:0]; // c, v
		 end
	 end
end

logic n, z, c, v;
assign {n, z, c, v} = flags;

always_comb begin
    case (cond)
	      4'b0000: cond_ex = z; // EQ
			4'b1110: cond_ex = 1'b1;
			default: cond_ex = 1'b0;
	 endcase
end

assign flag_write = flag_w & {2{cond_ex}};
assign pc_src = pcs & cond_ex;
assign reg_write = regw & cond_ex;
assign mem_write = memw & cond_ex;

endmodule
