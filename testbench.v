// This is test bench for half precision addition and multiplication

module tb();

reg clk, reset83, start83;
reg [15:0] a83, b83;
wire [15:0] ans83;
wire done83;
integer count83=0;

parameter a1 = 16'b0010111001100110, b1 = 16'b0011010000000000; // a83=0.1, b83=0.25
parameter a2 = 16'b0011001001100110, b2 = 16'b1011101100110011; // a83=0.2, b83=-0.9
parameter a3 = 16'b0011010000000000, b3 = 16'b0011000000000000; // a83=0.25, b83=0.125
parameter a4 = 16'b1011010011001100, b4 = 16'b0011101001100110; // a83=-0.3, b83=0.8
parameter a5 = 16'b0011011001100110, b5 = 16'b0011101100000000; // a83=0.4, b83=0.875
parameter a6 = 16'b0011100000000000, b6 = 16'b1011101000000000; // a83=0.5, b83=-0.75
parameter a7 = 16'b0011100001100110, b7 = 16'b0011010011001100; // a83=0.55, b83=0.3
parameter a8 = 16'b0011100011001100, b8 = 16'b0011100011001100; // a83=0.6, b83=0.6
parameter a9 = 16'b1011101000000000, b9 = 16'b0010111001100110; // a83=-0.75, b83=0.1
parameter a10 = 16'b0011101001100110, b10 = 16'b0011001001100110; // a83=0.8, b83=0.2
parameter a11 = 16'b0011101100000000, b11 = 16'b1011011001100110; // a83=0.875, b83=-0.4
parameter a12 = 16'b0011101100110011, b12 = 16'b0011100001100110; // a83=0.9, b83=0.55

halfPrecision dut(clk, reset83, start83, a83, b83, ans83, done83);

always @(*) begin
	
	case(count83)
	0 : begin
	a83 = a1;
	b83 = b1;
	if(done83==0)	
		start83 = 1;

	$display("Here");
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end
	
	1 : begin
	a83 = a2;
	b83 = b2;
	if(done83==0)	
		start83 = 1;
	$display("#################### Here 2 ######################");
	if(done83 && start83) begin
		start83 = 0;
	$display("#################### Here 3 ######################");

		count83 = count83 + 1;
	end	
	end

	2 : begin
	a83 = a3;
	b83 = b3;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	3 : begin
	a83 = a4;
	b83 = b4;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	4 : begin
	a83 = a5;
	b83 = b5;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
	start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	5 : begin
	a83 = a6;
	b83 = b6;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	6 : begin
	a83 = a7;
	b83 = b7;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	7 : begin
	a83 = a8;
	b83 = b8;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	8 : begin
	a83 = a9;
	b83 = b9;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	9 : begin
	a83 = a10;
	b83 = b10;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	10 : begin
	a83 = a11;
	b83 = b11;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	end	
	end

	11 : begin
	a83 = a12;
	b83 = b12;
	if(done83==0)
		start83 = 1;
	if(done83 && start83) begin
		start83 = 0;
	$display("Here count83 : %0d",count83);
		count83 = count83 + 1;
	$finish;
	end	
	end

	endcase
	
	if(count83>12 && done83)
		$finish;

end

initial begin
    clk=1;
    repeat(250000) begin
        #2 clk=~clk;
    end
    $display("Ran out of clocks");
    $finish;
end

initial begin
$dumpfile("test.vcd");
$dumpvars();
end


endmodule

