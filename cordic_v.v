module cordic_v(clk,rst,enable,x_in,y_in,phase_out);
parameter WIDTH=16;
input clk,rst,enable;
input [WIDTH-1:0] x_in,y_in;
output reg signed [31:0] phase_out;  //输入输出端口申明
reg signed [WIDTH-1:0] x0,y0;   //输入数据寄存器
reg signed [WIDTH-1:0] x1,y1;
reg signed [WIDTH-1:0] x2,y2;
reg signed [WIDTH-1:0] x3,y3;
reg signed [WIDTH-1:0] x4,y4;
reg signed [WIDTH-1:0] x5,y5;
reg signed [WIDTH-1:0] x6,y6;
reg signed [WIDTH-1:0] x7,y7;
reg signed [WIDTH-1:0] x8,y8;
reg signed [WIDTH-1:0] x9,y9;
reg signed [WIDTH-1:0] x10,y10;
reg signed [WIDTH-1:0] x11,y11;
reg signed [WIDTH-1:0] x12,y12;
reg signed [WIDTH-1:0] x13,y13;
reg signed [WIDTH-1:0] x14,y14;
reg signed [WIDTH-1:0] x15,y15;  //15级流水寄存器

reg signed [31:0] z0,z1,z2,z3,z4,z5,z6,z7;   //输入数据寄存器
reg signed [31:0] z8,z9,z10,z11,z12,z13,z14,z15;

always @(posedge clk or negedge rst)
begin
  if(~rst) begin
	x0<=16'h0;
	y0<=0;
	z0<=0;
  end
  else begin 
	if (enable) begin
		if(x_in[15]==1'b0) begin  //目标角度初处理，因为目标角度旋转范围[-99.9，99.9]
			x0<=x_in;
			y0<=y_in ;
			z0<=32'h0;
		end                    //若(x,y)在第一、四象限，那么预旋转0度
		else if(y_in[15]==0) begin
			x0<=y_in;
			y0<=(-x_in) ;
			z0<=32'h4000_0000;
		end            //若(x,y)在第二象限，那么预旋转90度
		else begin
			x0<=-(y_in);
			y0<=x_in;
			z0<=-32'h4000_0000;
		end              //若(x,y)在第三象限，那么预旋转-90度
	end
	else begin
		x0<=16'h0;
		y0<=0;
		z0<=0;
	end
  end   
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x1<=0;
		y1<=0;
		z1<=0;
	end
	
	else begin  
		if(enable) begin
			if(y0[15]==1) begin
				x1<=x0-y0;
				y1<=y0+x0;
			z1<=z0-32'h2000_0000;
			end          
			else begin
				x1<=x0+y0;
				y1<=y0-x0;
				z1<=z0+32'h2000_0000;
			end 
		end
		else begin
			x1<=0;
			y1<=0;
			z1<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x2<=0;
		y2<=0;
		z2<=0;
	end
	
	else begin  
		if(enable) begin
			if(y1[15]==1) begin
				x2<=x1-(y1 >>> 1);
				y2<=y1+(x1 >>> 1);
				z2<=z1-32'd316933988;
			end          
			else begin
				x2<=x1+(y1 >>> 1);
				y2<=y1-(x1 >>> 1);
				z2<=z1+32'd316933988;
			end 
		end
		else begin
			x2<=0;
			y2<=0;
			z2<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x3<=0;
		y3<=0;
		z3<=0;
	end
	
	else begin  
		if(enable) begin
			if(y2[15]==1) begin
				x3<=x2-(y2 >>> 2);
				y3<=y2+(x2 >>> 2);
				z3<=z2-32'd167458389;
			end          
			else begin
				x3<=x2+(y2 >>> 2);
				y3<=y2-(x2 >>> 2);
				z3<=z2+32'd167458389;
			end 
		end
		else begin
			x3<=0;
			y3<=0;
			z3<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x4<=0;
		y4<=0;
		z4<=0;
	end
	
	else begin  
		if(enable) begin
			if(y3[15]==1) begin
				x4<=x3-(y3 >>> 3);
				y4<=y3+(x3 >>> 3);
				z4<=z3-32'd85004561;
			end          
			else begin
				x4<=x3+(y3 >>> 3);
				y4<=y3-(x3 >>> 3);
				z4<=z3+32'd85004561;
			end 
		end
		else begin
			x4<=0;
			y4<=0;
			z4<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x5<=0;
		y5<=0;
		z5<=0;
	end
	
	else begin  
		if(enable) begin
			if(y4[15]==1) begin
				x5<=x4-(y4 >>> 4);
				y5<=y4+(x4 >>> 4);
				z5<=z4-32'd42666921;
			end          
			else begin
				x5<=x4+(y4 >>> 4);
				y5<=y4-(x4 >>> 4);
				z5<=z4+32'd42666921;
			end 
		end
		else begin
			x5<=0;
			y5<=0;
			z5<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x6<=0;
		y6<=0;
		z6<=0;
	end
	
	else begin  
		if(enable) begin
			if(y5[15]==1) begin
				x6<=x5-(y5 >>> 5);
				y6<=y5+(x5 >>> 5);
				z6<=z5-32'd21354339;
			end          
			else begin
				x6<=x5+(y5 >>> 5);
				y6<=y5-(x5 >>> 5);
				z6<=z5+32'd21354339;
			end 
		end
		else begin
			x6<=0;
			y6<=0;
			z6<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x7<=0;
		y7<=0;
		z7<=0;
	end
	
	else begin  
		if(enable) begin
			if(y6[15]==1) begin
				x7<=x6-(y6 >>> 6);
				y7<=y6+(x6 >>> 6);
				z7<=z6-32'd10680152;
			end          
			else begin
				x7<=x6+(y6 >>> 6);
				y7<=y6-(x6 >>> 6);
				z7<=z6+32'd10680152;
			end 
		end
		else begin
			x7<=0;
			y7<=0;
			z7<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x8<=0;
		y8<=0;
		z8<=0;
	end
	
	else begin  
		if(enable) begin
			if(y7[15]==1) begin
				x8<=x7-(y7 >>> 7);
				y8<=y7+(x7 >>> 7);
				z8<=z7-32'd5340076;
			end          
			else begin
				x8<=x7+(y7 >>> 7);
				y8<=y7-(x7 >>> 7);
				z8<=z7+32'd5340076;
			end 
		end
		else begin
			x8<=0;
			y8<=0;
			z8<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x9<=0;
		y9<=0;
		z9<=0;
	end
	
	else begin  
		if(enable) begin
			if(y8[15]==1) begin
				x9<=x8-(y8 >>> 8);
				y9<=y8+(x8 >>> 8);
				z9<=z8-32'd2670038;
			end          
			else begin
				x9<=x8+(y8 >>> 8);
				y9<=y8-(x8 >>> 8);
				z9<=z8+32'd2670038;
			end 
		end
		else begin
			x9<=0;
			y9<=0;
			z9<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x10<=0;
		y10<=0;
		z10<=0;
	end
	
	else begin  
		if(enable) begin
			if(y9[15]==1) begin
				x10<=x9-(y9 >>> 9);
				y10<=y9+(x9 >>> 9);
				z10<=z9-32'd1335019;
			end          
			else begin
				x10<=x9+(y9 >>> 9);
				y10<=y9-(x9 >>> 9);
				z10<=z9+32'd1335019;
			end 
		end
		else begin
			x10<=0;
			y10<=0;
			z10<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x11<=0;
		y11<=0;
		z11<=0;
	end
	
	else begin  
		if(enable) begin
			if(y10[15]==1) begin
				x11<=x10-(y10 >>> 10);
				y11<=y10+(x10 >>> 10);
				z11<=z10-32'd668106;
			end          
			else begin
				x11<=x10+(y10 >>> 10);
				y11<=y10-(x10 >>> 10);
				z11<=z10+32'd668106;
			end 
		end
		else begin
			x11<=0;
			y11<=0;
			z11<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x12<=0;
		y12<=0;
		z12<=0;
	end
	
	else begin  
		if(enable) begin
			if(y11[15]==1) begin
				x12<=x11-(y11 >>> 11);
				y12<=y11+(x11 >>> 11);
				z12<=z11-32'd334053;
			end          
			else begin
				x12<=x11+(y11 >>> 11);
				y12<=y11-(x11 >>> 11);
				z12<=z11+32'd334053;
			end 
		end
		else begin
			x12<=0;
			y12<=0;
			z12<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x13<=0;
		y13<=0;
		z13<=0;
	end
	
	else begin  
		if(enable) begin
			if(y12[15]==1) begin
				x13<=x12-(y12 >>> 12);
				y13<=y12+(x12 >>> 12);
				z13<=z12-32'd167027;
			end          
			else begin
				x13<=x12+(y12 >>> 12);
				y13<=y12-(x12 >>> 12);
				z13<=z12+32'd167027;
			end 
		end
		else begin
			x13<=0;
			y13<=0;
			z13<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x14<=0;
		y14<=0;
		z14<=0;
	end
	
	else begin  
		if(enable) begin
			if(y13[15]==1) begin
				x14<=x13-(y13 >>> 13);
				y14<=y13+(x13 >>> 13);
				z14<=z13-32'd83513;
			end          
			else begin
				x14<=x13+(y13 >>> 13);
				y14<=y13-(x13 >>> 13);
				z14<=z13+32'd83513;
			end 
		end
		else begin
			x14<=0;
			y14<=0;
			z14<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		x15<=0;
		y15<=0;
		z15<=0;
	end
	
	else begin  
		if(enable) begin
			if(y14[15]==1) begin
				x15<=x14-(y14 >>> 14);
				y15<=y14+(x14 >>> 14);
				z15<=z14-32'd41757;
			end          
			else begin
				x15<=x14+(y14 >>> 14);
				y15<=y14-(x14 >>> 14);
				z15<=z14+332'd41757;
			end 
		end
		else begin
			x15<=0;
			y15<=0;
			z15<=0;
		end
	end
end
always @(posedge clk or negedge rst)
begin
	if(~rst) begin
		phase_out<=0;
	end
	else begin
		if(enable) begin
			case(z15[31:30])
				2'b00: phase_out<=z15;
				2'b01: phase_out<={2'b11,z15[29:0]};
				2'b10: phase_out<={2'b00,z15[29:0]};
				2'b11: phase_out<=z15;
			endcase				
		end
		else begin
			phase_out<=0;
		end
	end
end
endmodule
