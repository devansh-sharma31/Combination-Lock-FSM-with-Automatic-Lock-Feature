`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2024 22:42:04
// Design Name: 
// Module Name: clf_alf_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clf_alf_tb();
wire sA,sB,sC,sD,sE,sF,sG;
reg [7:0]sw;
reg clk,rst;
clf_alf dut(sA,sB,sC,sD,sE,sF,sG,sw,clk,rst);
initial clk=0;
always clk=#5 ~clk;
initial begin
rst=1;
#30 rst=0;
end
initial begin
sw=8'b11111111;
#50 sw=8'b11111110;
#50 sw=8'b11111111;
#50 sw=8'b11111110;
#50 sw=8'b11111111;
#50 sw=8'b11111011;
#50 sw=8'b11111111;
#50 sw=8'b11110111;
#50 sw=8'b11111111;


end

 initial begin
    $monitor("Time=%0t | rst=%b | sw=%b | sA=%b, sB=%b, sC=%b, sD=%b, sE=%b, sF=%b, sG=%b", 
              $time, rst, sw, sA, sB, sC, sD, sE, sF, sG);
  end
endmodule
