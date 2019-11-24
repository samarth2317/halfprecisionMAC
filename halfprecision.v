// This is full code for half precesion addition and multiplication. This will
// perform dot product of applied sequence from the test bench.

module halfPrecision(input clk83, input reset83, input start83, input signed [15:0] a83, input signed [15:0] b83, output reg [15:0] ans83, output reg done83);

reg [3:0] p_state83, n_state83;
reg sign_a83, sign_b83, sign_ans83, sign_ansM83;
reg [4:0] exp_a83, exp_b83, exp_ans83, exp_ansM83;
reg [9:0] man_a83, man_b83, man_ans83, man_ansM83;
reg [15:0] ansM83;
reg [14:0] temp83;
reg [21:0] tempMult83;
reg [10:0] tempAdd83;
parameter idle83 = 4'b0000, convertToBinary83 = 4'b0001, add83 = 4'b0011, mult83 = 4'b0100, align83 = 4'b0101, initialize83 = 4'b0110;
integer count83,i83;
reg flag_start83, flag_trans83;


initial begin
ans83 <= 0;
done83 <= 0;
sign_a83 <= 0;
sign_b83 <= 0;
exp_a83 <= 0;
exp_b83 <= 0;
man_a83 <= 0;
man_b83 <= 0;
temp83 <= 0;
count83 <= 0;
sign_ansM83 <= 1'b0;
exp_ansM83 <= 0;
man_ansM83 <= 0;
ans83 <= 0;
sign_ans83 <= 0;
exp_ans83 <= 0;
man_ans83 <= 0;
flag_start83 <= 0;
flag_trans83 <= 0;
n_state83 <= idle83;
end

always @(posedge clk83) begin
	if(reset83) begin
	$display("#################### reset ####################");
	ans83 <= 0;
	done83 <= 0;
        sign_a83 <= 0;
        sign_b83 <= 0;
        exp_a83 <= 0;
        exp_b83 <= 0;
        man_a83 <= 0;
        man_b83 <= 0;
	temp83 <= 0;
	count83 <= 0;
	sign_ansM83 <= 1'b0;
	exp_ansM83 <= 0;
	man_ansM83 <= 0;
	ans83 <= 0;
	sign_ans83 <= 0;
	exp_ans83 <= 0;
	man_ans83 <= 0;
	//p_state83 <= idle83;
	n_state83 <= idle83;
	end
/*	else begin
	p_state83 <= n_state83;
	end
*/
end

always @(*) begin

case (n_state83)
idle83 : begin	// idle83 state waiting for start83 signal
	$display("------------ Start : %b --------------", start83);
	n_state83 = idle83;
	if(start83) n_state83 = initialize83;
end

initialize83 : begin	// initialize83 state for initializing all the signals
sign_a83 = a83[15];
sign_b83 = b83[15];
exp_a83 = a83[14:10];
exp_b83 = b83[14:10];
man_a83 = a83[9:0];
man_b83 = b83[9:0];
//done = 0;
n_state83 = mult83;
end

convertToBinary83 : begin


end

// ------------- Addition state starts --------------- //

add83 : begin
	$display("count83 : %0d, signAns : %b, expAns : %b, manAns : %b",count83,sign_ans83,exp_ans83,man_ans83);
	
	if(sign_ans83 == 0 && exp_ans83 == 0 && man_ans83 == 0) begin
		done83 = 1;
		sign_ans83 = sign_ansM83;
		exp_ans83 = exp_ansM83;
		man_ans83 = man_ansM83;
		count83 = count83 + 1;
		ans83 = {sign_ans83,exp_ans83,man_ans83};
		$display("Answer %0d : %b",count83,ans83);
		//if(start83==0)	n_state83 = idle83;
	end
	
	else if(flag_start83 && flag_trans83==0) begin
	sign_ans83 = sign_ans83 ^ sign_ansM83;
	if(exp_ans83 != exp_ansM83) 
		n_state83 = align83;
	else begin
		if(sign_ans83 != sign_ansM83) begin
			if(man_ans83 > man_ansM83) begin
				man_ansM83 = ~man_ansM83 + 1;
				$display("2's comp Mantissa man_ansM83 : %b",man_ansM83);
			end
			else begin
				man_ans83 = ~man_ans83 + 1;
				$display("2's comp Mantissa man_ans83 : %b",man_ans83);
			end
		end
		//exp_ans83 = exp_ansM83;
		tempAdd83 = {1'b1,man_ans83} + {1'b1,man_ansM83};
	exp_ans83 = exp_ansM83;
		man_ans83 = tempAdd83[9:0];
		flag_trans83 = 1;
			$display(" Answer %0d : %b",count83,ans83);
		done83 = 1;
		count83 = count83 + 1;
		if(count83 >= 12) begin
			done83 = 1;
			ans83 = {sign_ans83,exp_ans83,man_ans83};
			$display("Answer %0d : %b",count83,ans83);
			if(start83==0)	n_state83 = idle83;
		end
		//n_state83 = idle83;
	end
	end
	else if(done83 && (start83==0)) begin
		n_state83 = idle83;
		flag_start83 = 1;
		done83 = 0;
		flag_trans83 = 0;
		$display("****** Here *******");
	end
end

// ------------- Addition state ends --------------- //
//
// ------------- Multiplication state starts -------------- //

mult83 : begin
	sign_ansM83 = sign_a83 ^ sign_b83;
	exp_ansM83 = exp_a83 + exp_b83 - 15;
	//$display(" expAns : %b",exp_ans83);
	tempMult83 = multiplication({1'b1,man_a83}, {1'b1,man_b83});
	$display("tempMult83 : %b",tempMult83);
	case(tempMult83[21:20])
	2'b01:	man_ansM83 = tempMult83[19:10];
	2'b10:	begin
		man_ansM83 = tempMult83[20:11];
		exp_ansM83 = exp_ansM83 + 1;
	end
	2'b11:	begin
		man_ansM83 = tempMult83[20:11];
		exp_ansM83 = exp_ansM83 + 1;
	end
	endcase
	//done = 1;
	ansM83 = {sign_ansM83,exp_ansM83,man_ansM83};
	$display("sign_ansM : %b, exp_ansM83 : %b, man_ansM83 : %b",sign_ansM83,exp_ansM83,man_ansM83);
	$display(" - - - - - - - ansM83 : %b",ansM83);
	n_state83 = add83;

end

// ------------- Multiplication state ends -------------- //

align83 : begin
$display("-----Norm------");
if(exp_ans83 > exp_ansM83) begin
	$display("------- exp_ans83 > exp_ansM83 --------");
	if( (exp_ans83-exp_ansM83) == 1)	begin
		man_ansM83 = man_ansM83 >> 1;
		man_ansM83[9] = 1'b1;
	end
	else begin
		man_ansM83 = man_ansM83 >> 1;
		man_ansM83[9] = 1'b1;
		man_ansM83 = man_ansM83 >> (exp_ans83 - exp_ansM83 -1);
	end
	exp_ansM83 = exp_ans83;
	$display("\n!!!!!!!!!!!!!!!!! expAns : %b, manAns : %b, expAnsM : %b, manAnsM : %b ",exp_ans83,man_ans83,exp_ansM83,man_ansM83);
end
else begin
	$display("-------- exp_ansM83 > exp_ans83 ---------");
	if( (exp_ansM83-exp_ans83) == 1)	begin
		man_ans83 = man_ans83 >> 1;
		man_ans83[9] = 1'b1;
	end
	else begin
		man_ans83 = man_ans83 >> 1;
		man_ans83[9] = 1'b1;
		man_ans83 = man_ans83 >> (exp_ansM83 - exp_ans83 -1);
	end
	exp_ans83 = exp_ansM83;
	$display("\n!!!!!!!!!!!!!!!!! expAns : %b, manAns : %b, expAnsM : %b, manAnsM : %b ",exp_ans83,man_ans83,exp_ansM83,man_ansM83);
end
if(exp_ans83 == exp_ansM83) begin
	n_state83 = add83;
	$display("------- a83 = b83 --------");
end
else begin
	n_state83 = align83;
	$display("------- a83 != b83 --------");
end
end

endcase

end

function [21:0] multiplication (input [10:0] a83, input [10:0] b83);
	begin
	multiplication = a83*b83;
	$display("a83 : %b , b83 : %b, Mantissa mult83 : %b",a83,b83,multiplication);
	end
endfunction


endmodule

