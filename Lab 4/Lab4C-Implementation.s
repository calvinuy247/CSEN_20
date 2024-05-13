/*	Calvin Uy	*/

        .syntax     unified
        .cpu        cortex-m4
        .text

// ----------------------------------------------------------
// unsigned HalfWordAccess(int16_t *src) ;
// ----------------------------------------------------------

        .global     HalfWordAccess
        .thumb_func
        .align
HalfWordAccess:
		.rept	100
		LDRH	R1,[R0]	
		.endr			
		BX		LR

// ----------------------------------------------------------
// unsigned FullWordAccess(int32_t *src) ;
// ----------------------------------------------------------

        .global     FullWordAccess
        .thumb_func
        .align
FullWordAccess:
		.rept	100
		LDR		R1,[R0]
		.endr
		BX		LR

// ----------------------------------------------------------
// unsigned NoAddressDependency(uint32_t *src) ;
// ----------------------------------------------------------

        .global     NoAddressDependency
        .thumb_func
        .align
NoAddressDependency:
		.rept	100
		LDR		R1,[R0]
		LDR		R2,[R0]
		.endr
		BX		LR

// ----------------------------------------------------------
// unsigned AddressDependency(uint32_t *src) ;
// ----------------------------------------------------------

        .global     AddressDependency
        .thumb_func
        .align
AddressDependency:
		.rept 	100
		LDR		R1,[R0]
		LDR		R0,[R1]
		.endr
		BX		LR

// ----------------------------------------------------------
// unsigned NoDataDependency(float f1) ;
// ----------------------------------------------------------

        .global     NoDataDependency
        .thumb_func
        .align
NoDataDependency:
		.rept 		100
		VADD.F32	S1,S0,S0
		VADD.F32	S2,S0,S0
		.endr
		VMOV		S1,S0
		BX			LR

// ----------------------------------------------------------
// unsigned DataDependency(float f1) ;
// ----------------------------------------------------------

        .global     DataDependency
        .thumb_func
        .align
DataDependency:
		.rept 		100
		VADD.F32	S1,S0,S0
		VADD.F32	S0,S1,S1
		.endr
		VMOV		S1,S0
		BX			LR

// ----------------------------------------------------------
// void VDIVOverlap(float dividend, float divisor) ;
// ----------------------------------------------------------

        .global     VDIVOverlap
        .thumb_func
        .align
VDIVOverlap:
		VDIV.F32	S2,S1,S0
		.rept		1
		NOP
		.endr
		VMOV		S3,S2
		BX			LR

        .end

/*
	a. Half-Word Access:
		Adrs = X...X00: 1 cycles/instruction
		Adrs = X...X01: 2 cycles/instruction
		Adrs = X...X10: 1 cycles/instruction
		Adrs = X...X11: 2 cycles/instruction
		Since unaligned, will be found in either one or two cycles based on the value of the 2 LSB since it will be found in only 2 options
	b. Full-Word Access:
		Adrs = X...X00: 1 cycles/instruction
		Adrs = X...X01: 3 cycles/instruction
		Adrs = X...X10: 2 cycles/instruction
		Adrs = X...X11: 3 cycles/instruction
		Since unaligned, bit addresses basing it off the 2 LSB to determine how many cycles to get full word, odd numbers require going through 3 cycles
	c. Address dependency penalty: 4 cycles/instruction
		No waiting for previous instructions, waiting for operand, but number of cycles doubles since you would be waiting for operand plus your own cycles
	d. Data dependency penalty: 2 cycles/instruction
		No waiting for previous instructions, waiting for operand
		number of cycles doubles since you would have to wait a whole cycle to wait if need info from previous instruction
	e. Maximum VDIV/VSQRT overlap: 16 clock cycles 
		Freed 16 cycles that are available on the main processor and sent to the float processor, VDIV takes 14 cycles plus another 1 for waiting for S2 and then one more for VMOV
		
*/