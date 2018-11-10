module Lab5P3(KEY, SW, LEDR, CLOCK_50);
	input [2:0] SW;
	input [1:0] KEY;
	output reg [0:0] LEDR = 1'b0;
	input CLOCK_50;
	
	reg [15:0] pattern;
	reg [25:0] count = 26'd49999999;
	
	wire clk;
	always @(posedge KEY[0])
	begin
		case (SW[2:0])
			3'b000: pattern[15:0] = 16'b1010100000000000;
			3'b001: pattern[15:0] = 16'b1110000000000000;
			3'b010: pattern[15:0] = 16'b1010111000000000;
			3'b011: pattern[15:0] = 16'b1010101110000000;
			3'b100: pattern[15:0] = 16'b1011101110000000;
			3'b101: pattern[15:0] = 16'b1110101011100000;
			3'b110: pattern[15:0] = 16'b1110101110111000;
			3'b111: pattern[15:0] = 16'b1110111010100000;
		endcase
	end
	
	assign clk = (count == 0) ? 1 : 0;
	
	always @(posedge CLOCK_50)
	begin
		if (count == 0)
			count <= 26'd49999999;
		else
			count <= count - 1;
	end
	
	always @(posedge clk)
	begin
		if (KEY[1] == 1'b1)
			begin
				LEDR[0] <= pattern[15];
				pattern <= pattern << 1;
			end
	end
endmodule