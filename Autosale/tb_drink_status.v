`timescale 10ns/1ns
module tb_drink_status();
	reg half;
	reg one;
	reg clk;
	reg reset;
	wire out;
	wire cout;
	
	initial
		begin
			clk=0;
			reset=0;
			#10;
			reset=1;	
		end

	always #20 clk=~clk;

	initial
		begin
			half=0;
			one=0;
			#20;
			repeat(5)
				begin
					@(posedge clk) half=1;
					@(posedge clk) half=0;
				end
			#100;
			repeat(3)
				begin
				@(posedge clk) one=1;
				@(posedge clk) one=0;
				end
			#200;
			$finish;
		end
drink_status drink_status_u0(
	.clk(clk),
	.reset(reset),
	.half(half),
	.one(one),
	.out(out),
	.cout(cout)
);
	
	
endmodule