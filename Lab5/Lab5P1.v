module Lab5part1(KEY,SW,HEX0,HEX1);
	input [3:0]KEY;
	input [9:0]SW;
	output [6:0]HEX0,HEX1;
	wire [7:0]w1;
	
	MyTFF tFF(
		.Enable(SW[1]),
		.clock(KEY[0]),
		.Clear_b(SW[0]),
		.Q(w1)
	);
	
	HEX hexl0(
		.in(w1[3:0]),
		.out(HEX0)
	);
	
	HEX hexl1(
		.in(w1[7:4]),
		.out(HEX1)
	);
endmodule

module MyTFF(Enable, clock, Clear_b, Q);
	input Enable;
	input clock;
	input Clear_b;
	output [7:0]Q;
	wire w1,w2,w3,w4,w5,w6,w7;

	t_flipflop f0(
		.clock(clock),
		.Clear_b(Clear_b),
		.T(Enable),
		.Q(Q[0])
	);
	
	andGate and0(
		.x(Q[0]),
		.y(Enable),
		.z(w1)
	);
	
	t_flipflop f1(
		.clock(clock),
		.Clear_b(Clear_b),
		.T(w1),
		.Q(Q[1])
	);
	
	andGate and1(
		.x(Q[1]),
		.y(w1),
		.z(w2)
	);
	
	t_flipflop f2(
		.clock(clock),
		.Clear_b(Clear_b),
		.T(w2),
		.Q(Q[2])
	);
	
	andGate and2(
		.x(Q[2]),
		.y(w2),
		.z(w3)
	);
	
	t_flipflop f3(
		.clock(clock),
		.Clear_b(Clear_b),
		.T(w3),
		.Q(Q[3])
	);
	
	andGate and3(
		.x(Q[3]),
		.y(w3),
		.z(w4)
	);
	
	t_flipflop f4(
		.clock(clock),
		.Clear_b(Clear_b),
		.T(w4),
		.Q(Q[4])
	);
	
	andGate and4(
		.x(Q[4]),
		.y(w4),
		.z(w5)
	);
	
	t_flipflop f5(
		.clock(clock),
		.Clear_b(Clear_b),
		.T(w5),
		.Q(Q[5])
	);
	
	andGate and5(
		.x(Q[5]),
		.y(w5),
		.z(w6)
	);

	t_flipflop f6(
		.clock(clock),
		.Clear_b(Clear_b),
		.T(w6),
		.Q(Q[6])
	);
	
	andGate and6(
		.x(Q[6]),
		.y(w6),
		.z(w7)
	);

	t_flipflop f7(
		.clock(clock),
		.Clear_b(Clear_b),
		.T(w7),
		.Q(Q[7])
   );
endmodule




//------------------help method------------------------
module t_flipflop(clock,Clear_b,T,Q);
	input T;
	input clock;
	input Clear_b;
	output reg Q;
	
	always @(posedge clock, negedge Clear_b)

	begin 
		if (Clear_b == 1'b0)
			Q <=0;
		else if (T == 1'b1)
			Q <=~Q;
	end
endmodule


module andGate(x,y,z);
	input x;
	input y;
	output z;
	
	assign z = x & y;
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