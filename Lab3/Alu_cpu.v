include "FullAdder4Bits.v";

module alu_cpu(A,B,mode,ALUout);
	input [3:0] A;
	input [3:0] B;
	input [2:0] mode;
	output [7:0] ALUout;
	wire [7:0] wire0;
	wire [7:0] wire1;
	wire [7:0] wire2;
	wire [7:0] wire3;
	wire [7:0] wire4;
	wire [7:0] wire5;
	wire [7:0] wire6;
	
	//Case0
	wire [4:0] temp0;
	fulladder4 fa0(A,4'b0001,1'b0,temp0[4],temp0[3:0]);
	assign wire0 = {3'b000,temp0};

	//Case1
	wire [4:0] temp1;
	fulladder4 fa1(A,B,1'b0, temp1[4],temp1[3:0]);
	assign wire1 = {3'b000,temp1};

	//Case2
	assign wire2 = A+B;

	//Case3
	assign wire3[3:0] = A^B;
	assign wire3[7:4] = A|B;

	//Case4
	assign wire4 = {7'b0000000, | {A,B}};

	//Case5
	assign wire5 = {A,B};
	
	//Case6
	assign wire6 = 8'b00000000;

	reg [7:0]out;
	always @(*)
	begin
		case(mode)
			3'b111: out = wire0;
			3'b110: out = wire1;
			3'b101: out = wire2;
			3'b100: out = wire3;
			3'b011: out = wire4;
			3'b010: out = wire5;
			default: out = wire6; 
		endcase
	end
	
	assign ALUout = out;

endmodule
