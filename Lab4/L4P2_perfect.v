module L4P2(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
	input [9:0] SW;  // SW[3:0] = A; SW[9] = reset_n; SW[7:5] = function_input
	input [0:0] KEY; // KEY[0] = clk
	output [6:0] HEX0; 
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [7:0] LEDR;   // LEDR = ALUout; B = LEDR[3:0] = ALUout[3:0]
	reg [7:0] ALUout;
	reg [7:0] q;

	wire [3:0] A = SW[3:0];
	wire [3:0] B = q[3:0];
	wire clk = KEY[0]; // clock input for the register
	wire reset_n = SW[9];
	
	wire [2:0] mode = SW[7:5];  //Alu input    

	HexLight hex0(.Output(HEX0),
		        	.Input(A)
	);
	
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	
		
	HexLight hex4(.Output(HEX4),
					.Input(q[3:0])
	);	
	HexLight hex5(.Output(HEX5),
				.Input(q[7:4])
	);
	
	//Case0
	wire [4:0] temp0;
	fulladder4 fa0(A,4'b0001,1'b0,temp0[4],temp0[3:0]);

	//Case1
	wire [4:0] temp1;
	fulladder4 fa1(A,B,1'b0, temp1[4],temp1[3:0]);
	
	//Alu
	always @(*)
	begin
		case(mode)
			3'b000: ALUout = {3'b000,temp0};
			3'b001: ALUout = {3'b000,temp1};
			3'b010: ALUout = A+B;
			3'b011: ALUout = {A|B, A^B};
			3'b100: ALUout = {7'b0000000, | {A,B}};
			3'b101: ALUout = B << A;
			3'b110: ALUout = B >> A;
			3'b111: ALUout = A * B;
		endcase
	end
	
	// register

	always @(posedge clk)
	begin
		if (reset_n == 1'b0)
			q <=  8'b00000000;
		else
			q <= ALUout;
	end
	
		
	assign LEDR = q;
endmodule

//Input[3:0] data input, usually is 4 SW
//Output[6:0] output for a Hex light

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
    output Co;
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
	
	assign s = a ^ b ^ Ci;
	assign Co = (a&b) | (Ci & (a^b));
endmodule
