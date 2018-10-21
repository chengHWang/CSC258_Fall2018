module Lab5Part2(SW,HEX0,CLOCK_50);
	input [9:0] SW;
	input CLOCK_50;
	output [6:0] HEX0;
	
	wire [1:0] speedControl = SW[1:0];
	wire enable = SW[8];
	wire reset = SW[9];
	wire setValue = SW[5:2];
	wire set = SW[6];
		
	wire [27:0]w1;
	wire w2;
	wire [3:0]w3;
	
	//This module used to translate SW[1:0] to a number used to get the real clock we need, stored in w1  
	four_to_one_mux f1(
		.Output(w1),
		.Input(speedControl)
	);
	
	//This module provide a signal about the real clock we are using, the real enable(w2)
	RateDivider rateDivider(
		.En(enable),
		.D(w1),
		.clk(CLOCK_50),
		.Re(reset),
		.Q(w2)
	);
	
	//This module provide the number we are currently holding(w3)
	DisplayCounter displayCounter(
		.Enable(w2),
		.CLOCK_50(CLOCK_50),
		.Clear(reset),
		.Q(w3),
		.setV(setValue),
		.set(set)
	);
	
	//Show the result
	HEX hex0(
		.out(HEX0[6:0]),
		.in(w3)
	);
endmodule


module four_to_one_mux (Output, Input);
	input [1:0] Input;
	output [27:0] Output;
	reg [27:0]Out;
	always @(*)
	begin
		case (Input[1:0])
			2'b00: Out = 0; 		// 2'b00->50mhz
			2'b01: Out = 5*(10**7)-1; 	// 2'b01->1hz
			2'b10: Out = 2*5*(10**7)-1; 	// 2'b10->0.5hz
			2'b11: Out = 4*5*(10**7)-1;  	// 2'b11->0.25hz
		endcase
	end
	assign Output = Out;
	
endmodule


module RateDivider(En, clk, Re, Q ,D);
	input [27:0] D;
	input Re;
	input clk;
	input En;
   	reg [27:0] count;
	output Q;

	always @(posedge clk)
		begin 
			 if (Re == 1'b0)
				  count <= D;
			 else if (count == 0)
				  count <= D;
			 else if (En == 1)
				  count <= count - 1;
		end
		
	assign Q = (count == 0) ? 1 : 0;
endmodule
	

module DisplayCounter(Enable, CLOCK_50, Clear, Q, setV,set);
	input Enable;	//This Enable is actually the Q in RateDivisor
	input Clear;
	input CLOCK_50;
	input [3:0] setV;
	input set;
	output [3:0]Q;
	reg [3:0]temp;
	
	always @(posedge CLOCK_50 ,negedge Clear)
	begin 
		if (Clear == 1'b0)
			temp <= 0;
		else if (set ==1'b1)
			temp <= setV;
		else if (Enable == 1'b1)
			temp <= temp + 1'b1;
	end 
	assign Q = temp ;  // This Q has nothing to do with the Q in RateDivisor
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