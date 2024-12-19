	module Key //按键消抖
(	input clk,
	input rst,
	input left,
	input right,
	input up,
	input down,
	output reg leftpress,
	output reg rightpress,
	output reg uppress,
	output reg downpress
);

	reg [31:0]cnt;
	reg llast;
	reg rlast;
	reg ulast;
	reg dlast;	
	always@(posedge clk or negedge rst) begin
		if(!rst) begin
			cnt <= 0;
			leftpress <= 0;
			rightpress <= 0;
			uppress <= 0;
			downpress <= 0;			
			llast <= 0;
			rlast <= 0;
			ulast <= 0;
			dlast <= 0;					
		end	
		else begin
			if(cnt == 50000) begin
				cnt <= 0;
				llast <= left;
				rlast <= right;
				ulast <= up;
				dlast <= down;
					
				//if(llast == 0 && left == 1) //按键按下为1，平时为0
				//	leftpress <= 1;
				//if(rlast == 0 && right == 1)
				//	rightpress <= 1;
				//if(ulast == 0 && up == 1)
				//	uppress <= 1;
				//if(dlast == 0 && down == 1)
				//	downpress <= 1;

				if(llast == 1 && left == 0) //按键按下为0，平时为1
					leftpress <= 1;
				if(rlast == 1 && right == 0)
					rightpress <= 1;
				if(ulast == 1 && up == 0)
					uppress <= 1;
				if(dlast == 1 && down == 0)
					downpress <= 1;

			end						
			else begin
				cnt <= cnt + 1;
				leftpress <= 0;
				rightpress <= 0;
				uppress <= 0;
				downpress <= 0;
			end
		end	
	end				
endmodule