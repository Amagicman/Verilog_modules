module FULLADDR(Cout,Sum,Ain,Bin,Cin);
	input Ain,Bin,Cin;
	output Cout,Sum;

	wire Cout;
	wire Sum;
	assign Sum = Ain^Bin^Cin;
	assign Cout = (Ain&Bin)|(Bin&Cin)|(Ain&Cin);
endmodule