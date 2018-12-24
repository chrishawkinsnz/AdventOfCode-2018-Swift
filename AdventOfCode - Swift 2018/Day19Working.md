addi  5 	16 		5	   	// Jump to @J1 (line 18)
seti  1 	 		3	   	// r3 = 1(J3)
seti  1 	 		1		// r1 = 1(J4)
mulr  3 	1 		4		// r4 = r3 * r1 (J5)			
eqrr  4 	2 		4		// r4 = r4 == r2 ? 1 : 0		//							//	if r4 == r2 {
addr  4 	5 		5*		// ip += r4						//  						// 		r0 += r3
addi  5 	1 		5*		// ip += 1						//	Executed if r4 != r2	//	
addr  3 	0 		0		// r0 += r3						//  Executed if r4 == r2  	//	}
addi  1 	1 		1		// r1++								
gtrr  1 	2 		4		// r4 = r1 > r2	? 1 : 0			// 							// if r1 > r2 {
addr  5 	4 		5*		// ip += r4						//							//	stop looping
seti  2 	 		5*		// ip = @J5	(inner loop)		// Skipped if r1 > r2		// }
addi  3 	1 		3		// r3++
gtrr  3 	2 		4		// r4 = r3 > r2 ? 1 : 0			//							// if r3 > r2 {}
addr  4 	5 		5*		// ip += r4						//							// 	stop looping and halt
seti  1 	 		5*		// ip = @J4	(outer loop)		// Skipped if r3 > r2		// }
mulr  5 	5 		5*		// ip *= ip				// HALT
addi  2 	2 		2		// r2 += 2 (J1)			// Whole bunch of maths on r2 and r4, increases r4 loads then increases r2 even more
mulr  2 	2 		2		// r2 *= r2
mulr  5 	2 		2		// r2 *= 19
muli  2 	11 		2		// r2 *= 11
addi  4 	1 		4		// r4++
mulr  4 	5 		4		// r4 *= 22
addi  4 	19 		4		// r4 += 19
addr  2 	4 		2		// r2 += r4
addr  5 	0 		5*		// ip += r0				// |\___If r0 is 0 go to top(J3), if it's 1 continue to @J2
seti  0 	 		5*		// ip = @J3				// |/   
setr  5 	 		4		// r4 = 27 (J2)
mulr  4 	5 		4		// r4 *= 28
addr  5 	4 		4		// r4 += 29
mulr  5 	4 		4		// r4 *= 30
muli  4 	14 		4		// r4 *= 14
mulr  4 	5 		4		// r4 *= 32
addr  2 	4 		2		// r2 += r4				// Assuming J2 runs whole this is eq to r2 = 10550400
seti  0 	 		0		// r0 = 0				// Unset the r0 flag
seti  0 	 		5*		// ip = @J3				// Jump to J3



var r4 = heaps
var r2 = heaps
if (mode2) {
	r2 *= heaps
	r4 *= heaps
	r0 = fals
}
var result //(r0)
var r3 = 1
while true {
	var r1 = 1
	while true {
		if r4 == r2 {
			result += r3
		}
		r1 += 1
		if r1 > r2 {
			break
		}
	}
	r3 += 1
	if (r3 > r2) {
		return result
	}
}
//
//
for r3 in 1..<r3 {
	for r1 in 1..<r2 {
		r4 = r3 * r1 (J5)	// two numbers multiplied together == r2 
		if r4 == r2 {		
			result += r3
		}
	}
}




//
r0 = modeFlag
r4 = boolean register mostly ...








// So if 