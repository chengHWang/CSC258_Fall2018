// Part 2 skeleton

module Lab7P2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
	wire ld_x,ld_y,ld_c;

   // Instansiate datapath
	datapath d0(CLOCK_50,ld_x,ld_y,ld_c,resetn,writeEn,SW[9:7],SW[6:0],x,y,colour);

   // Instansiate FSM control
   control c0(CLOCK_50,resetn,~KEY[3],~KEY[1],ld_x,ld_y,ld_c,writeEn);
    
endmodule


module datapath(clk, ld_x, ld_y, ld_c, reset_n, go, color_in, position, x_out, y_out, color_out);
	
	input clk, ld_x, ld_y, ld_c, reset_n, go;
	input [2:0] color_in;
	input [6:0] position;
	
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] color_out;
	
	reg [2:0] count_x, count_y;
	reg [7:0] real_x;
	reg [6:0] real_y;
	reg [2:0] color;
	
	// registors for x, y and color
	always @(posedge clk) begin
		if (!reset_n) begin
			real_x <= 8'b0;
			real_y <= 7'b0;
			color <= 3'b0;
		end
		else begin
			if (ld_x)
				real_x <= {1'b0, position};
			if (ld_y)
				real_y <= position;
			if (ld_c)
				color <= color_in;
		end
	end

	// counter for x
	always @(posedge clk) begin
		if (!reset_n)
			count_x <= 2'b00;
		else if (go) begin
			if (count_x == 2'b11)
				count_x <= 2'b00;
			else begin
				count_x <= count_x + 1'b1;
			end
		end
	end
	
	
	// counter for y
	always @(posedge clk) begin
		if (!reset_n)
			count_y <= 2'b00;
		else if (go && (count_x == 2'b11)) begin
			if (count_y != 2'b11)
				count_y <= count_y + 1'b1;
			else 
				count_y <= 2'b00;
		end
	end
	
	assign x_out = real_x + count_x;
	assign y_out = real_y + count_y;
	assign color_out = color;
	
endmodule



module control(clk, reset_n, ld, draw, ld_x, ld_y, ld_c, go);
	input clk, reset_n, ld, draw;
	output reg ld_x, ld_y, ld_c, go;
	reg [2:0] current_state, next_state;

	// States renaming
	localparam 	
				Load_x = 3'd0,
				Load_x_wait = 3'd1,
				Load_y = 3'd2,
				Load_y_wait = 3'd3,
				Load_c = 3'd4,
				Load_c_wait = 3'd5,
				Draw = 3'd6;
					
	// State Table
	always @(*) begin
		case (current_state)
			Load_x: next_state = ld ? Load_x_wait : Load_x;
			Load_x_wait: next_state = ld ? Load_x_wait : Load_y;
			Load_y: next_state = ld ? Load_y_wait : Load_y;
			Load_y_wait: next_state = ld ? Load_y_wait : Load_c;
			Load_c: next_state = draw ? Load_c_wait : Load_c;
			Load_c_wait: next_state = draw ? Load_c_wait : Draw;
			Draw: next_state = ld ? Load_x : Draw;
		endcase
	end
	
	// Output Logic
	always @(*) begin
		ld_x = 1'b0;
		ld_y = 1'b0;
		ld_c = 1'b0;
		go = 1'b0;
		
		case (current_state)
			Load_x: begin
				ld_x = 1; 
			end
			Load_y: begin
				ld_y = 1; 
			end
			Load_c: begin
				ld_c = 1; 
			end
			Draw: begin
				go = 1;
			end
		endcase
	end
	
	// Current State Register
	always @(posedge clk) begin
		if (!reset_n)
			current_state <= Load_x;
		else
			current_state <= next_state;
	end

endmodule


module test_module(clk, reset_n, ld, draw, color_in, position, x_out, y_out, color_out);
	
	input clk, reset_n, ld, draw;
	input [2:0] color_in;
	input [6:0] position;
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] color_out;
	wire ld_x, ld_y, ld_c, go;
	
	control c0(clk,reset_n,ld,draw,ld_x,ld_y,ld_c,go);
	
	datapath d0(clk,ld_x,ld_y,ld_c,reset_n,go,color_in,position,x_out,y_out,color_out);
	

endmodule