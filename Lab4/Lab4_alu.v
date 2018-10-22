module Lab4P2 (SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	//------Input and Output------
	input [9:0] SW;
	input [2:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	
	
	//------wires needed------
	wire [3:0] A = SW[3:0];
	wire [2:0] mode = SW[7:5];
	wire [7:0] DffQ;
	wire [3:0] B = DffQ[3:0];
	
	reg [7:0] ALUout;
	
	assign LEDR = DffQ;
	
	
	//------Get the ALUout------ 
	wire [7:0] adder_output0,adder_output1;
	
	full_adder4 fa0(
		.A(SW[3:0]), 
		.B(4'b0001), 
		.S(adder_output0[3:0]), 
		.cout(adder_output0[4])
	);
	
	full_adder4 fa1(
	
		.A(SW[3:0]), 
		.B(B), 
		.S(adder_output1[3:0]),
		.cout(adder_output1[4])
   	);
	
	always @(*)
		begin
			case (mode)
				3'b000: ALUout = {3'b000, adder_output0[4:0]};
				3'b001: ALUout = {3'b000, adder_output1[4:0]};
				3'b010: ALUout = A + B;
				3'b011: ALUout = {A|B, A^B};
				3'b100: ALUout = | A ? 8'b00000001:8'b00000000;
				3'b101: ALUout = B << A ;
				3'b110: ALUout = B >> A ;
				3'b111: ALUout = A * B;
				default: ALUout = 8'b00000000;	
			endcase
		end 
		
		
	//------The register------
	Register regi(
		.reset_n(SW[9]),
		.Clk(KEY[0]),
		.D(ALUout),
		.out(DffQ)
	);		
	
	
	//------All the Hexlight------
	HEX hex0(
		.out(HEX0[6:0]),
		.in(SW[3:0]));
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	HEX hex4(
		.out(HEX4[6:0]),
		.in(DffQ[3:0]));
	HEX hex5(
		.out(HEX5[6:0]),
		.in(DffQ[7:4]));
	
endmodule


module Register (reset_n,Clk,D,out);
	input reset_n;
	input Clk;
	input [7:0]D;
	output [7:0]out;
	reg [7:0]q;
	
	always @(posedge Clk)
	begin 
		if(reset_n == 1'b0)
			q <= 8'b00000000;
		else
			q <= D;
	end
	assign out = q;
endmodule	

module full_adder4(S,cout,A,B);
	input [3:0] A;
	input [3:0] B;
	output [3:0] S;
	output cout;
	wire w1,w2,w3;
	
	full_adder_single fa1(
		.A(A[0]),
		.B(B[0]),
		.cin(0),
		.S(S[0]),
		.cout(w1)
	);
	
	full_adder_single fa2(
		.A(A[1]),
		.B(B[1]),
		.cin(w1),
		.S(S[1]),
		.cout(w2)
	);
	
	full_adder_single fa3(
		.A(A[2]),
		.B(B[2]),
		.cin(w2),
		.S(S[2]),
		.cout(w3)
	);
	
	full_adder_single fa4(
		.A(A[3]),
		.B(B[3]),
		.cin(w3),
		.S(S[3]),
		.cout(cout)
	);
endmodule

module full_adder_single(S,cout,A,B,cin);
	input A, B, cin;
	output S, cout;
	
	assign S = A^B^cin;
	assign cout = (A&B)|(cin&(A^B));
endmodule


module HEX(in,out);
	input [3:0]in;
	output reg [6:0]out;
	
	always @(in)
	begin
		case (in[3:0])
			4'h0:out = 7'b100_0000;
			4'h1:out = 7'b111_1001;
			4'h2:out = 7'b010_0100;
			4'h3:out = 7'b011_0000;
			4'h4:out = 7'b001_1001;
			4'h5:out = 7'b001_0010;
			4'h6:out = 7'b000_0010;
			4'h7:out = 7'b111_1000;
			4'h8:out = 7'b000_0000;
			4'h9:out = 7'b001_0000;
			4'hA:out = 7'b000_1000;
			4'hB:out = 7'b000_0011;
			4'hC:out = 7'b100_0110;
			4'hD:out = 7'b010_0001;
			4'hE:out = 7'b000_0110;
			4'hF:out = 7'b000_1110;
			default:out = 7'b111_1111;
		endcase
	end
endmodule