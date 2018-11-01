//Sw[7:0] data_in

//KEY[0] synchronous reset when pressed
//KEY[1] go signal

//LEDR displays result
//HEX0 & HEX1 also displays result

module Lab6P3(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1);
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1;

    wire resetn;
    wire go;

    wire [8:0] data_result;
    assign go = ~KEY[1];
    assign resetn = KEY[0];

    part2 u0(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[3:0]),
        .data_result(data_result)
    );
      
    assign LEDR[9:0] = {1'b0, data_result};

    hex_decoder H0(
        .hex_digit(data_result[3:0]), 
        .segments(HEX0)
        );
        
    hex_decoder H1(
        .hex_digit(data_result[7:4]), 
        .segments(HEX1)
        );

endmodule

module part2(
    input clk,
    input resetn,
    input go,
    input [3:0] data_in,
    output [8:0] data_result
    );

    // lots of wires to connect our datapath and control
    wire ld_r, ld_d, ld_e;
    wire ld_alu_out;


    control C0(
        .clk(clk),
        .resetn(resetn),
        
        .go(go),
        
        .ld_alu_out(ld_alu_out), 
        .ld_r(ld_r),
        .ld_d(ld_d),
        .ld_e(ld_e)
    );

    datapath D0(
        .clk(clk),
        .resetn(resetn),
		  .data_in(data_in),

        .ld_alu_out(ld_alu_out), 
        .ld_r(ld_r),
        .ld_d(ld_d),
        .ld_e(ld_e),

        .data_result(data_result)
    );
                
 endmodule        
                

module control(
    input clk,
    input resetn,
    input go,

    output reg  ld_r, ld_d, ld_e,
    output reg  ld_alu_out
    );

    reg [3:0] current_state, next_state; 
    
    localparam  S_LOAD_Divident        = 4'd0,
                S_LOAD_Divident_WAIT   = 4'd1,
                S_LOAD_Divisor         = 4'd2,
                S_LOAD_Divisor_WAIT    = 4'd3,
                S_CYCLE_0       			= 4'd4,
                S_CYCLE_1      			= 4'd5,
                S_CYCLE_2       			= 4'd6,
					 S_CYCLE_3     			= 4'd7;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_Divident: next_state = go ? S_LOAD_Divident_WAIT : S_LOAD_Divident; // Loop in current state until value is input
                S_LOAD_Divident_WAIT: next_state = go ? S_LOAD_Divident_WAIT : S_LOAD_Divisor; // Loop in current state until go signal goes low
                S_LOAD_Divisor: next_state = go ? S_LOAD_Divisor_WAIT : S_LOAD_Divisor; // Loop in current state until value is input
                S_LOAD_Divisor_WAIT: next_state = go ? S_LOAD_Divisor_WAIT : S_CYCLE_0; // Loop in current state until go signal goes low
           
                S_CYCLE_0: next_state = S_CYCLE_1;
					 S_CYCLE_1: next_state = S_CYCLE_2;
					 S_CYCLE_2: next_state = S_CYCLE_3;
                S_CYCLE_3: next_state = S_LOAD_Divident; // we will be done our two operations, start over after
            default:     next_state = S_LOAD_Divident;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_alu_out = 1'b0;
        ld_r = 1'b0;
        ld_d = 1'b0;
        ld_e = 1'b0;

        case (current_state)
            S_LOAD_Divident: begin
                ld_alu_out = 1'b0;
					 ld_d = 1'b1;
                end
            S_LOAD_Divisor: begin
                ld_r = 1'b1;
                end
            S_CYCLE_0: begin
                ld_alu_out = 1'b1; ld_d = 1'b1;
                end
            S_CYCLE_1: begin
                ld_alu_out = 1'b1; ld_d = 1'b1;
                end
            S_CYCLE_2: begin 
                ld_alu_out = 1'b1; ld_d = 1'b1;
					 end
            S_CYCLE_3: begin
                ld_e = 1'b1;
              
            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_Divident;
        else
            current_state <= next_state;
    end // state_FFS
endmodule


module datapath(
    input clk,
    input resetn,
    input [3:0] data_in,
    input ld_alu_out, 
    input ld_r, ld_d, ld_e,
    output reg [8:0] data_result
    );
    
    // Register for Dividend and RA
    reg [8:0] bigRegister;
	 
	 // Register for the Divisor
	 reg [3:0] divisor;
	 
    // output of the alu
    reg [8:0] alu_out;
	 
    
    // Registers bigRegister and divisor with respective input logic
    always @ (posedge clk) begin
        if (!resetn) begin
            bigRegister <= 9'd0; 
            divisor <= 9'd0; 
        end
        else begin
            if (ld_d)
                bigRegister <= ld_alu_out ? alu_out : data_in; // load alu_out if load_alu_out signal is high, otherwise load from data_in
         
            if (ld_r)
                divisor <= data_in;
        end
    end
 
    // Output result register
    always @ (posedge clk) begin
        if (!resetn) begin
            data_result <= 9'd0; 
        end
        else 
            if(ld_e)
                data_result <= alu_out;
    end

    // The ALU 
    always @(*)
    begin : ALU
        // alu
        alu_out = (bigRegister << 1) - (divisor << 4); 
		  if(alu_out[8]) begin
				alu_out <= alu_out + (divisor << 4); 
		  end
		  else
		  alu_out <= alu_out + 1'b1;
    end
    
endmodule


module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
