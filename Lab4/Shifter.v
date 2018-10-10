module shifter(SW,KEY,LEDR)




module shifterbit(load_n,load_v,in,shift,clk,reset_n,out);
	input load_n;
	input load_v;
	input in;
	input shift;
	input clk;
	input reset_n;
	output out;
	
	wire w1,w2;

	mux2to1 m1(out,in,shift,w1);
	mux2to1 m2(load_v,w1,load_n,w2);
	dff d0(w2,clk,reset_n,out);
endmodule




//------------------------help method-------------------------
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

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
    assign m = s & y | ~s & x;
endmodule