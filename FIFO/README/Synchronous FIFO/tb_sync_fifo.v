`timescale 10ns/1ns
module tb_sync_fifo();

	reg clk,rst,wr_en,rd_en
	reg [7:0] data_in;
	wire [7:0] data_out;
	wire empty,full,halffull;
	
	sync_fifo sync_fifo_u0 (clk,rst,wr_en,rd_en,data_in,data_out,empty,full); //端口位置关联
	
	initial
		begin
			rst=1;
			clk=0;
			#1 rst=0;
			#5 rst=1;
		end
	
	always #20 clk=~clk;
	
	initial
		begin
			wr_en=0;
			#1 wr_en=1;
		end
	
	initial
		begin
			rd_en=0;
			#650 rd_en=1;
			wr_en=0;
		end
		
	initial
		begin
			data_in=8'h0;
			#40 data_in=8'h1;
			#40 data_in=8'h2;
			#40 data_in=8'h3;
			#40 data_in=8'h4;
			#40 data_in=8'h5;
			#40 data_in=8'h6;
			#40 data_in=8'h7;
			#40 data_in=8'h8;
			#40 data_in=8'h9;
			#40 data_in=8'ha;
			#40 data_in=8'hb;
			#40 data_in=8'hc;
			#40 data_in=8'hd;
			#40 data_in=8'he;
			#40 data_in=8'hf;
		end
endmodule