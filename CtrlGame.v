module CtrlGame //状态控制fsm
(
	input clk,//clk_25m
	input rst,
	input hitwall,
    input hitbody,
	input key1,
	input key2,
	input key3,
	input key4,
	input [15:0] point,	
	output reg die,
    output reg restart ,   //状态为RESTART时为1，持续(20+1)*T
	output reg [1:0]status,
	output reg score_flag 	//状态为DIE时为1
);
	
	localparam RESTART = 2'b00;
	localparam START = 2'b01;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;
	
	reg[31:0]cnt;	
	always@(posedge clk or negedge rst)
	begin
		if(!rst) begin
			status <= RESTART;
			cnt <= 0;
			die <= 1;
			restart <= 0;
		end
		else begin
			case(status)			
				RESTART:begin           
					if(cnt <= 20) begin
						cnt <= cnt + 1;
						restart <= 1;						
					end
					else begin
						status <= START;
						cnt <= 0;
						restart <= 0;
					end
				end
				START:begin
					if (key1 | key2 | key3 | key4)
                        status <= PLAY;
					else 
					    status <= START;
				end
				PLAY:begin
					if(hitwall | hitbody)
					   status <= DIE;
					else if(point[11:8]>=1'd1)
					   status <= DIE;
					else
					   status <= PLAY;
				end					
				DIE:begin
					if(cnt <= 200_000_000) begin
						cnt <= cnt + 1'b1;
					   if(cnt == 25_000_000)
					       die <= 0;
					   else if(cnt == 50_000_000)
					       die <= 1'b1;
					   else if(cnt == 75_000_000)
					       die <= 1'b0;
					   else if(cnt == 100_000_000)
					       die <= 1'b1;
					   else if(cnt == 125_000_000)
					       die <= 1'b0;
					   else if(cnt == 150_000_000)
					       die <= 1'b1;
				    end 
					else if(key1 | key2 | key3 | key4)
						begin
							die <= 1;
							cnt <= 0;
							status <= RESTART;
						end
					
					else
					      status <= DIE;
                    end
			endcase
			
		end
	end

    always@(posedge clk or negedge rst)
    begin
    	if(!rst) begin
			score_flag <= 1'd0;
    	end
		else if (status == DIE)
		    score_flag <= 1'd1;

	    else
		    score_flag <= 1'd0;
	end
endmodule