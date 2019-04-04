//设计一个三段式有限状态机
//检测序列1110010

module seq(in,out,state,clk,reset);
	input in,clk,reset;
	output out;
	output [2:0] state;

	reg [2:0] cur_state;
	reg [2:0] next_state;
	wire out;

	parameter s0='d0,s1='d1,s2='d2,s3='d3,s4='d4,s5='d5,s6='d6,s7='d7;
	
//第一段状态机
	always@(posedge clk or negedge reset)
	begin
		if(~reset)
			begin
				cur_state<=s0;
			end
		else
			begin
				cur_state<=next_state; //组合逻辑得到的 next_state送给时序逻辑cur_state 滤除next_state毛刺
			end
	end
	
//第一段状态机 组合逻辑实现 
	always @(*)    /* always @(in,cur_state) */
	begin
		case(cur_state)
		s0: begin
				if(in=0) begin next_state=s0;end
				else 	 begin next_state=s1;end
			end
		s1: begin
				if(in=0) begin next_state=s0;end
				else 	 begin next_state=s2;end
			end
		s2: begin
				if(in=0) begin next_state=s0;end
				else 	 begin next_state=s3;end
			end
		s3: begin
				if(in=0) begin next_state=s4;end
				else 	 begin next_state=s3;end
			end
		s4: begin
				if(in=0) begin next_state=s5;end
				else 	 begin next_state=s1;end
			end
		s5: begin
				if(in=0) begin next_state=s0;end
				else 	 begin next_state=s6;end
			end
		s6: begin
				if(in=0) begin next_state=s7;end
				else 	 begin next_state=s2;end
			end
		s7: begin
				if(in=0) begin next_state=s0;end
				else 	 begin next_state=s1;end
			end
		default:next_state=s0;  //防止锁存器
		endcase
	end

//第三段状态机
assign out = (cur_state=s7)? 1:0;
assign state = cur_state; //输出判断 不是判断next_state而是判断cur_state 是因为next_state可能有毛刺
endmodule