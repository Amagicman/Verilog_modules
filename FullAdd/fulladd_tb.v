`timescale 1ns/1ps
module fulladd_tb; 
	reg ain,bin,cin;
	wire cout,sum;
	reg clk;
	always #1 clk=~clk;
	
	initial
	begin
		clk=0;
		ain=0;
		bin=1;
		cin=1;
		#10;
		ain=1;
		bin=1;
		cin=0;
		#10;
		ain=1;
		bin=1;
		cin=1;
		#10;
		$finish;
	end
	
	initial begin
		@(posedge clk);
		#5;
		if(sum!=1) $display("SUM calc ERROR,sum=%b",sum);
		else $display("SUM calc correct");
		if(cout!=1) $display("COUT calc ERROR,cout=%b",cout);
		else $display("COUT calc correct");
		#10;
		if(sum!=0) $display("SUM calc ERROR,sum=%b",sum);
		else $display("SUM calc correct");
		if(cout!=1) $display("COUT calc ERROR,cout=%b",cout);
		else $display("COUT calc correct");
		#10;
		if(sum!=0) $display("SUM calc ERROR,sum=%b",sum);
		else $display("SUM calc correct");
		if(cout!=1) $display("COUT calc ERROR,cout=%b",cout);
		else $display("COUT calc correct");
	end
	
		FULLADDR fulladd_u0(
		.Cout(cout),
		.Sum(sum),
		.Ain(ain),
		.Bin(bin),
		.Cin(cin)
		);

endmodule