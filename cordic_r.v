module cordic_r
(
    clk,rst,
    enable,Phase,
    Sin,Cos
);

input                       clk;
input                       rst;
input						enable;
input       [31:0]          Phase;
output      [15:0]          Sin;
output      [15:0]          Cos;
/*
`define rot0  32'd2147483648   //45     //0010_0000_0000_0000_0000_0000_0000_0000
`define rot1  32'd1267733623      
`define rot2  32'd669835630      
`define rot3  32'd340019024        
`define rot4  32'd170669324       
`define rot5  32'd85417861     
`define rot6  32'd42719353      
`define rot7  32'd21360980         
`define rot8  32'd10680653        
`define rot9  32'd5340347       
`define rot10 32'd2670176         
`define rot11 32'd1335088        
`define rot12 32'd667544           
`define rot13 32'd333772           
`define rot14 32'd166886          
`define rot15 32'd83443         */     

`define rot0  32'd536870912
`define rot1  32'd316933405      
`define rot2  32'd167458907     
`define rot3  32'd85004756        
`define rot4  32'd42667331       
`define rot5  32'd21354465     
`define rot6  32'd10679838      
`define rot7  32'd5340245         
`define rot8  32'd2670163        
`define rot9  32'd1335086       
`define rot10 32'd667544         
`define rot11 32'd333772        
`define rot12 32'd166886          
`define rot13 32'd83443          
`define rot14 32'd41721          
`define rot15 32'd20860 
       
parameter Pipeline = 16;
parameter K = 16'd156;   //0.6072*2^8

reg signed  [15:0]      Sin;
reg signed  [15:0]      Cos;
reg signed  [15:0]      x0,y0;
reg signed  [15:0]      x1,y1;
reg signed  [15:0]      x2,y2;
reg signed  [15:0]      x3,y3;
reg signed  [15:0]      x4,y4;
reg signed  [15:0]      x5,y5;
reg signed  [15:0]      x6,y6;
reg signed  [15:0]      x7,y7;
reg signed  [15:0]      x8,y8;
reg signed  [15:0]      x9,y9;
reg signed  [15:0]      x10,y10;
reg signed  [15:0]      x11,y11;
reg signed  [15:0]      x12,y12;
reg signed  [15:0]      x13,y13;
reg signed  [15:0]      x14,y14;
reg signed  [15:0]      x15,y15;
reg signed  [15:0]      x16,y16;
reg signed  [31:0]      z0,z1,z2,z3,z4,z5,z6,z7;  
reg signed  [31:0]      z8,z9,z10,z11,z12,z13,z14,z15,z16;
reg         [ 1:0]      Quadrant [Pipeline:0];

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x0 <= 1'b0;                         
        y0 <= 1'b0;
        z0 <= 1'b0;
    end
    else begin
		if(enable)
		begin
			x0 <= K;
			y0 <= 16'd0;
			z0 <= {2'b00,Phase[29:0]} ;
		end
		else  
		begin
			x0 <= 1'b0;                         
			y0 <= 1'b0;
			z0 <= 1'b0;
		end
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x1 <= 1'b0;                         
        y1 <= 1'b0;
        z1 <= 1'b0;
    end
	else 
	begin
		if(enable) 
		begin
			if(z0[31])
			begin
				x1 <= x0 + y0;
				y1 <= y0 - x0;
				z1 <= z0 + `rot0;
			end
			else
			begin
				x1 <= x0 - y0;
				y1 <= y0 + x0;
				z1 <= z0 - `rot0;
			end
		end
		else begin
			x1 <= 1'b0;                         
			y1 <= 1'b0;
			z1 <= 1'b0;
		end
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x2 <= 1'b0;                         
        y2 <= 1'b0;
        z2 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z1[31])
			begin
				x2 <= x1 + (y1 >>> 1);
				y2 <= y1 - (x1 >>> 1);
				z2 <= z1 + `rot1;
			end
			else
			begin
				x2 <= x1 - (y1 >>> 1);
				y2 <= y1 + (x1 >>> 1);
				z2 <= z1 - `rot1;
			end
		end
		else begin
			x2 <= 1'b0;                         
			y2 <= 1'b0;
			z2 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x3 <= 1'b0;                         
        y3 <= 1'b0;
        z3 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z2[31])
			begin
				x3 <= x2 + (y2 >>> 2);
				y3 <= y2 - (x2 >>> 2);
				z3 <= z2 + `rot2;
			end
			else
			begin
				x3 <= x2 - (y2 >>> 2);
				y3 <= y2 + (x2 >>> 2);
				z3 <= z2 - `rot2;
			end
		end
		else begin
			x3 <= 1'b0;                         
			y3 <= 1'b0;
			z3 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x4 <= 1'b0;                         
        y4 <= 1'b0;
        z4 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z3[31])
			begin
				x4 <= x3 + (y3 >>> 3);
				y4 <= y3 - (x3 >>> 3);
				z4 <= z3 + `rot3;
			end
			else
			begin
				x4 <= x3 - (y3 >>> 3);
				y4 <= y3 + (x3 >>> 3);
				z4 <= z3 - `rot3;
			end
		end
		else begin
			x4 <= 1'b0;                         
			y4 <= 1'b0;
			z4 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x5 <= 1'b0;                         
        y5 <= 1'b0;
        z5 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z4[31])
			begin
				x5 <= x4 + (y4 >>> 4);
				y5 <= y4 - (x4 >>> 4);
				z5 <= z4 + `rot4;
			end
			else
			begin
				x5 <= x4 - (y4 >>> 4);
				y5 <= y4 + (x4 >>> 4);
				z5 <= z4 - `rot4;
			end
		end
		else begin
			x5 <= 1'b0;                         
			y5 <= 1'b0;
			z5 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x6 <= 1'b0;                         
        y6 <= 1'b0;
        z6 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z5[31])
			begin
				x6 <= x5 + (y5 >>> 5);
				y6 <= y5 - (x5 >>> 5);
				z6 <= z5 + `rot5;
			end
			else
			begin
				x6 <= x5 - (y5 >>> 5);
				y6 <= y5 + (x5 >>> 5);
				z6 <= z5 - `rot5;
			end
		end
		else begin
			x6 <= 1'b0;                         
			y6 <= 1'b0;
			z6 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x7 <= 1'b0;                         
        y7 <= 1'b0;
        z7 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z6[31])
			begin
				x7 <= x6 + (y6 >>> 6);
				y7 <= y6 - (x6 >>> 6);
				z7 <= z6 + `rot6;
			end
			else
			begin
				x7 <= x6 - (y6 >>> 6);
				y7 <= y6 + (x6 >>> 6);
				z7 <= z6 - `rot6;
			end
		end
		else begin
			x7 <= 1'b0;                         
			y7 <= 1'b0;
			z7 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x8 <= 1'b0;                         
        y8 <= 1'b0;
        z8 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z7[31])
			begin
				x8 <= x7 + (y7 >>> 7);
				y8 <= y7 - (x7 >>> 7);
				z8 <= z7 + `rot7;
			end
			else
			begin
				x8 <= x7 - (y7 >>> 7);
				y8 <= y7 + (x7 >>> 7);
				z8 <= z7 - `rot7;
			end
		end
		else begin
			x8 <= 1'b0;                         
			y8 <= 1'b0;
			z8 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x9 <= 1'b0;                         
        y9 <= 1'b0;
        z9 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z8[31])
			begin
				x9 <= x8 + (y8 >>> 8);
				y9 <= y8 - (x8 >>> 8);
				z9 <= z8 + `rot8;
			end
			else
			begin
				x9 <= x8 - (y8 >>> 8);
				y9 <= y8 + (x8 >>> 8);
				z9 <= z8 - `rot8;
			end
		end
		else begin
			x9 <= 1'b0;                         
			y9 <= 1'b0;
			z9 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x10 <= 1'b0;                         
        y10 <= 1'b0;
        z10 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z9[31])
			begin
				x10 <= x9 + (y9 >>> 9);
				y10 <= y9 - (x9 >>> 9);
				z10 <= z9 + `rot9;
			end
			else
			begin
				x10 <= x9 - (y9 >>> 9);
				y10 <= y9 + (x9 >>> 9);
				z10 <= z9 - `rot9;
			end
		end
		else begin
			x10 <= 1'b0;                         
			y10 <= 1'b0;
			z10 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x11 <= 1'b0;                         
        y11 <= 1'b0;
        z11 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z10[31])
			begin
				x11 <= x10 + (y10 >>> 10);
				y11 <= y10 - (x10 >>> 10);
				z11 <= z10 + `rot10;
			end
			else
			begin
				x11 <= x10 - (y10 >>> 10);
				y11 <= y10 + (x10 >>> 10);
				z11 <= z10 - `rot10;
			end
		end
		else begin
			x11 <= 1'b0;                         
			y11 <= 1'b0;
			z11 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x12 <= 1'b0;                         
        y12 <= 1'b0;
        z12 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z11[31])
			begin
				x12 <= x11 + (y11 >>> 11);
				y12 <= y11 - (x11 >>> 11);
				z12 <= z11 + `rot11;
			end
			else
			begin
				x12 <= x11 - (y11 >>> 11);
				y12 <= y11 + (x11 >>> 11);
				z12 <= z11 - `rot11;
			end
		end
		else begin
			x12 <= 1'b0;                         
			y12 <= 1'b0;
			z12 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x13 <= 1'b0;                         
        y13 <= 1'b0;
        z13 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z12[31])
			begin
				x13 <= x12 + (y12 >>> 12);
				y13 <= y12 - (x12 >>> 12);
				z13 <= z12 + `rot12;
			end
			else
			begin
				x13 <= x12 - (y12 >>> 12);
				y13 <= y12 + (x12 >>> 12);
				z13 <= z12 - `rot12;
			end
		end
		else begin
			x13 <= 1'b0;                         
			y13 <= 1'b0;
			z13 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x14 <= 1'b0;                         
        y14 <= 1'b0;
        z14 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z13[31])
			begin
				x14 <= x13 + (y13 >>> 13);
				y14 <= y13 - (x13 >>> 13);
				z14 <= z13 + `rot13;
			end
			else
			begin
				x14 <= x13 - (y13 >>> 13);
				y14 <= y13 + (x13 >>> 13);
				z14 <= z13 - `rot13;
			end
		end
		else begin
			x14 <= 1'b0;                         
			y14 <= 1'b0;
			z14 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x15 <= 1'b0;                         
        y15 <= 1'b0;
        z15 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z14[31])
			begin
				x15 <= x14 + (y14 >>> 14);
				y15 <= y14 - (x14 >>> 14);
				z15 <= z14 + `rot14;
			end
			else
			begin
				x15 <= x14 - (y14 >>> 14);
				y15 <= y14 + (x14 >>> 14);
				z15 <= z14 - `rot14;
			end
		end
		else begin
			x15 <= 1'b0;                         
			y15 <= 1'b0;
			z15 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        x16 <= 1'b0;                         
        y16 <= 1'b0;
        z16 <= 1'b0;
    end
    else 
	begin 
		if(enable)
		begin
			if(z15[31])
			begin
				x16 <= x15 + (y15 >>> 15);
				y16 <= y15 - (x15 >>> 15);
				z16 <= z15 + `rot15;
			end
			else
			begin
				x16 <= x15 - (y15 >>> 15);
				y16 <= y15 + (x15 >>> 15);
				z16 <= z15 - `rot15;
			end
		end
		else begin
			x16 <= 1'b0;                         
			y16 <= 1'b0;
			z16 <= 1'b0;
		end 
	end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        Quadrant[0] <= 2'b0;
        Quadrant[1] <= 2'b0;
        Quadrant[2] <= 2'b0;
        Quadrant[3] <= 2'b0;
        Quadrant[4] <= 2'b0;
        Quadrant[5] <= 2'b0;
        Quadrant[6] <= 2'b0;
        Quadrant[7] <= 2'b0;
        Quadrant[8] <= 2'b0;
        Quadrant[9] <= 2'b0;
        Quadrant[10] <= 2'b0;
        Quadrant[11] <= 2'b0;
        Quadrant[12] <= 2'b0;
        Quadrant[13] <= 2'b0;
        Quadrant[14] <= 2'b0;
        Quadrant[15] <= 2'b0;
        Quadrant[16] <= 2'b0;
    end
    else
	begin
		if(enable) begin
        Quadrant[0] <= Phase[31:30];
        Quadrant[1] <= Quadrant[0];
        Quadrant[2] <= Quadrant[1];
        Quadrant[3] <= Quadrant[2];
        Quadrant[4] <= Quadrant[3];
        Quadrant[5] <= Quadrant[4];
        Quadrant[6] <= Quadrant[5];
        Quadrant[7] <= Quadrant[6];
        Quadrant[8] <= Quadrant[7];
        Quadrant[9] <= Quadrant[8];
        Quadrant[10] <= Quadrant[9];
        Quadrant[11] <= Quadrant[10];
        Quadrant[12] <= Quadrant[11];
        Quadrant[13] <= Quadrant[12];
        Quadrant[14] <= Quadrant[13];
        Quadrant[15] <= Quadrant[14];
        Quadrant[16] <= Quadrant[15];
		end
		else begin
		Quadrant[0] <= 2'b0;
        Quadrant[1] <= 2'b0;
        Quadrant[2] <= 2'b0;
        Quadrant[3] <= 2'b0;
        Quadrant[4] <= 2'b0;
        Quadrant[5] <= 2'b0;
        Quadrant[6] <= 2'b0;
        Quadrant[7] <= 2'b0;
        Quadrant[8] <= 2'b0;
        Quadrant[9] <= 2'b0;
        Quadrant[10] <= 2'b0;
        Quadrant[11] <= 2'b0;
        Quadrant[12] <= 2'b0;
        Quadrant[13] <= 2'b0;
        Quadrant[14] <= 2'b0;
        Quadrant[15] <= 2'b0;
        Quadrant[16] <= 2'b0;
		end
    end
end

always @ (posedge clk or negedge rst)
begin
    if(!rst)
    begin
        Cos <= 1'b0;
        Sin <= 1'b0;
    end
    else
    begin
		if(enable) begin
        case(Quadrant[16])
            2'b00: 
                begin
                    Cos <= x16;
                    Sin <= y16;
                end
            2'b01: 
                begin
                    Cos <= ~(y16) + 1'b1;
                    Sin <= x16;
                end
            2'b10: 
                begin
                    Cos <= ~(x16) + 1'b1;
                    Sin <= ~(y16) + 1'b1;
                end
            2'b11: 
                begin
                    Cos <= y16;
                    Sin <= ~(x16) + 1'b1;
                end
        endcase
		end
		
		else begin
			Cos <= 1'b0;
			Sin <= 1'b0;
		end
    end
end

endmodule
