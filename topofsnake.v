

module topofsnake
(
	input clk,//50MHz
	input rst,//active low
	
	input up,
	input down,
	input left,
    input right,
	 
	output hsync,
	output vsync,
	output vga_clk,
	output [4:0]vga_r,
    output [5:0]vga_g,
    output [4:0]vga_b,
	
	output  wire            stcp        ,   //输出数据存储寄时钟
    output  wire            shcp        ,   //移位寄存器的时钟输入
    output  wire            ds          ,   //串行数据输入
    output  wire            oe              //输出使能信号
);

	wire uppress;
	wire downpress;
	wire leftpress;
    wire rightpress;
	wire [1:0]snake;
    wire [5:0]foodx;
    wire [4:0]foody;
	wire [9:0]posx;
	wire [9:0]posy;
	wire [5:0]headx;
	wire [5:0]heady;
	wire hitwall;
    wire hitbody;
	wire add;
	wire die;
	wire restart;
	wire [6:0]cubenum;
	wire[1:0]status;	
	wire rst_n;
	wire clk_25m;
    wire score_flag;
	wire [15:0] point_1 ;
	wire [15:0] point ;
	
	wire	locked_pll;

	pll_clk pll_clk_inst(
		.areset	 (~rst),//active high
		.inclk0	 (clk),
		.c0	 (clk_25m),
		.locked	 (locked_pll)
	);

	assign rst_n = rst & locked_pll ;

    CtrlGame Part1 (
        .clk(clk_25m),
	    .rst(rst_n),
	    .hitwall(hitwall),
        .hitbody(hitbody),
	    .key1(leftpress),
	    .key2(rightpress),
	    .key3(uppress),
	    .key4(downpress),
	    .die(die),
        .restart(restart),
        .status(status),
		.score_flag(score_flag),
		.point(point) 
	);
	
    Eatting Part2 (
        .clk(clk_25m),
		.rst(rst_n),
		.foodx(foodx),
		.foody(foody),
		.headx(headx),
		.heady(heady),
		.add(add)	
	);
	
   top_seg_595 Part6(
    .sys_clk(clk)     ,   //System clock, frequency 50MHz
    .sys_rst_n(rst_n)   ,   //Reset signal, active low
	.status(status)      ,
    .stcp(stcp)        ,   //output data storage register clock
    .shcp(shcp)        ,   //The clock input of a shift register
    .ds(ds)          ,   //serial data input
    .oe(oe)              //output enable signal
	);

	
	
	
	Snake Part3 (
	    .clk(clk_25m),
		.rst(rst_n),
		.leftpress(leftpress),
		.rightpress(rightpress),
		.uppress(uppress),
		.downpress(downpress),
		.snake(snake),
		.posx(posx),
		.posy(posy),
		.headx(headx),
		.heady(heady),
		.add(add),
		.status(status),
		.cubenum(cubenum),
		.hitbody(hitbody),
		.hitwall(hitwall),
		.die(die)
	);

	vga Part4 (    //vga signal output module
		.clk(clk_25m),
		.rst(rst_n),
		.point_1(point_1),
        .score_flag(score_flag),
		.hsync(hsync),
		.vsync(vsync),
		.snake(snake),
		.vga_clk(vga_clk),
        .vga_out({vga_r,vga_g,vga_b}),
		.posx(posx),
		.posy(posy),
		.foodx(foodx),
		.foody(foody)
	);
	
	Key Part5 (
		.clk(clk_25m),
		.rst(rst_n),
		.left(left),
		.right(right),
		.up(up),
		.down(down),
		.leftpress(leftpress),
		.rightpress(rightpress),
		.uppress(uppress),
		.downpress(downpress)		
	);
        Display Part7 (
		.clk(clk_25m),
		.rst(rst_n),	
		.add(add),
		.status(status),
		.seg_out(),
		.seg_con(),
		.point_1(point_1),
		.point(point)	
	);

endmodule
