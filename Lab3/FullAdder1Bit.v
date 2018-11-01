include"xor_gate.v";
include"mux2to1.v";
module fulladder1(Ci,a,b,s,Co);
    	input Ci,a,b;
    	output s,Co;	
	assign s = Ci^a^b;
	assign Co = (Ci&a)|(Ci&b)|(a&b);
endmodule