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





















