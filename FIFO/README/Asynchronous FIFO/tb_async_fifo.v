`timescale 10ns/1ns
module tb_async_fifo;
	reg rclk,wclk,rst,wr_en,rd_en;
	reg [7:0] data_in;
	wire empty,full,halffull;
	wire [7:0] data_out;
	
	fifo fifo_u0(rclk,wclk,rst,wr_en,rd_en,data_in,data_out,empty,full,halffull);
	
	initial
		begin
			rst=1;
			rclk=0;
			wclk=0;
			#1 rst=0;
			#5 rst=1;
		end
		
	initial
		begin
			wr_en=0;
			#1 wr_en=1;			
		end
	
	initial
		begin
			rd_en=0;
			#650;
			rd_en=1;
			wr_en=0;
		end
		
	a_to_b_chk:
	assert property
	(@(posedge wclk) $rose(wr_en) | -> ##[1:3] $rose(rd_en));
	
	always #30 rclk=~rclk;
	always #30 wclk=~wclk;
		
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