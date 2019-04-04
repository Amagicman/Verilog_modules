//位扩展后的自然二进制码转换为格雷码
module gray(b_in,g_out);       //二进制输入，格雷码输出

	input [4:0] b_in;          //位扩展后的自然二进制码
	output [4:0] g_out;        //位扩展后的格雷码
	wire [4:0] g_out;
	
//位扩展后的自然二进制码转换为格雷码：最高位（full判断位）以及次高位不变，其他位与上一位异或
	assign g_out[4]=b_in[4];
	assign g_out[3]=b_in[3];
	assign g_out[2]=b_in[3]^b_in[2];
	assign g_out[1]=b_in[2]^b_in[1];
	assign g_out[0]=b_in[1]^b_in[0];
	
endmodule

//异步fifo模块
module fifo(rclk,wclk,rst,wr_en,rd_en,data_in,data_out,empty,full,halffull);

	input rclk,wclk,rst,wr_en,rd_en;
	input [7:0] data_in;
	output empty,full,halffull;
	output [7:0] data_out;
	
	reg halffull;
	reg [7:0]mem[15:0];//16*8RAM
	reg [7:0] data_out;
	wire [3:0] w_addr,r_addr;
	wire [4:0] w_addr_b,r_addr_b; //格雷码
	
	reg [4:0] w_addr_a,r_addr_a;  //位扩展后的地址
	reg [4:0] w_addr_r,r_addr_w; 
	
	gray g1(.b_in(w_addr_a),.g_out(w_addr_b)); //写地址二进制码转换成格雷码
	gray g2(.b_in(r_addr_a),.g_out(r_addr_b)); //读地址二进制码转换成格雷码
	
	assign w_addr=w_addr_b[3:0]; //写地址格雷码  (w_addr是最终要跨时钟域传递的值)
	assign r_addr=r_addr_b[3:0]; //读地址格雷码  (r_addr是最终要跨时钟域传递的值)
	
//读出数据	
	always@(posedge rclk or negedge rst)//读时钟域
		begin
			if(!rst)
				begin
					r_addr_a<=5'b0; //读时钟域的地址
					r_addr_w<=5'b0; //从写时钟域同步到读时钟域上的写地址
				end
			else
				begin
					r_addr_w<=w_addr_b; //写地址转换成的格雷码同步到读时钟域(此处不正确待修改 同步过来的组合逻辑信号需要打两拍再使用)
					if(rd_en==1 && empty==0) //读使能信号有效且非空
						begin
							data_out<=mem[r_addr]; //读出数据
							r_addr_a<=r_addr_a+1;//读时钟域的地址自+1
						end
				end
		end

//写入数据	
	always@(posedge wclk or negedge rst) //写时钟域
		begin
			if(!rst)
				begin
					w_addr_a<=5'b0;//写时钟域的地址
					w_addr_r<=5'b0;//从读时钟域同步到写时钟域上的读地址
				end
			else
				begin
					w_addr_r<=r_addr_b;//读地址转换成的格雷码同步到写时钟域(此处不正确待修改 同步过来的组合逻辑信号需要打两拍再使用)
					if(wr_en==1 && full==0) //写使能信号有效且非满
						begin
							mem[w_addr]<=data_in; //写入数据
							w_addr_a<=w_addr_a+1;//写时钟域的地址自+1
						end
				end
		end
	
	assign empty=(r_addr_b==r_addr_w)?1:0;//判断读地址格雷码==从写时钟域同步到读时钟域上的写地址(格雷码)
	assign full=(w_addr_b[4]!=w_addr_r[4] && w_addr_b[3:0]==w_addr_r[3:0])?1:0;// “写地址格雷码”与“从读时钟域同步到写时钟域上的读地址(格雷码)”  高位相反，其他低位相同 为满
	
endmodule