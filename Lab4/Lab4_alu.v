module alu(SW,KEY0,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
	//input & output
	input [9:0] SW;
	input KEY0;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [7:0] LEDR;


	//necessary wires
	wire [7:0] ALUout;
	wire [3:0] A = SW[3:0]; 
	wire [3:0] B;
	wire [2:0] mode = SW[7:5];
	wire reset = SW[9];
	wire clock = KEY0;

	
	//Using help module Hexlight 
	HexLight hexl0(HEX0,A);
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;


	//Get all the output ready
	alu_cpu cpu(A,B,mode,ALUout);


	reg [3:0] tempB;
	reg [6:0] tempHEX4;
	reg [6:0] tempHEX5;
	reg [7:0] tempLEDR;
	//The clock signal
	always@(posedge clock)
	begin 
		//Set the output
		tempLEDR = ALUout;
		tempHEX4 = ALUout[3:0];
		tempHEX5 = ALUout[7:4];

		//Set the new B
		if(reset == 1'b0)
			tempB <= ALUout[3:0];
		else
			tempB <= 4'b0000;
	end
	assign LEDR =  tempLEDR;
	assign HEX4 = tempHEX4;
	assign HEX5 = tempHEX5;
	assign B = tempB;

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
	input [3:0] Input;
	output [6:0] Output;

	assign Output[0] = ((!Input[3])&(!Input[2])&(!Input[1])&(Input[0]))|	//0001
		            ((!Input[3])&(Input[2])&(!Input[1])&(!Input[0]))|	//0100
		            ((Input[3])&(Input[2])&(!Input[1])&(Input[0]))|	//1101
		            ((Input[3])&(!Input[2])&(Input[1])&(Input[0]));	//1011

	assign Output[1] = ((Input[3])&(Input[1])&(Input[0]))|	                //1x11
		            ((Input[2])&(Input[1])&(!Input[0]))|		//x110
		            ((Input[3])&(Input[2])&(!Input[1])&(!Input[0]))|	//1100
		            ((!Input[3])&(Input[2])&(!Input[1])&(Input[0]));	//0101
		 
	assign Output[2] = ((Input[3])&(Input[2])&(!Input[1])&(!Input[0]))|	//1100
		  	((Input[3])&(Input[2])&(Input[1]))|			//111x
		 	 ((!Input[3])&(!Input[2])&(Input[1])&(!Input[0]));		//0010

	assign Output[3] = ((!Input[3])&(Input[2])&(!Input[1])&(!Input[0]))|	//0100
		  	((!Input[3])&(!Input[2])&(!Input[1])&(Input[0]))|		//0001
		  	((!Input[3])&(Input[2])&(Input[1])&(Input[0]))|		//0111
		  	 ((Input[3])&(!Input[2])&(Input[1])&(!Input[0]))|		//1010
		 	((Input[3])&(Input[2])&(Input[1])&(Input[0]));		//1111
		
	assign Output[4] = ((!Input[3])&(Input[0]))|			//0xx1
		  	((!Input[3])&(Input[2])&(!Input[1]))|			//010x
		  	((!Input[2])&(!Input[1])&(Input[0]));			//x001

	assign Output[5] = ((!Input[3])&(!Input[2])&(Input[0]))|		//00x1
		  	((!Input[3])&(!Input[2])&(Input[1]))|			//001x
		  	((!Input[3])&(Input[1])&(Input[0]))|			//0x11
		  	((Input[3])&(Input[2])&(!Input[1])&(Input[0]));		//1101

	assign Output[6] = ((!Input[3])&(!Input[2])&(!Input[1]))|		//000x
		  	((Input[3])&(Input[2])&(!Input[1])&(!Input[0]))|		//1100
		  	((!Input[3])&(Input[2])&(Input[1])&(Input[0]));		//0111
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