module L4P4(SW, KEY, LEDR);
	input [9:0]SW; // SW9 = reset_n, SW7-0 = loadval7-0
	input [3:0] KEY; // key1 = load_n, key2 = ShiftRight,key3 =  ASR, key 0 = clk
	output [7:0] LEDR;
	wire w;

	shift8bits s(
		.LoadVal(SW[7:0]),
		.Load_n(KEY[1]),
		.ShiftRight(KEY[2]),
		.ASR(KEY[3]),
		.clk(KEY[0]),
		.reset_n(SW[9]),
		.q(LEDR[7:0])
	);

endmodule

module shift8bits(LoadVal, Load_n, ShiftRight, ASR, clk, reset_n, q);
	input [7:0] LoadVal;
	input Load_n, ShiftRight, ASR, reset_n, clk;
	output [7:0] q;
	wire w;


	mux asr(
		.x(1'b0),
		.y(q[7]),
		.s(ASR),
		.m(w)
	);


	shifter1bit s7(
		.out (q[7]),
		.load_val(LoadVal[7]),
		.in(w),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	shifter1bit s6(
		.out (q[6]),
		.load_val(LoadVal[6]),
		.in(q[7]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	shifter1bit s5(
		.out (q[5]),
		.load_val(LoadVal[5]),
		.in(q[6]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	shifter1bit s4(
		.out (q[4]),
		.load_val(LoadVal[4]),
		.in(q[5]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	shifter1bit s3(
		.out (q[3]),
		.load_val(LoadVal[3]),
		.in(q[4]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	shifter1bit s2(
		.out (q[2]),
		.load_val(LoadVal[2]),
		.in(q[3]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);


	shifter1bit s1(
		.out (q[1]),
		.load_val(LoadVal[1]),
		.in(q[2]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

	shifter1bit s0(
		.out (q[0]),
		.load_val(LoadVal[0]),
		.in(q[1]),
		.shift(ShiftRight),
		.load_n(Load_n),
		.clk(clk),
		.reset_n(reset_n)
	);

endmodule


module shifter1bit(out, load_val, in, shift, load_n, clk, reset_n);
	input load_val;
	input in;
	input shift;
	input load_n;
	input reset_n;
	input clk;
	output out;

	wire m;
	wire n;

	mux M1(
		.x(load_val),
		.y(m),
		.s(load_n),
		.m(n)
	);

	mux M2(
		.x(out),
		.y(in),
		.s(shift),
		.m(m)
	);



	filpflop F0(
		.d(n),
		.q(out),
		.clock(clk),
		.reset_n(reset_n)
	);
endmodule

// dff
module filpflop(d, q, clock, reset_n);
	input d;
	input clock;
	input reset_n;
	output q;
	
	reg q;
	
	always @(posedge clock)
	begin
		if (reset_n == 1'b0)
			q <= 1'b0;
		else
			q <= d;
	end
endmodule	

// mux
module mux(x, y, s, m);
    input x;
    input y;
    input s;
    output m;
  
    assign m = s & y | ~s & x;
endmodule