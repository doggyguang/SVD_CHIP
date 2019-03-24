`timescale 10 ns/ 1 ps
`include "cordic_r.v"
`include "cordic_v.v"
module SVD_interface(
	clk,
	rst, 
	data_i,  
	data_in,
	data_o_S,
	ready
	/*
	d_minus_a,
	d_plus_a,
	c_minus_b,
	c_plus_b,
	theta_plus_reg,
	theta_minus_reg,
	theta_left,
	theta_right,
	sin_left_reg,
	cos_left_reg,
	sin_right_reg,
	cos_right_reg,
	a_1,
	b_1,
	c_1,
	d_1, 
	s_1,
	s_2,
	state*/
);

input	clk;
input	rst; 
input	data_in; 
input 	[15:0] data_i; 
output  [7:0] data_o_S;
output  ready;
/*
output	[15:0] d_minus_a;
output	[15:0] d_plus_a;
output	[15:0] c_minus_b;
output	[15:0] c_plus_b;
output [31:0] theta_plus_reg;
output [31:0] theta_minus_reg;
output [31:0] theta_left;
output [31:0] theta_right;
output	[15:0] sin_left_reg;
output	[15:0] cos_left_reg;
output	[15:0] sin_right_reg;
output	[15:0] cos_right_reg;
output	[31:0] a_1;
output	[31:0] b_1;
output	[31:0] c_1;
output	[31:0] d_1; 
output	[47:0] s_1;
output	[47:0] s_2;
output	[2:0] state;
 */
reg     [7:0] data_o_S;
reg     [7:0] next_data_o_S;
reg     ready;
reg     next_ready;
 
parameter IDLE = 3'b000;
parameter DATAIN = 3'b001;
parameter CALCULATE = 3'b010; 
parameter VECTOR = 3'b011;
parameter ANGLE = 3'b100;
parameter ROTATE = 3'b101; 
parameter OUTPUT_CAL = 3'b110;  
parameter OUTPUT = 3'b111; 


// input matrix(2*2)
reg signed	[15:0] a_i;
reg signed	[15:0] b_i;
reg signed	[15:0] c_i;
reg signed	[15:0] d_i;
//reg signed	[15:0] next_a_i;
//reg signed	[15:0] next_b_i;
//reg signed	[15:0] next_c_i;
//reg signed	[15:0] next_d_i;
reg [3:0] count;
reg [3:0] next_count;

// calculate
reg signed	[15:0] d_minus_a;
reg signed	[15:0] d_plus_a;
reg signed	[15:0] c_minus_b;
reg signed	[15:0] c_plus_b;

reg signed	[15:0] next_d_minus_a;
reg signed	[15:0] next_d_plus_a;
reg signed	[15:0] next_c_minus_b;
reg signed	[15:0] next_c_plus_b;

// vector mode
reg vector_enable;
reg next_vector_enable;

wire [31:0] theta_plus;
wire [31:0] theta_minus;

reg signed [31:0] theta_plus_reg;
reg signed [31:0] theta_minus_reg;
reg signed [31:0] next_theta_plus_reg;
reg signed [31:0] next_theta_minus_reg;

reg [4:0] count_pipeline;
reg [4:0] next_count_pipeline;

// angle processing
reg signed[31:0] theta_left;
reg signed[31:0] theta_right;
reg signed[31:0] next_theta_left;
reg signed[31:0] next_theta_right;

// rotation mode 
reg rotation_enable;
reg next_rotation_enable;
wire	[15:0] sin_left;
wire	[15:0] cos_left;
wire	[15:0] sin_right;
wire	[15:0] cos_right;
reg signed	[15:0] sin_left_reg;
reg signed	[15:0] cos_left_reg;
reg signed	[15:0] sin_right_reg;
reg signed	[15:0] cos_right_reg;
reg signed	[15:0] next_sin_left_reg;
reg signed	[15:0] next_cos_left_reg;
reg signed	[15:0] next_sin_right_reg;
reg signed	[15:0] next_cos_right_reg;

// output calculation
reg signed	[31:0] a_1;
reg signed	[31:0] b_1;
reg signed	[31:0] c_1;
reg signed	[31:0] d_1; 
reg signed	[47:0] s_1;
reg signed	[47:0] s_2;  

reg signed	[31:0] next_a_1;
reg signed	[31:0] next_b_1;
reg signed	[31:0] next_c_1;
reg signed	[31:0] next_d_1; 
reg signed	[47:0] next_s_1;
reg signed	[47:0] next_s_2; 

// state 
reg [2:0] state;
reg [2:0] next_state; 

cordic_v vector_plus
(
    .clk                (clk        ),
    .rst                (rst        ),
    .x_in               (d_minus_a  ),
    .y_in               (c_plus_b   ), 
    .phase_out          (theta_plus ),
	.enable             (vector_enable)
);
cordic_v vector_minus
(
    .clk                (clk        ),
    .rst                (rst        ),
    .x_in               (d_plus_a   ),
    .y_in               (c_minus_b  ), 
    .phase_out          (theta_minus),
	.enable             (vector_enable)
);
cordic_r rotation_left
(
    .clk            	(clk        ),
    .rst              	(rst        ),
    .Phase              (theta_left ),
    .Sin                (sin_left   ),
    .Cos                (cos_left   ),
	.enable             (rotation_enable)
);
cordic_r rotation_right
(
    .clk            	(clk        ),
    .rst             	(rst        ),
    .Phase              (theta_right),
    .Sin                (sin_right  ),
    .Cos                (cos_right  ),
	.enable             (rotation_enable)
);

always @(*) begin
		next_state = state; 
		next_count = count; 
		next_count_pipeline = count_pipeline; 
		
		next_d_minus_a = d_minus_a ;
		next_d_plus_a = d_plus_a;
		next_c_minus_b = c_minus_b;
		next_c_plus_b = c_plus_b;
		
		next_vector_enable = vector_enable;
		next_rotation_enable = rotation_enable;
		
		//next_a_i = a_i;
		//next_b_i = b_i;
		//next_c_i = c_i;
		//next_d_i = d_i; 
		next_data_o_S = data_o_S;
		
		next_theta_plus_reg = theta_plus_reg;
		next_theta_minus_reg = theta_minus_reg;

		next_theta_left = theta_left;
		next_theta_right = theta_right;
		
		next_sin_left_reg = sin_left_reg;
		next_cos_left_reg = cos_left_reg;
		next_sin_right_reg = sin_right_reg;
		next_cos_right_reg = cos_right_reg;
		
		next_a_1 = a_1;
		next_b_1 = b_1;
		next_c_1 = c_1;
		next_d_1 = d_1;
		next_s_1 = s_1;
		next_s_2 = s_2;
		
		next_ready = ready;
		
	case(state)
		IDLE:begin
		    next_ready = 0;
			next_data_o_S[7:0] = 0;
			if(data_in)begin 
				next_state = DATAIN;
			end
			else begin
				next_state = IDLE;
			end
		end
		
		DATAIN:begin
			//next_a_i = a_i;
			//next_b_i = b_i;
			//next_c_i = c_i;
			//next_d_i = d_i;
			if(count==3'b000) begin 
				//next_a_i[7:0] = data_i[7:0]; 
				next_count = 3'b001;
			end
			else if(count==3'b001) begin 
				//next_a_i[15:8] = data_i[7:0]; 
				next_count = 3'b010;
			end
			else if(count==3'b010) begin 
				//next_b_i[7:0] = data_i[7:0]; 
				next_count = 3'b011;
			end
			else if(count==3'b011) begin 
				//next_b_i[15:8] = data_i[7:0]; 
				next_count = 3'b0; 
			end
			
			if(count==3'b011) next_state = CALCULATE;
			else next_state = DATAIN;
		end
		
		CALCULATE:begin
			next_d_minus_a = d_i - a_i;
			next_d_plus_a  = d_i + a_i;
			next_c_minus_b = c_i - b_i;
			next_c_plus_b  = c_i + b_i;
		    next_state = VECTOR;
		end
		
		VECTOR:begin
			next_theta_plus_reg = theta_plus_reg;
			next_theta_minus_reg = theta_minus_reg;
		    if(count_pipeline==5'b0)begin
				next_vector_enable = 1'b1;
				next_state = VECTOR;
				next_count_pipeline = count_pipeline + 1 ;
			end
			else if(count_pipeline < 5'd18)begin
				next_state = VECTOR;
				next_count_pipeline = count_pipeline + 1 ;
			end
			else begin
				next_vector_enable = 1'b0;
				next_state = ANGLE;
				next_count_pipeline = 5'b0;	
				 
				next_theta_plus_reg = theta_plus ;
				next_theta_minus_reg = theta_minus ;
				next_theta_plus_reg = next_theta_plus_reg >>> 1 ;
				next_theta_minus_reg = next_theta_minus_reg >>> 1 ; 
			end 
		end
		
		ANGLE:begin 
			next_theta_right =  theta_plus_reg  + theta_minus_reg ;
			next_theta_left  =  theta_plus_reg  - theta_minus_reg ; 
			next_state = ROTATE;
		end
		
		ROTATE:begin
			next_sin_left_reg = sin_left_reg;
			next_cos_left_reg = cos_left_reg;
			next_sin_right_reg = sin_right_reg;
			next_cos_right_reg = cos_right_reg;
		    if(count_pipeline==5'b0)begin
				next_rotation_enable = 1'b1;
				next_state = ROTATE;
				next_count_pipeline = count_pipeline + 1 ;
			end
			else if(count_pipeline < 5'd19)begin
				next_state = ROTATE;
				next_count_pipeline = count_pipeline + 1 ;
			end
			else begin
				next_rotation_enable = 1'b0;
				next_state = OUTPUT_CAL;
				next_count_pipeline = 5'b0;	
				
				next_sin_left_reg = sin_left;
				next_cos_left_reg = cos_left;
				next_sin_right_reg = sin_right;
				next_cos_right_reg = cos_right;
			end 
		end   
		
		OUTPUT_CAL:begin
			if(count==0)begin
				next_a_1 = a_i * cos_left_reg - c_i * sin_left_reg;
				next_b_1 = b_i * cos_left_reg - d_i * sin_left_reg;
				next_c_1 = a_i * sin_left_reg + c_i * cos_left_reg;
				next_d_1 = b_i * sin_left_reg + d_i * cos_left_reg;
				next_state = OUTPUT_CAL;
				next_count = 1;
			end
			else if(count==1)begin 
				next_s_1 = a_1 * cos_right_reg - b_1 * sin_right_reg;
				next_s_2 = c_1 * sin_right_reg + d_1 * cos_right_reg; 
				next_state = OUTPUT;
				next_ready = 1;
				next_count = 0;
			end
		end 
		
		OUTPUT:begin
			next_data_o_S = data_o_S;
			if(count==3'b000) begin 
				next_data_o_S[7:0] = s_1[23:16]; 
				next_count = 3'b001;
			end
			else if (count==3'b001) begin 
				next_data_o_S[7:0] = s_1[31:24]; 
				next_count = 3'b010;
			end 
			else if (count==3'b010) begin 
				next_data_o_S[7:0] = s_2[23:16]; 
				next_count = 3'b011;
			end 
			else if (count==3'b011) begin 
				next_data_o_S[7:0] = s_2[31:24]; 
				next_count = 3'b000;
			end 
			
			if(count==3'b011) begin
			next_state = IDLE;
			next_ready = 1;
			end
			else next_state = OUTPUT;
		end
		
	endcase 
end

always @(posedge clk or negedge rst) begin
	if(~rst) begin
		state <= 3'b0; 
		
		count <=3'b0; 
		count_pipeline <=4'b0; 
		
		d_minus_a <=3'b0;
		d_plus_a <=3'b0;
		c_minus_b <=3'b0;
		c_plus_b <=3'b0;  
		
		vector_enable <= 0; 
		rotation_enable <= 0; 
		
		a_i <= 0; 
		b_i <= 0;
		c_i <= 0;
		d_i <= 0;
		data_o_S <= 0;
		  
		theta_plus_reg <= 0;
		theta_minus_reg <= 0; 
		
		theta_left <= 0;
		theta_right <= 0; 

		sin_left_reg <= 0;
		cos_left_reg <= 0;
		sin_right_reg <= 0;
		cos_right_reg <= 0; 
		
		a_1 <= 0;
		b_1 <= 0;
		c_1 <= 0;
		d_1 <= 0;
		s_1 <= 0;
		s_2 <= 0; 
		
		ready <= 0; 
	end 
	
	else if( data_in ) begin 
		count <= next_count;
		state <= next_state; 
		if(next_count==3'b000) begin
			a_i[15:0] <= data_i[15:0];
		end
		else if(next_count==3'b001) begin
			b_i[15:0] <= data_i[15:0];
		end
		else if(next_count==3'b010) begin
			c_i[15:0] <= data_i[15:0];
		end	
		else if(next_count==3'b011) begin
			d_i[15:0] <= data_i[15:0];
		end
	end
		
 	else begin
		state <= next_state; 
		count <= next_count; 
		count_pipeline <= next_count_pipeline; 
		
		d_minus_a <= next_d_minus_a ;
		d_plus_a <= next_d_plus_a;
		c_minus_b <= next_c_minus_b;
		c_plus_b <= next_c_plus_b;
		
		vector_enable <= next_vector_enable;
		rotation_enable <= next_rotation_enable;
		
		//a_i <= next_a_i;
		//b_i <= next_b_i;
		//c_i <= next_c_i;
		//d_i <= next_d_i; 
		data_o_S <= next_data_o_S;
		
		theta_plus_reg <= next_theta_plus_reg;
		theta_minus_reg <= next_theta_minus_reg;

		theta_left <= next_theta_left;
		theta_right <= next_theta_right;
		
		sin_left_reg <= next_sin_left_reg;
		cos_left_reg <= next_cos_left_reg;
		sin_right_reg <= next_sin_right_reg;
		cos_right_reg <= next_cos_right_reg;
		
		a_1 <= next_a_1;
		b_1 <= next_b_1;
		c_1 <= next_c_1;
		d_1 <= next_d_1;
		s_1 <= next_s_1;
		s_2 <= next_s_2;
		
		ready <= next_ready;
		
	end
end

endmodule




