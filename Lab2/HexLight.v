//SW[3:0] data input, 4 switch
//HEX0[6:0] output for 7 segment light

module segmentDecorder(HEX0,SW);
	input [9:0] SW;
	output [6:0] HEX0;

	assign HEX0[0] = ((!SW[3])&(!SW[2])&(!SW[1])&(SW[0]))|	//0001
		            ((!SW[3])&(SW[2])&(!SW[1])&(!SW[0]))|	//0100
		            ((SW[3])&(SW[2])&(!SW[1])&(SW[0]))|	//1101
		            ((SW[3])&(!SW[2])&(SW[1])&(SW[0]));	//1011

	assign HEX0[1] = ((SW[3])&(SW[1])&(SW[0]))|	                //1x11
		  ((SW[2])&(SW[1])&(!SW[0]))|			//x110
		  ((SW[3])&(SW[2])&(!SW[1])&(!SW[0]))|		//1100
		  ((!SW[3])&(SW[2])&(!SW[1])&(SW[0]));		//0101
		 
	assign HEX0[2] = ((SW[3])&(SW[2])&(!SW[1])&(!SW[0]))|	//1100
		  ((SW[3])&(SW[2])&(SW[1]))|			//111x
		  ((!SW[3])&(!SW[2])&(SW[1])&(!SW[0]));	//0010

	assign HEX0[3] = ((!SW[3])&(SW[2])&(!SW[1])&(!SW[0]))|	//0100
		  ((!SW[3])&(!SW[2])&(!SW[1])&(SW[0]))|	//0001
		  ((!SW[3])&(SW[2])&(SW[1])&(SW[0]))|		//0111
		   ((SW[3])&(!SW[2])&(SW[1])&(!SW[0]))|	//1010
		  ((SW[3])&(SW[2])&(SW[1])&(SW[0]));		//1111
		
	assign HEX0[4] = ((!SW[3])&(SW[0]))|			//0xx1
		  ((!SW[3])&(SW[2])&(!SW[1]))|		//010x
		  ((!SW[2])&(!SW[1])&(SW[0]));		//x001

	assign HEX0[5] = ((!SW[3])&(!SW[2])&(SW[0]))|		//00x1
		  ((!SW[3])&(!SW[2])&(SW[1]))|		//001x
		  ((!SW[3])&(SW[1])&(SW[0]))|			//0x11
		  ((SW[3])&(SW[2])&(!SW[1])&(SW[0]));		//1101

	assign HEX0[6] = ((!SW[3])&(!SW[2])&(!SW[1]))|		//000x
		  ((SW[3])&(SW[2])&(!SW[1])&(!SW[0]))|		//1100
		  ((!SW[3])&(SW[2])&(SW[1])&(SW[0]));		//0111


endmodule





















