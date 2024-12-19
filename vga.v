`timescale 1ns / 1ps
//vga rgb565 
module vga(
	input clk,
    input rst,

    input [15:0] point_1,
    input score_flag,
    input [1:0]snake,
    input [5:0]foodx,
    input [4:0]foody,
    output [9:0]posx,
    output [9:0]posy,    
    output hsync,
    output vsync,
    output vga_clk,
    output [23:0] vga_out
    );
    
    wire clk_n;
	 assign clk_n = clk;//25MHz
    /*
    clk_unit clk_inst(
        .clk(clk),
        .rst(!rst),
        .clk_n(clk_n)
    );*/


    VGA_unit VGA_inst
(
		.clk(clk_n),
		.rst(rst),
        .point_1(point_1),
        .score_flag(score_flag),
		.hsync(hsync),
		.vsync(vsync),
		.snake(snake),
        .vga_out(vga_out),
		.posx(posx),
		.posy(posy),
		.foodx(foodx),
		.foody(foody)
	);
    
    assign vga_clk = clk_n;
    
endmodule
