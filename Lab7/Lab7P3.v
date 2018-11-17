module Lab7P3
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
	wire [7:0] y;
	wire writeEn;
	wire enable,ld_c;

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
    
    // Instansiate datapath
	// datapath d0(...);
      datapath d0(enable,CLOCK_50,ld_c,SW[9:7],KEY[0],x,y,colour);

    // Instansiate FSM control
    // control c0(...);
	   control c0(CLOCK_50,KEY[0],~KEY[1],enable,ld_c,writeEn);

    
endmodule



module counter(clock,reset_n,enable,q);
	input clock,reset_n,enable;
	output reg [1:0] q;
	
	always @(posedge clock)
	begin
		if(reset_n == 1'b0)
			q <= 2'b00;
		else if(enable == 1'b1)
		begin
		  if(q == 2'b11)
			  q <= 2'b00;
		  else
			  q <= q + 1'b1;
		end
   end
endmodule


module rate_counter(clock,reset_n,enable,q);
		input clock;
		input reset_n;
		input enable;
		output reg [1:0] q;
		
		always @(posedge clock)
		begin
			if(reset_n == 1'b0)
				q <= 2'b11;
			else if(enable ==1'b1)
			begin
			   if ( q == 2'b00 )
					q <= 2'b11;
				else
					q <= q - 1'b1;
			end
		end
endmodule	


module delay_counter(clock,reset_n,enable,enable_fc);
		input clock;
		input reset_n;
		input enable;
		output enable_fc;
		reg [19:0] q;
		
		always @(posedge clock)
		begin
			if(reset_n == 1'b0)
				q <= 833334;
			else if(enable ==1'b1)
			begin
			   if ( q == 20'd0 )
					q <= 833334;
				else
					q <= q - 1'b1;
			end
		end
		
		assign enable_fc = (q ==  20'd0) ? 1 : 0;
endmodule


module frame_counter(clock,reset_n,enable,enable_xy,colour_1,colour);
	input clock,reset_n,enable;
	input [2:0]colour;
	output  enable_xy;
	output [2:0]colour_1;
	reg [3:0]q;
	
	always @(posedge clock)
	begin
		if(reset_n == 1'b0)
			q <= 4'b0000;
		else if(enable == 1'b1)
		begin
		  if(q == 4'b1111)
			  q <= 4'b0000;
		  else
			  q <= q + 1'b1;
		end
   end
	
	assign enable_xy = (q == 4'b1111) ? 1 : 0;
	assign colour_1 = (q == 4'b1111) ? 3'b000 : colour;
endmodule


module x_counter(x_in,clock,reset_n,enable,x_out);
	input clock,enable,reset_n;
	input [7:0] x_in;
	output reg[7:0] x_out;
	reg direction;
	
	always@(posedge clock)
	begin
		if(reset_n == 1'b0)
			direction <= 1'b1;
		else
		begin
			if(direction == 1'b1)
			begin
				if(x_in + 1 > 8'b10011111)
					direction <= 1'b0;
				else
					direction <= 1'b1;
			   end
			else
			begin
				if(x_in == 8'b00000000)
					direction <= 1'b1;
				else
					direction <= 1'b0;
			end
		end
	end
	
	always@(negedge enable, negedge reset_n)begin
	   if(reset_n == 1'b0)begin
			x_out <= 8'b00000000;
		end
		else if(direction == 1'b1)
				x_out <= x_out + 1'b1;
		else
				x_out <= x_out - 1'b1;
		end
endmodule


module y_counter(y_in,clock,reset_n,enable,y_out);
	input clock,enable,reset_n;
	input [7:0] y_in;
	output reg[7:0] y_out;
	reg direction;
	
	always@(negedge enable, negedge reset_n)begin
	   if(reset_n == 1'b0)begin
			y_out <= 60;
		end
		else if(direction == 1'b1)
				y_out <= y_out + 1'b1;
		else
				y_out <= y_out - 1'b1;
		end
		
	always@(posedge clock)
	begin
		if(reset_n == 1'b0)
			direction <= 1'b0;
		else	
		begin
			if(direction == 1'b1)
			begin
				if(y_in + 1 > 8'b01110111)
					direction <= 1'b0;
				else
					direction <= 1'b1;
			   end
			else
			begin
				if(y_in == 8'b00000000)
					direction <= 1'b1;
				else
					direction <= 1'b0;
			end
		end
	end
endmodule


module draw(x,y,colour,ld_c,clock,reset_n,enable,X,Y,Colour);
	input reset_n,enable,clock,ld_c;
	input [7:0] x,y;
	input [2:0] colour;
	output[7:0] X;
	output [7:0] Y;
	output [2:0] Colour;
	reg [7:0] x1,y1,co1;
	
	wire [1:0] c1,c2,c3;
	
	always @ (posedge clock) begin
        if (!reset_n) begin
            x1 <= 7'b0; 
            y1 <= 7'b0;
				co1 <= 3'b0;
        end
        else begin
                x1 <= x;
                y1 <= y;
				if(ld_c == 1)
					co1 <= colour;
        end
    end
	counter cr1(clock,reset_n,enable,c1);
	rate_counter rc2(clock,reset_n,enable,c2);
	assign enable_1 = (c2 == 2'b00) ? 1 : 0;
	counter cr3(clock,reset_n,enable_1,c3);
	assign X = x1 + c1;
	assign Y = y1 + c3;
	assign Colour = co1;
endmodule

module datapath(enable,clock,ld_c,colour,reset_n,X,Y,colour_out);
	input enable,clock,reset_n,ld_c;
	input [2:0] colour;
	output[7:0] X,Y;
	output[2:0] colour_out;
	
	wire enable_fc;
	wire enable_xy;
	wire[3:0] c1;
	wire signal_x,signal_y;
	wire[7:0] x_in,y_in;
	wire[2:0] colour_1;
	
	
	x_counter x_c(
		.x_in(x_in),
		.clock(clock),
		.reset_n(reset_n),
		.enable(enable_xy),
		.x_out(x_in)
	);
	
	y_counter y_c(
		.y_in(y_in),
		.clock(clock),
		.reset_n(reset_n),
		.enable(enable_xy),
		.y_out(y_in)
	);
	
	delay_counter dc1(
		.clock(clock),
		.reset_n(reset_n),
		.enable(enable),
		.enable_fc(enable_fc)
	);
	
	frame_counter fc2( 
		.clock(clock),
		.reset_n(reset_n),
		.enable(enable_fc),
		.enable_xy(enable_xy),
		.colour_1(colour_1),
		.colour(colour)
	);
	
	
	draw dr1(x_in,y_in,colour_1,ld_c,clock,reset_n,enable,X,Y,colour_out);
endmodule

module control(clock,reset_n,go,enable,ld_c,plot);
	input clock,reset_n,go;
	output reg enable,ld_c,plot;	
	
	reg [3:0] current_state, next_state;
	
	localparam  S_LOAD_C      	 = 4'd0,
               S_LOAD_C_WAIT   = 4'd1,
					S_CYCLE_0       = 4'd2;
	
	always@(*)
      begin: state_table 
            case (current_state)
                S_LOAD_C: next_state = go ? S_LOAD_C_WAIT : S_LOAD_C; 
                S_LOAD_C_WAIT: next_state = go ? S_LOAD_C_WAIT : S_CYCLE_0;  
                S_CYCLE_0: next_state = S_CYCLE_0;
					 default:     next_state = S_LOAD_C;
				endcase
      end 
   
	always@(*)
      begin: enable_signals
        // By default make all our signals 0
        ld_c = 1'b0;
		  enable = 1'b0;
		  plot = 1'b0;
		  
		  case(current_state)
				S_LOAD_C:begin
					end
				S_CYCLE_0:begin
				   ld_c = 1'b1;
					enable = 1'b1;
					plot = 1'b1;
					end
		  endcase
    end
	 
	 always@(posedge clock)
      begin: state_FFs
        if(!reset_n)
            current_state <= S_LOAD_C;
        else
            current_state <= next_state;
      end 
endmodule