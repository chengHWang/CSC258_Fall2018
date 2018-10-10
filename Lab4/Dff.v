//The D flip flop module
module dff(d,clk,reset_n,q);
	input d;
	input clk;
	input reset_n;
	output q;

	reg tempq;
	always @(posedge clk)
	begin
		if(reset_n == 1'b0)
			tempq <= 0;
		else
			tempq <= d;
	end
	assign q = tempq;
endmodule