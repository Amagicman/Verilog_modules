//同步FIFO设计
module sync_fifo(clk,rst,wr_en,rd_en,data_in,data_out,empty,full);

	input clk,rst,wr_en,rd_en;
	input [7:0] data_in;
	output empty,full;
	output [7:0] data_out;
	
	reg [7:0] mem[15:0];//16*8RAM 深度为16，8位宽的RAM
	reg [7:0] data_out; //读数据输出
	wire [3:0] w_addr,r_addr; //写/读地址位
	reg [4:0] r_addr_a,w_addr_a;//扩展后的写/读地址位（最高位用于判断数据full）

	assign r_addr=r_addr_a[3:0];//“写/读地址位”取“扩展后的写/读地址位”的低四位
	assign w_addr=w_addr_a[3:0];

	always@(posedge clk or negedge rst)
		begin
			if(!rst)
				begin
					r_addr_a<=5'b0;
				end
			else
				begin
					if(rd_en==1 && empty==0) //读使能信号有效且数据不为空
						begin
							data_out<=mem[r_addr];  //读数据
							r_addr_a<=r_addr_a+1; //读地址计数用扩展后的地址+1
						end
				end
		end
	
	always@(posedge clk or negedge rst)
		begin
			if(!rst)
				begin
					w_addr_a<=5'b0;
				end
			else
				begin
					if(wr_en=1 && full==0) ////写使能信号有效且数据不为满
						begin 
							mem[w_addr]<=data_in;  //写数据
							w_addr_a<=w_addr_a+1;//写地址计数用扩展后的地址+1
						end
				end
		end
		
	assign empty=(r_addr_a==w_addr_a)?1:0;  //判断空：扩展后读地址等于扩展后写地址
	assign full=(r_addr_a[4]!=w_addr_a[4]) && r_addr_a[3:0]==w_addr_a[3:0])?1:0;  //判断满：扩展后读/写地址最高位相反且低四位相等
		
endmodule