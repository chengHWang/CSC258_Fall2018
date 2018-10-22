module alu(SW,KEY0,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
	//input & output  
	input [9:0] SW;	// SW[3:0] = A; SW[9] = reset_n; SW[7:5] = function_input
	input KEY0;	// KEY[0] = clk
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [7:0] LEDR;


	//necessary wires
	wire [7:0] ALUout;
	reg [7:0] DffQ;
	wire [3:0] A = SW[3:0]; 
	wire [3:0] B = DffQ[3:0];
	wire [2:0] mode = SW[7:5];
	wire reset = SW[9];
	wire clock = KEY0;

	
	//Using help module Hexlight 
	HexLight hexl0(HEX0,A);
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	HexLight hexl4(HEX4,B);
	HexLight hexl5(HEX5,DffQ[7:4]);

	
	assign LEDR = DffQ;


	//Get all the output ready
	alu_cpu cpu(A,B,mode,ALUout);


	//the register
	always @(posedge clock)
	begin
		if (reset == 1'b0)
			DffQ <=  8'b00000000;
		else
			DffQ <= ALUout;
	end
endmodule







module alu_cpu(A,B,mode,ALUout);
	input [3:0] A;
	input [3:0] B;
	input [2:0] mode;
	output [7:0] ALUout;

	//all the outputs for each mode
	wire [7:0] wire0;
	wire [7:0] wire1;
	wire [7:0] wire2;
	wire [7:0] wire3;
	wire [7:0] wire4;
	wire [7:0] wire5;
	wire [7:0] wire6;
	wire [7:0] wire7;
	wire [7:0] wire8;

	//Case0
	//we will use help module fullAdder4 here
	wire [4:0] temp0;
	fulladder4 fa0(A,4'b0001,1'b0,temp0[4],temp0[3:0]);
	assign wire0 = {3'b000,temp0};

	//Case1
	//we will use help module fullAdder4 here
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
	assign wire5 = B<<A;

	//Case6
	assign wire6 = B>>A;

	//Case7
	assign wire7 = A*B;

	//Case8
	assign wire8 = 8'b00000000;

	reg [7:0]out;
	always @(*)
	begin
		case(mode)
			3'b000: out = wire0;
			3'b001: out = wire1;
			3'b010: out = wire2;
			3'b011: out = wire3;
			3'b100: out = wire4;
			3'b101: out = wire5;
			3'b110: out = wire6;
			3'b111: out = wire7;
			default: out = wire8; 
		endcase
	end
	assign ALUout = out;
endmodule





//----------------------------help modules-----------------------------------
module HexLight(Output,Input);
module HexLight(out,in);
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




module fulladder4(InputA,InputB,Ci,Co,Output);
    input [3:0] InputA;
    input [3:0] InputB;   
    input Ci;
    input Co;
    output [3:0] Output;
    wire w1,w2,w3;

    fulladder1 a1(
        .Ci(Ci),
        .a(InputA[0]),
        .b(InputB[0]),
        .s(Output[0]),
        .Co(w1)
        );

    fulladder1 a2(
        .Ci(w1),
        .a(InputA[1]),
        .b(InputB[1]),
        .s(Output[1]),
        .Co(w2)
        );
    
    fulladder1 a3(
        .Ci(w2),
        .a(InputA[2]),
        .b(InputB[2]),
        .s(Output[2]),
        .Co(w3)
        );

    fulladder1 a4(
        .Ci(w3),
        .a(InputA[3]),
        .b(InputB[3]),
        .s(Output[3]),
        .Co(Co)
        );
endmodule


module fulladder1(Ci,a,b,s,Co);
    input Ci,a,b;
    output s,Co;
    wire w1;
    
    xor_gate x1(
        .y(w1),
        .a(a),
        .b(b)
        );

    xor_gate x2(
        .y(s),
        .a(Ci),
        .b(w1)
        );

    mux2to1 u1(
        .x(b),
        .y(Ci),
        .s(w1),
        .m(Co)
        );
endmodule


module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
    assign m = s & y | ~s & x;
endmodule


module xor_gate(y,a,b);
    input a,b;
    output y;
    assign y = (!a & b) | (a & !b);
endmodule