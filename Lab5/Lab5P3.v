module morse(SW,KEY,LEDR,CLOCK_50);
	input [2:0]SW;//chose S to Z
	input [1:0]KEY;//key0 is reset, key1 start display
	input CLOCK_50;
	output [0:0]LEDR;
		
	wire clock = CLOCK_50;
	wire load_n = KEY[1];
	wire reset = KEY[0];				
		
	wire e2;
	wire s,t,u,v,w,x,y,z;
		
	rdivider d0({3'b000,25'd24999999},reset,clock,e2);
	
	assign cenable = e2;
		
	shifter ss(cenable,13'b0000000010101,reset,clock,load_n,s);		
	shifter st(cenable,13'b0000000000111,reset,clock,load_n,t);		
	shifter su(cenable,13'b0000001110101,reset,clock,load_n,u);
	shifter sv(cenable,13'b0000111010101,reset,clock,load_n,v);
	shifter sw(cenable,13'b0000111011101,reset,clock,load_n,w);
	shifter sx(cenable,13'b0011101010111,reset,clock,load_n,x);
	shifter sy(cenable,13'b1110111010111,reset,clock,load_n,y);
	shifter sz(cenable,13'b0010101110111,reset,clock,load_n,z);
		
	reg out;

		always @(*)
		begin 
			case(SW[2:0])
				3'b000: out = s;
				3'b001: out = t;
				3'b010: out = u;
				3'b011: out = v;
				3'b100: out = w;
				3'b101: out = x;
				3'b110: out = y;
				3'b111: out = z; 
			endcase
		end			
assign LEDR[0] = out;
endmodule 



module shifter(cenable,load,reset,clock,load_n,l);
	input cenable,reset,clock,load_n;
	input [12:0]load;
	output l;
	wire [12:0]Loadval,outs;
	wire reset_n,in,ShiftRight,clk;
	
	assign Loadval[12:0] = load;
	assign reset_n = reset;
	assign clk = clock;
	assign ShiftRight = cenable;
	
	shifterbit s0(
	.load_val(Loadval[0]),
	.in(outs[1]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[0])
	);
	
	shifterbit s1(
	.load_val(Loadval[1]),
	.in(outs[2]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[1])
	);
	
	
	shifterbit s2(
	.load_val(Loadval[2]),
	.in(outs[3]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[2])
	);

	shifterbit s3(
	.load_val(Loadval[3]),
	.in(outs[4]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[3])
	);	


	shifterbit s4(
	.load_val(Loadval[4]),
	.in(outs[5]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[4])
	);	

	
	shifterbit s5(
	.load_val(Loadval[5]),
	.in(outs[6]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[5])
	);	
	
	
	shifterbit s6(
	.load_val(Loadval[6]),
	.in(outs[7]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[6])
	);	
	
	
	shifterbit s7(
	.load_val(Loadval[7]),
	.in(outs[8]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[7])
	);	
	
		shifterbit s8(
	.load_val(Loadval[8]),
	.in(outs[9]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[8])
	);	
	
	
	shifterbit s9(
	.load_val(Loadval[9]),
	.in(outs[10]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[9])
	);	
	
	
	shifterbit s10(
	.load_val(Loadval[10]),
	.in(outs[11]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[10])
	);	
	
	
	shifterbit s11(
	.load_val(Loadval[11]),
	.in(outs[12]),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[11])
	);	
	

	
	shifterbit s12(
	.load_val(Loadval[12]),
	.in(1'b0),
	.shift(ShiftRight),
	.load_n(load_n),
	.clock(clk),
	.reset_n(reset_n),
	.out(outs[12])
	);	
	
	assign l = outs[0];

endmodule
	

module shifterbit (load_val,in,shift,load_n,clock,reset_n,out);
   	input load_val, in, shift, load_n, clock, reset_n;
	output out;
	reg q;
	wire w1,w2,d;
	assign w1 = q;
	assign out = w1;
	
	always @(posedge clock) 
	begin
		if(reset_n == 1'b0)
			q <= 0;
		else 
			q <= d;
		end
	
	mux2to1 m01(
	.x(w1),
	.y(in),
	.s(shift),
	.m(w2)
	);
	
	mux2to1 m02(
	.x(load_val),
	.y(w2),
	.s(load_n),
	.m(d)
	);
		
endmodule
	

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
endmodule


module rdivider(load,reset,clock,rd);
	input [27:0] load;
	input clock;
	input reset;
	output rd;
	reg [27:0] q;
	
	always @(posedge clock) 
		begin
			if (reset == 1'b0) 
				q <= 0; 
			else begin
				if(q == 0) 
					q <= load;
				else
					q <= q - 1'b1; 
				end
		end
	assign rd = (q == 0) ? 1 : 0;			
endmodule 

