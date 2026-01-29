`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2024 19:26:49
// Design Name: 
// Module Name: clf_alf
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


//top level module

module clf_alf( output sA,sB,sC,sD,sE,sF,sG,
               input [7:0]sw,input clk,rst);
wire mux_out,and_out,codesw,anysw,timeout,start,alarm,locked;
wire [1:0]sel;

FSM F1(alarm,locked,start,sel,timeout,codesw,anysw,clk,rst);
timer T1(timeout,start,clk,rst);
display D1(sA,sB,sC,sD,sE,sF,sG,alarm,locked);
edgedetector E1(codesw,mux_out,clk,rst);
edgedetector E2(anysw,and_out,clk,rst);
assign mux_out = sel[1]?(sel[0]?sw[3]:sw[2]):(sel[0]?sw[1]:sw[0]); 
assign and_out=&sw;
endmodule

//edge detector for synchronising so that every 
//input will last only for one clock cycle
module edgedetector(output out,input in,clk,rst);
wire q0,q1;
dff D1(q0,in,clk,rst);
dff D2(q1,q0,clk,rst);
not n1(nq0,q0);
assign out=q1 & (~q0);
endmodule

module dff(output reg dfout,input dfin,clk,rst);
always@(posedge clk)
if(rst)
dfout<=0;
else
dfout<=dfin;
endmodule

//after particular time it will lock again
module timer(output timeout,input start,clk,rst);
localparam Numclocks = 1_999_999_999;
reg [31:0]q;
always @(posedge clk) begin
if(rst)
q<=0;
else begin
if(~start || (q==Numclocks) )
q<=0;
else
q<=q+1;
end
end
assign timeout=(q==Numclocks);
endmodule

//to show it is locked or alarm or unlocked
module display(output sA,sB,sC,sD,sE,sF,sG,input alarm,locked);
reg [6:0]seg;
always @(*)
begin
if(alarm==0)
seg=7'b0001000;  //display A
else if (locked==0)
seg=7'b1000001;   // display U
else
seg=7'b1110001;     //display L
end
assign {sA,sB,sC,sD,sE,sF,sG}=seg;
endmodule

//controller 
module FSM(output  alarm,locked,start,output reg [1:0]sel,input timeout,codesw,anysw,clk,rst);
parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,
          s4=3'b100,s5=3'b101;
reg [2:0]ps,ns;
always@(posedge clk)
begin
if(rst)
ps<=s0;
else
ps<=ns;
end

always@(*)
begin
case(ps)
s0:if(codesw & anysw)
      ns<=s1;
   else if (anysw)
      ns<=s5;
   else ns<=s0;
s1:if(codesw & anysw)
      ns<=s2;
   else if (anysw)
      ns<=s5;
   else ns<=s1;
s2:if(codesw & anysw)
      ns<=s3;
   else if (anysw)
      ns<=s5;
   else ns<=s2;
s3:if(codesw & anysw)
      ns<=s4;
   else if (anysw)
      ns<=s5;
   else ns<=s3;
s4:if(start)
      ns<=s0;
   else ns<=s4;
s5:ns<=s0;
endcase
end 
always@(ps)
begin
case(ps)
s0:sel=0;
s1:sel=1;
s2:sel=2;
s3:sel=3;
s4:sel=0;
s5:sel=0;

endcase
end
assign locked = (ps != s4);
assign alarm = (ps != s5) ;
assign start = (ps == s4) ;
endmodule


     
     
