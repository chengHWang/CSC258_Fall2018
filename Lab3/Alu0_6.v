include "Alu_cpu.v";
include "HexLight.v";

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



	
	