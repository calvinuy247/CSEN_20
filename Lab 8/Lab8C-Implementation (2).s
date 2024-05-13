/* 	Calvin Uy
	COEN 20L
	11/14/23
	Lab 8C
*/
 
		.syntax     unified
        .cpu        cortex-m4
        .text

// uint32_t Mul32X10(uint32_t multiplicand) ;
        .global     Mul32X10
        .thumb_func
        .align

Mul32X10:           				//R0 = multiplicand
		ADD 		R0,R0,R0,LSL 2 	//R0 = R0+R0*4 = R0*5
		LSL 		R0,R0,1 		//R0 = 2(R0*5) = R0*10
        BX          LR


// uint32_t Mul64X10(uint32_t multiplicand) ;
        .global     Mul64X10
        .thumb_func
        .align

Mul64X10:           				//R1.R0 = multiplicand
		ADDS		R0,R0,R0		//R0 = 2*R0(ls half)
		ADC 		R1,R1,R1		//R1 = 2*R1(ms half)
		LSL 		R2,R1,2			//R2 = 4(2*R1) = 8*R1
		ADD 		R2,R2,R0,LSR 30	//fix bits of ls half
		LSL 		R3,R0,2			//R3 = 4(2*R0) = 8*R0
		ADDS 		R0,R0,R3 		//R0 = 2*R0+8*R0 = 10*R0 (ls half)
		ADC 		R1,R1,R2 		//R1 = 2*R1+8*R1 = 10*R1(ms half)
		BX			LR


// uint32_t Div32X10(uint32_t dividend) ;
        .global     Div32X10
        .thumb_func
        .align

Div32X10:           				//R0 = dividend
		LDR 		R1,=3435973837 	//(2^35+2)/10  = Magic constant M 
		UMULL 		R2,R1,R1,R0 	//64-bit mult R1.R0
		LSRS 		R0,R1,3 		//R1 shift right by 3 
		BX			LR

        .end


