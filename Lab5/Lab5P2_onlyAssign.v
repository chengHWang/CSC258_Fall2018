module Lab4P2(SW,KEY, CLOCK_50, HEX0);
	input[3:0] SW;// SW[1:0] = select, SW[2] = enable, SW[3] = reset_n, SW[9:6] = d;
	input [0:0] KEY; KEY[0] = par_load;
	input CLOCK_50;
	output HEX0;
	
	
	wire [3:0] qout;
	
	counter_test c(KEY[0], SW[9:6], SW[1:0], SW[2], SW[3], CLOCK_50, qout);

		
	hex_decoder h0(
		.out(HEX0),
		.in(qout)
		);
endmodule

module counter_test(par_load,d,select, enable, reset_n,clock,qout);
	input[1:0] select;
	input enable, reset_n;
	input clock;
	input [3: 0] d;
	input par_load;
	output [3:0] qout;
	
	wire [27:0] load;
	wire en;
	
	speedDetermine s0 (
		.select(select[1:0]),
		.out(load));
	
	RateDivider r0 (
		.enable(enable),
		.load(load),
		.clock(clock),
		.reset_n(reset_n),
		.q(en));
		
	DisplayCounter d0(
		.enable(en),
		.par_load(par_load),
		.d(d),
		.clock(clock),
		.reset_n(reset_n),
		.q(qout)
		);

endmodule

module speedDetermine(select,out);
	input [1:0] select;
	output reg [27:0] out;
	
	always @(*)
	begin
		case (select[1:0])
			2'b00: out = 28'd0;
			2'b01: out = 28'd49_999_999;
			2'b10: out = 28'd99_999_999;
			2'b11: out = 28'd199_999_999;
			default: out = 28'd0;
		endcase
	end

endmodule

module RateDivider(enable, load, clock, reset_n,q);
	input enable,clock,reset_n;
	input [27:0] load;
	output q;
	
	reg [27:0] out;
	
	always@(posedge clock)
	begin
		if (reset_n == 1'b0)
			out <= load;
		else if (enable == 1'b1)
			begin
				if (out == 28'd0)
					out <= load;
				else
					out <= out - 1'b1;
			end
	end
	
	assign q = (out == 28'd0) ? 1 : 0;
	
endmodule

module DisplayCounter(enable,par_load ,d, clock, reset_n, q);
	input enable, clock, reset_n;
	input par_load;
	input [3:0] d;
	output reg [3:0] q;
	
	always @(posedge clock)
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else if (par_load == 1'b1)
			q <= d;
		else if (enable == 1'b1)
			begin
				if (q == 4'b1111)
					q<=0;
				else
					q <= q + 1'b1;
			end
	end
	
endmodule

//HEX
module hex_decoder(out, in);
	input [9:0] in;
	output [6:0] out;
	
	zero u0(
		.c3(in[3]),
		.c2(in[2]),
		.c1(in[1]),
		.c0(in[0]),
		.m(out[0])
		);
		
	one u1(
		.c3(in[3]),
		.c2(in[2]),
		.c1(in[1]),
		.c0(in[0]),
		.m(out[1])
		);
		
	two u2(
		.c3(in[3]),
		.c2(in[2]),
		.c1(in[1]),
		.c0(in[0]),
		.m(out[2])
		);
		
	three u3(
		.c3(in[3]),
		.c2(in[2]),
		.c1(in[1]),
		.c0(in[0]),
		.m(out[3])
		);
		
	four u4(
		.c3(in[3]),
		.c2(in[2]),
		.c1(in[1]),
		.c0(in[0]),
		.m(out[4])
		);
		
	five u5(
		.c3(in[3]),
		.c2(in[2]),
		.c1(in[1]),
		.c0(in[0]),
		.m(out[5])
		);
		
	six u6(
		.c3(in[3]),
		.c2(in[2]),
		.c1(in[1]),
		.c0(in[0]),
		.m(out[6])
		);
endmodule

module zero(c3, c2, c1, c0, m);
	input c3;
	input c2;
	input c1;
	input c0;
	output m;
	
	assign m = ~c3 & ~c2 & ~c1 & c0 | ~c3 & c2 & ~c0 & ~c1 | c2 & c3 & ~c1 & c0 | ~c2 & c3 & c0 & c1;
endmodule

module one(c3, c2, c1, c0, m);
	input c3;
	input c2;
	input c1;
	input c0;
	output m;
	
	assign m = ~c0 & ~c1 & c3 & c2 | c2 & ~c3 & c0 & ~c1 | c3 & c0 & c1 | ~c0 & c1 & c2;
endmodule

module two(c3, c2, c1, c0, m);
	input c3;
	input c2;
	input c1;
	input c0;
	output m;
	
	assign m = c3 & c2 & ~c0 & ~c1 | c2 & c3 & c1 | ~c2 & ~c3 & ~c0 & c1;
endmodule

module three(c3, c2, c1, c0, m);
	input c3;
	input c2;
	input c1;
	input c0;
	output m;
	
	assign m = ~c0 & ~c1 & c2 & ~c3 | c0 & c1 & c2 | c0 & ~c1 & ~ c2 & ~c3 | ~c0 & c1 & ~c2 & c3;
endmodule

module four(c3, c2, c1, c0, m);
	input c3;
	input c2;
	input c1;
	input c0;
	output m;
	
	assign m = c0 & ~c3 | c2 & ~c3 & ~c1 | c0 & ~c1 & ~c2;
endmodule

module five(c3, c2, c1, c0, m);
	input c3;
	input c2;
	input c1;
	input c0;
	output m;
	
	assign m = c2 & c3 & c0 & ~c1 | ~c2 & ~c3 & c1 | ~c2 & ~c3 & c0 | c0 & c1 & ~c3;
endmodule

module six(c3, c2, c1, c0, m);
	input c3;
	input c2;
	input c1;
	input c0;
	output m;
	
	assign m = ~c2 & ~c3 & ~c1 | c2 & ~c3 & c0 & c1 | c2 & c3 & ~c0 & ~c1;
endmodule