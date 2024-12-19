module timer(
    input clk, // 时钟
    input rst, // 异步复位信号
    input status,
    output reg [19:0] seconds // 秒计数器
);

// 分频模块，将50MHz的时钟分频到1Hz
reg [29:0] count;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        count <= 0;
    end 
    else if (count == 50_000_000 - 1) begin
            count <= 30'd0;
    end
    else begin
            count <= count + 30'd1;
    end
end

// 根据状态控制计时器
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        seconds <= 20'd0;
    end
    else if(count == 50_000_000 - 1)begin
		seconds <= seconds + 20'd1;
    end
	else begin
		seconds <= seconds;
	end
end

endmodule
/* module timer(
	input clk, // 时钟信号
	input rst, // 异步复位信号
	input status,
	output reg [10:0] seconds // 秒计数器
);

// 分频模块，将50MHz的时钟分频到1Hz
reg [23:0] count;
always(*)
	case(status)
2'b10:	always @(posedge clk or negedge rst) begin
			if (!rst) begin
				count <= 0;
				seconds <= 0;
			end 
			else if (count == 50_000_000 - 1) begin
					count <= 0;
					seconds <= seconds + 32'd1;
				end
			else begin
					count <= count + 1;
				end
			end
	2'b11: assign seconds = 10'd0;
	default: assign seconds = 10'd0;
endcase
endmodule */