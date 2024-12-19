`timescale 1ns / 1ps
 

 module snake_tb();
    
    reg clk;
    reg rst;
    
    reg left;
    reg right;
    reg up;
    reg down;

    wire hsync;
    wire vsync;
    wire [11:0]  color_out;
    wire [7:0]  seg_out;
    wire [3:0]  sel;
    
    top_greedy_snake u(
        .clk(clk),
        .rst(rst),
        .left(left),
        .right(right),
        .up(up),
        .down(down),
        .hsync(hsync),
        .vsync(vsync),
        .color_out(color_out),
        .seg_out(seg_out),
        .sel(sel)
    );
    
    initial
    begin
        #0 clk = 0;
        #0 rst = 0;
        #25 rst = 1;
        #10 rst = 0;
        #100 right = 1;
        #25 right =0;
    end
    
    always #2 clk = ~clk;
    
endmodule

