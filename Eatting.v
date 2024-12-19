module Eatting //增量式蛇身长度判定
(
	input clk,//clk_25m
	input rst,
	input [5:0]headx,
	input [5:0]heady,
	output reg [5:0]foodx,
	output reg [4:0]foody,
	output reg add	//吃到食物后add为1
);

	reg [31:0]cnt;
	reg [10:0]randomnum;//max = 2047
	always@(posedge clk)
		randomnum <= randomnum + 998;  
	
	always@(posedge clk or negedge rst) begin
		if(!rst) begin
			cnt <= 0;
			foodx <= 24;
			foody <= 10;
			add <= 0;
		end
		else begin
			cnt <= cnt+1;
			if(cnt == 250000) begin
				cnt <= 0;
				if(foodx == headx && foody == heady)
				begin
					add <= 1;
					foodx <= (randomnum[10:5] > 38) ? (randomnum[10:5] - 28) : (randomnum[10:5] == 0) ? 2 : randomnum[10:5];
					foody <= (randomnum[4:0] > 28) ? (randomnum[4:0] - 5) : (randomnum[4:0] == 0) ? 2 :randomnum[4:0];
				end  
				else
					add <= 0;
			end
		end
	end
endmodule