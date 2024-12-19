module VGA_unit //rgb565
(
	input clk,
	input rst,
	
	input [15:0] point_1,
	input score_flag,
	input [1:0]snake,
	input [5:0]foodx,
	input [4:0]foody,
	output reg [9:0]posx,
	output reg [9:0]posy,	
	output reg hsync,
	output reg vsync,
	output reg [15:0] vga_out
);

	reg [19:0]cnt;
	reg [9:0]line_cnt;
	reg clk_25M;
	
	localparam COLOROFHEAD = 16'h80ff;//头部的颜色
    localparam COLOROFBODY = 16'h0480; //身体的颜色
	localparam N = 2'b00;
	localparam H = 2'b01;
	localparam B = 2'b10;
	localparam W = 2'b11;
	
	reg [3:0]lox;
	reg [3:0]loy;		

	always@(posedge clk or negedge rst) begin
		if(!rst) begin
			cnt <= 0;
			line_cnt <= 0;
			hsync <= 1;
			vsync <= 1;
            posx <= 0;
            posy <= 0;
		end
		else begin
		    posx = cnt - 135;
			posy = line_cnt - 33;
			if(cnt == 0) begin
			    hsync <= 0;
				cnt <= cnt + 1;
            end
			else if(cnt == 95) begin
				hsync <= 1;
				cnt <= cnt + 1;
            end
			else if(cnt == 799) begin
				cnt <= 0;
				line_cnt <= line_cnt + 1;
			end
			else
			 cnt <= cnt + 1;
			if(line_cnt == 0) begin
				vsync <= 0;
            end
			else if(line_cnt == 1) begin
				vsync <= 1;
			end
			else if(line_cnt == 524) begin
				line_cnt <= 0;
				vsync <= 0;
			end
			
			if(posx >= 0 && posx < 640 && posy >= 0 && posy < 480) begin
			    if(score_flag == 1'd0) begin  
			        lox = posx[3:0];
			    	//loy = posx[3:0];
					loy = posy[3:0];
			    	if(posx[9:4] == foodx && posy[9:4] == foody) begin
			    		case({loy,lox})
			    			8'b00000000:vga_out = 16'h0000;
			    			default:vga_out = 16'hff80;
			    		endcase	
			    	end					
			    	else if(snake == N)
			    		vga_out = 16'h0000;
			    	else if(snake == W)
			    		vga_out = 16'hff00;
			    	else if(snake == H|snake == B) begin
			    		case({lox,loy})
			    			8'b00000000:vga_out = 16'h0000;
			    			default:vga_out = (snake == H) ?  COLOROFHEAD : COLOROFBODY;
			    		endcase
			    	end
			    end
				else begin
					if(point_1[11:8]==1'd1)begin
                         if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                    vga_out = 16'hff80;

                        else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 10)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 20 && posy[9:4] < 22)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 8 && posy[9:4] < 16)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 14 && posy[9:4] < 22)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                    vga_out = 16'hff80;

                        else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 20 && posy[9:4] < 22)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 8 && posy[9:4] < 16)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 14 && posy[9:4] < 22)
                                    vga_out = 16'hff80;
                        else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                    vga_out = 16'hff80;
                        else 
						             vga_out = 16'h0000;
					end
                    else begin


						if(posx[9:4] >= 0 && posx[9:4] < 15 )begin
						case (point_1[11:8])
						    4'd0:begin
								if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
								else
                                           vga_out = 16'h0000;
                                end
                            4'd1:begin
                                if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
								else
                                            vga_out = 16'h0000;

							end
                            4'd2:begin
								if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
							end
                            4'd3:begin
								if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
							end
                            4'd4:begin
                               if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
							end
                            4'd5:begin
								if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
                                end

                            4'd6:begin
								if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
							end
                            4'd7:begin
								if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
							end
                            4'd8:begin
								if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
							end
                            4'd9:begin
								if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
							end 
							default: 
							                vga_out = 16'h0000;
						endcase
						end
						else if(posx[9:4] >= 15 && posx[9:4] < 25)begin
						case (point_1[7:4])
                            4'd0:begin
								if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                        		else
                                           vga_out = 16'h0000;
                                end
                            4'd1:begin
                                if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                           vga_out = 16'h0000;
							
                        	end
                            4'd2:begin
								if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                           vga_out = 16'h0000;
                        	end
                            4'd3:begin
							if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 10)
                                        vga_out = 16'h80ff;
                            else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 16)
                                        vga_out = 16'h80ff;
                            else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 20 && posy[9:4] < 22)
                                        vga_out = 16'h80ff;
                            else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                        vga_out = 16'h80ff;
                            else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                        vga_out = 16'h80ff;
                            else
                                       vga_out = 16'h0000;	
                        	end
                            4'd4:begin
							
                            if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 16)
                                        vga_out = 16'h80ff;
                            else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 8 && posy[9:4] < 16)
                                        vga_out = 16'h80ff;
                            else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                        vga_out = 16'h80ff;
                            else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                        vga_out = 16'h80ff;
                            else
                                       vga_out = 16'h0000;	
                        	end
                            4'd5:begin
                        		if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 14 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 6 && posx[9:4] < 8 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 12 && posx[9:4] < 14 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                            vga_out = 16'h0000;
                                end
                            4'd6:begin
								if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                           vga_out = 16'h0000;
                        	end
                            4'd7:begin
								if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                           vga_out = 16'h0000;
                        	end
                            4'd8:begin
								if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                           vga_out = 16'h0000;
                        	end
                            4'd9:begin
								if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 24 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 16 && posx[9:4] < 18 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 22 && posx[9:4] < 24 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else
                                           vga_out = 16'h0000;
                        	end 
                        	default: 
                        	                vga_out = 16'h0000;
                        endcase
						end
						else begin
						case (point_1[3:0])
                            4'd0:begin
								if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                                end
                            4'd1:begin
                                if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                        	end
                            4'd2:begin
								if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                        	end
                            4'd3:begin
								if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                        	end
                            4'd4:begin
                                if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                        	end
                            4'd5:begin
								if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                                end
                            4'd6:begin
								if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                        	end
                            4'd7:begin
								if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                        	end
                            4'd8:begin
								if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                        	end
                            4'd9:begin
								if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 10)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 34 && posy[9:4] >= 20 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 26 && posx[9:4] < 28 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 8 && posy[9:4] < 16)
                                            vga_out = 16'h80ff;
                                else if(posx[9:4] >= 32 && posx[9:4] < 34 && posy[9:4] >= 14 && posy[9:4] < 22)
                                            vga_out = 16'h80ff;
                                else 
                                             vga_out = 16'h0000;
                        	end 
                        	default: 
                        	                vga_out = 16'h0000;
                        endcase
						end
					end

				end
            end
			
		    else
			    vga_out = 16'h0000;
		end
    end
endmodule