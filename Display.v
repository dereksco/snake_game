module Display //结尾分数显示
(
	input clk,
	input rst,
	input add,
	inout [1:0]status,
	output reg[6:0]seg_out0,
	output reg[6:0]seg_out1,
	output reg[6:0]seg_out2,
	output reg[6:0]seg_out3,
	//output reg[3:0]seg_con,
	output reg [15:0] point_1,
	output reg[15:0]point 
);

    localparam RESTART = 2'b00;
	localparam DIE = 2'b11;    
    reg[31:0]cnt;	
		
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			begin
			//seg_con <= 4'b1111;
				cnt <= 0;
				seg_out0 <= 0;
				seg_out1 <= 0;
				seg_out2 <= 0;
				seg_out3 <= 0;
			end
	    else if (status == RESTART)
	     begin
	      //seg_con <= 4'b1111;  
            cnt <= 0;
            seg_out0 <= 0;
				seg_out1 <= 0;
				seg_out2 <= 0;
				seg_out3 <= 0;				
        end
		else
			begin
				if(cnt <= 200000)	
				begin
					cnt <= cnt+1;
					if(cnt == 50000)
						begin
							//seg_con <= 4'b1110;
							case(point[3:0])
								4'b0000:seg_out0 <= 7'b1000000;
								4'b0001:seg_out0 <= 7'b1111001;
								4'b0010:seg_out0 <= 7'b0100100;				
								4'b0011:seg_out0 <= 7'b0110000;
								4'b0100:seg_out0 <= 7'b0011001;
								4'b0101:seg_out0 <= 7'b0010010;						
								4'b0110:seg_out0 <= 7'b0000010;
								4'b0111:seg_out0 <= 7'b1111000;
								4'b1000:seg_out0 <= 7'b0000000;
								4'b1001:seg_out0 <= 7'b0010000;
								
							endcase					
						end					
					else if(cnt == 10_0000)
						begin
							//seg_con <= 4'b1101;							
							case(point[7:4])
								4'b0000:seg_out1 <= 7'b1000000;
								4'b0001:seg_out1 <= 7'b1111001;
								4'b0010:seg_out1 <= 7'b0100100;			
								4'b0011:seg_out1 <= 7'b0110000;
								4'b0100:seg_out1 <= 7'b0011001;
								4'b0101:seg_out1 <= 7'b0010010;					
								4'b0110:seg_out1 <= 7'b0000010;
								4'b0111:seg_out1 <= 7'b1111000;
								4'b1000:seg_out1 <= 7'b0000000;
								4'b1001:seg_out1 <= 7'b0010000;
														
							endcase							
						end					
					else if(cnt == 15_0000)
						begin
							//seg_con <= 4'b1011;
							case(point[11:8])
								4'b0000:seg_out2 <= 7'b1000000;
								4'b0001:seg_out2 <= 7'b1111001;
								4'b0010:seg_out2 <= 7'b0100100;				
								4'b0011:seg_out2 <= 7'b0110000;
								4'b0100:seg_out2 <= 7'b0011001;
								4'b0101:seg_out2 <= 7'b0010010;		
								4'b0110:seg_out2 <= 7'b0000010;
								4'b0111:seg_out2 <= 7'b1111000;
								4'b1000:seg_out2 <= 7'b0000000;
								4'b1001:seg_out2 <= 7'b0010000;
													
							endcase
						end					
					else if(cnt == 20_0000)
						begin
						    //seg_con <= 4'b0111;
							case(point[15:12])
								4'b0000:seg_out3 <= 7'b1000000;
								4'b0001:seg_out3 <= 7'b1111001;
								4'b0010:seg_out3 <= 7'b0100100;			
								4'b0011:seg_out3 <= 7'b0110000;
								4'b0100:seg_out3 <= 7'b0011001;
								4'b0101:seg_out3 <= 7'b0010010;		
								4'b0110:seg_out3 <= 7'b0000010;
								4'b0111:seg_out3 <= 7'b1111000;
								4'b1000:seg_out3 <= 7'b0000000;
								4'b1001:seg_out3 <= 7'b0010000;									
					endcase
						end				
				end				
				else
					cnt <= 0;
			end		
	end
	
	reg adds;

	always@(posedge clk or negedge rst)
		begin
			if(!rst)
				begin
					point <= 0;
					adds <= 0;	
					point_1<=0;				
				end
			else if (status == RESTART) begin
                point <= 0;
                adds <= 0; 
				point_1<=point_1;             
            end
			else if (status == DIE) begin
                point_1 <= point;            
            end
			else begin
			point_1<=point_1;
				case(adds)				
				    0: begin				
					    if(add) begin
					        if(point[3:0] < 9)
						        point[3:0] <= point[3:0] + 1;
					        else begin
						        point[3:0] <= 0;
							    if(point[7:4] < 9)
							 	    point[7:4] <= point[7:4] + 1;
							    else begin
								    point[7:4] <= 0;
								    if(point[11:8] < 9)
									    point[11:8] <= point[11:8] + 1;
								    else begin
								        point[11:8] <= 0;
									    point[15:12] <= point[15:12] + 1;
								    end
							    end
						    end						
					       adds <= 1;
				        end
				    end				
				    1: begin
				        if(!add)
					        adds <= 0;
				    end				
				endcase			
			end										
	end								
endmodule