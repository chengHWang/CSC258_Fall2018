module shifter(SW,KEY,LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	
	wire [7:0] Q;
	wire ASR = KEY[3];
	wire [7:0] load_value = SW[7:0];
	wire load_n = KEY[1]; //active low
	wire clk = KEY[0];
	wire shiftR = KEY[2];
	wire reset_n = SW[9];
	assign LEDR = Q; 

	shifter8bits mainshifter(load_n,load_value,ASR,shiftR,clk,reset_n,Q);

endmodule



module shifter8bits(load_n,load_v,ASR,shiftR,clk,reset_n,Q);
	input load_n;
	input [7:0] load_v;
	input ASR;
	input shiftR;
	input clk;
	input reset_n;
	output [7:0] Q;

	//The first mux2to1
	mux2to1 m0(1'b0,Q[7],ASR,w0);
	
	//Here start 8 ShifterBits
	shifterbit sb7(load_n,load_v[7],w0,shiftR,clk,reset_n,Q[7]);
	shifterbit sb6(load_n,load_v[6],Q[7],shiftR,clk,reset_n,Q[6]);
	shifterbit sb5(load_n,load_v[5],Q[6],shiftR,clk,reset_n,Q[5]);
	shifterbit sb4(load_n,load_v[4],Q[5],shiftR,clk,reset_n,Q[4]);
	shifterbit sb3(load_n,load_v[3],Q[4],shiftR,clk,reset_n,Q[3]);
	shifterbit sb2(load_n,load_v[2],Q[3],shiftR,clk,reset_n,Q[2]);
	shifterbit sb1(load_n,load_v[1],Q[2],shiftR,clk,reset_n,Q[1]);
	shifterbit sb0(load_n,load_v[0],Q[1],shiftR,clk,reset_n,Q[0]);
endmodule



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
			tempq <= 1'b0;
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