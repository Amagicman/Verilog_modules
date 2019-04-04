//设计一个自动售饮料机，饮料售价2.5元，可以使用5角和1元硬币，有找零功能 Mealy状态机
`timescale 10ns/1ns
module drink_status(clk,reset,half,one,out,cout);
	input half;
	input one;
	input clk;
	input reset;
	output out;
	output cout;
	wire out;
	wire cout;
				
	parameter [2:0] 	idle='b000, 	
						half_d='b001,	
						one_d='b010, 	
						one_half='b011,	
						two='b100,		
						/* two_half='b101,	
						three='b110;	*/  // Moore状态机需要用到这些状态
						
	reg [2:0] cur_state;
	reg [2:0] next_state;

	always@(posedge clk or negedge reset)
	begin
		if(!reset)
			cur_state<=idle;
		else
			cur_state<=next_state;
	end

	always@(*)
	begin
		case(cur_state)
		
		idle:	begin
					if(half) next_state=half_d;
					else if(one) next_state=one_d;
					else next_state=idle;
				end
		half_d: begin
					if(half) next_state=one_d;
					else if(one) next_state=one_half;
					else next_state=half_d;
				end
		one_d: 	begin
					if(half) next_state=one_half;
					else if(one) next_state=two;
					else next_state=one_d;
				end
		one_half: 	begin
						if(half) next_state=two;
						else if(one) next_state=idle;
						else next_state=one_half;
					end
		two: begin
					if(half) next_state=idle;
					else if(one) next_state=idle;
					else next_state=two;
			end
	default next_state=idle;
	endcase
	end

assign out=((cur_state==two)&(half|one))?1:((cur_state==one_half)&(one))?1:0; //能否获取饮料
assign cout=((cur_state==two)&(one))?1:0;  //需不需要找五角钱


endmodule