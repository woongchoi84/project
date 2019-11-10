//	==================================================
//	Copyright (c) 2019 Sookmyung Women's University.
//	--------------------------------------------------
//	FILE 			: practice06.v
//	DEPARTMENT		: EE
//	AUTHOR			: WOONG CHOI
//	EMAIL			: woongchoi@sookmyung.ac.kr
//	--------------------------------------------------
//	RELEASE HISTORY
//	--------------------------------------------------
//	VERSION			DATE
//	0.0				2019-10-28
//	--------------------------------------------------
//	PURPOSE			: Seven-Segment Display
//	==================================================

//	--------------------------------------------------
//	0~59 Counter
//	--------------------------------------------------
module cnt60(	o_cnt60,
		clk,
		rst_n);

output	[5:0]	o_cnt60			;
input		clk			;
input			rst_n		;

reg		[5:0]	o_cnt60		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_cnt60 <= 6'd0;
	end else begin
		if(o_cnt60 >= 6'd59) begin
			o_cnt60 <= 6'd0;
		end else begin
			o_cnt60 <= o_cnt60 + 1'b1;
		end
	end
end

endmodule

//	--------------------------------------------------
//	Numerical Controlled Oscillator
//	Hz of o_gen_clk = Clock Hz / num
//	--------------------------------------------------
module	nco(	o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/2-1) begin
			cnt 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule

//	--------------------------------------------------
//	NCO Clock Based 0~59 Counter
//	--------------------------------------------------
module	nco_cnt(
				o_nco_cnt,
				i_nco_num,
				clk,
				rst_n);

output	[5:0]	o_nco_cnt	;

input	[31:0]	i_nco_num	;
input		clk		;
input		rst_n		;

wire		gen_clk		;

nco		u_nco(	.o_gen_clk	( gen_clk	),
			.i_nco_num	( i_nco_num	),
			.clk		( clk		),
			.rst_n		( rst_n		));

cnt60		u_cnt60(.o_cnt60	( o_nco_cnt	),
			.clk		( gen_clk	),
			.rst_n		( rst_n		));

endmodule

//	--------------------------------------------------
//	Flexible Numerical Display Decoder
//	--------------------------------------------------
module	fnd_dec(	o_seg,
			i_num);

output	[6:0]	o_seg		;	// {o_seg_a, o_seg_b, ... , o_seg_g}

input	[3:0]	i_num		;
reg	[6:0]	o_seg		;
//making
always @(i_num) begin 
 	case(i_num) 
 		4'd0 : o_seg = 7'b111_1110	; 
 		4'd1 : o_seg = 7'b011_0000	; 
 		4'd2 : o_seg = 7'b110_1101	; 
 		4'd3 : o_seg = 7'b111_1001	; 
 		4'd4 : o_seg = 7'b011_0011	; 
 		4'd5 : o_seg = 7'b101_1011	; 
 		4'd6 : o_seg = 7'b101_1111	; 
 		4'd7 : o_seg = 7'b111_0000	; 
 		4'd8 : o_seg = 7'b111_1111	; 
 		4'd9 : o_seg = 7'b111_0011	; 
		default : o_seg = 7'b000_0000	; 
	endcase 
end


endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	double_fig_sep(
				o_left,
				o_right,
				i_double_fig);

output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[5:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;

endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	led_disp(
				o_seg,
				o_seg_dp,
				o_seg_enb,
				i_six_digit_seg,
				i_six_dp,
				clk,
				rst_n);

output	[5:0]	o_seg_enb		;
output		o_seg_dp		;
output	[6:0]	o_seg			;

input	[41:0]	i_six_digit_seg		;
input	[5:0]	i_six_dp		;
input		clk			;
input		rst_n			;

wire		gen_clk		;

nco		u_nco(	.o_gen_clk	( gen_clk	),
			.i_nco_num	( 32'd5000	),
			.clk		( clk		),
			.rst_n		( rst_n		));


reg		[3:0]	cnt_common_node	;

always @(posedge gen_clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_common_node <= 4'd0;
	end else begin
		if(cnt_common_node >= 4'd5) begin
			cnt_common_node <= 4'd0;
		end else begin
			cnt_common_node <= cnt_common_node + 1'b1;
		end
	end
end

reg		[5:0]	o_seg_enb		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0 : o_seg_enb = 6'b111110;
		4'd1 : o_seg_enb = 6'b111101;
		4'd2 : o_seg_enb = 6'b111011;
		4'd3 : o_seg_enb = 6'b110111;
		4'd4 : o_seg_enb = 6'b101111;
		4'd5 : o_seg_enb = 6'b011111;
	endcase
end

reg				o_seg_dp		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0 : o_seg_dp = i_six_dp[0];
		4'd1 : o_seg_dp = i_six_dp[1];
		4'd2 : o_seg_dp = i_six_dp[2];
		4'd3 : o_seg_dp = i_six_dp[3];
		4'd4 : o_seg_dp = i_six_dp[4];
		4'd5 : o_seg_dp = i_six_dp[5];
	endcase
end

reg		[6:0]	o_seg			;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0 : o_seg = i_six_digit_seg[6:0];
		4'd1 : o_seg = i_six_digit_seg[13:7];
		4'd2 : o_seg = i_six_digit_seg[20:14];
		4'd3 : o_seg = i_six_digit_seg[27:21];
		4'd4 : o_seg = i_six_digit_seg[34:28];
		4'd5 : o_seg = i_six_digit_seg[41:35];
	endcase
end

endmodule

module	controller(	mode,
			position,
			incr,
			flag_alarm,
			sw0,
			sw1,
			sw2,
			sw3,
			clk,
			rst_n);

output	[1:0]	mode			;
output	[1:0]	position		;
output		incr			;
output		flag_alarm		;

input		sw0			;
input		sw1			;
input		sw2			;
input		sw3			;
input		clk			;
input		rst_n			;

parameter	MODE_CLOCK = 2'b00	;
parameter	MODE_SETUP = 2'b01	;
parameter	MODE_ALARM = 2'b10	;
parameter	MODE_TIMER = 2'b11	;

parameter	POS_SEC	= 2'b00		;
parameter	POS_MIN	= 2'b01		;
parameter	POS_HOU	= 2'b10		;

reg	[1:0]	mode			;
always @(posedge sw0 or negedge rst_n) begin
    if(rst_n == 1'b0) begin
end

endmodule
