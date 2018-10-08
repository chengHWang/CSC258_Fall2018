module alu(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
	input [7:0] SW;
	input [2:0] KEY;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [7:0] LEDR;
	wire [7:0] ALUout;

	wire [3:0] A = SW[7:4]; 
	wire [3:0] B = SW[3:0];
	wire [2:0] mode = KEY[2:0];

	HexLight hexl0(.Output(HEX0),
		        	.Input(B)
	);
	HexLight hexl1(.Output(HEX1),
			.Input(4'b0000)
	);
	HexLight hexl2(.Output(HEX2),
			.Input(A)
	);
	HexLight hexl3(.Output(HEX3),
			.Input(4'b0000)
	);
	alu_cpu cpu(A,B,mode,ALUout);
	HexLight hexl4(.Output(HEX4),
			.Input(ALUout[3:0])
	);	
	HexLight hexl5(.Output(HEX5),
			.Input(ALUout[7:4])
	);
	assign LEDR = ALUout;
endmodule


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