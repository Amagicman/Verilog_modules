`timescale 10ns/1ns
module tb_seq();
reg in;
reg clk;
reg reset;
reg [7:0] date[0:7];
wire out;
wire [2:0] state;
reg i;

initial
begin
	clk=0;
	reset=0;
	#20;
	reset=1;
end
always #20 clk=~clk;
//011100101
initial
begin
	in = 0;
	#30;
	in = 1;
	#40;
	in = 1;
	#40;
	in = 1;
	#40;
	in = 0;
	#40;
	in = 0;
	#40;
	in = 1;
	#40;
	in = 0;
	#40;
	in = 1;
	#40;
	$finish;
end

//initial begin
//$readmemh("data.txt",data);
//for(i=0,i<8,i+i+1) begin
//#40;
//$display("data=%d",data[i]);
//end
//#200;
//$finish;
//end

seq seq_u1(
.in(in),
.out(out),
.state(state),
.clk(clk),
.reset(reset)
);
endmodule