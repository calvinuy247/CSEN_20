        .syntax         unified
        .cpu            cortex-m4
        .text


// int32_t Return32Bits(void) ;
        .global         Return32Bits
        .thumb_func
        .align
Return32Bits:
		LDR				R0,=10		//R0 = 10
        BX              LR


// int64_t Return64Bits(void) ;
        .global         Return64Bits
        .thumb_func
        .align
Return64Bits:
		LDR				R0,=-10
		LDR				R1,=-1		//R1.R0 = -10, since 64 bit
        BX              LR


// uint8_t Add8Bits(uint8_t x, uint8_t y) ;
        .global         Add8Bits
        .thumb_func
        .align
Add8Bits:
		ADD		R0,R0,R1	//R0 = x+y
		UXTB	R0,R0		//R0 into 8bit
        BX		LR


// uint32_t FactSum32(uint32_t x, uint32_t y) ;
        .global         FactSum32
        .thumb_func
        .align
FactSum32:
		PUSH	{R4, LR}	//stack alignment
		ADD		R0,R0,R1 	//R0 = x+y, preparing parameter for Factorial
		BL 		Factorial 	//R0 <- Factorial(x+y)
		POP		{R4, LR}
        BX		LR


// uint32_t XPlusGCD(uint32_t x, uint32_t y, uint32_t z) ;
        .global         XPlusGCD
        .thumb_func
        .align
XPlusGCD:
		PUSH	{R4, LR}	//stack alignment
		MOV		R4, R0 		//preserve x in R4
		MOV		R0, R1 		//prepare parameter for gcd, shifting y into R0
		MOV		R1, R2 		//prepare parameter for gcd, shifting z into R1
		BL		gcd	   		//R0 <- gcd(y,z)	
		ADD		R0,R0,R4 	//R0 = gcd(y,z) + x
		POP		{R4, PC}
        BX		LR

        .end


