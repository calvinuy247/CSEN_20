        .syntax     unified
        .cpu        cortex-m4
        .text

// void PutNibble(void *nibbles, uint32_t which, uint32_t value) ;

        .global     PutNibble
        .thumb_func
        .align

PutNibble:						//R0 = nibbles, R1 = which, R2 = value
		LSRS		R1,R1,1		//R1 = which >> 1
		LDRB		R3,[R0,R1]	//R3 = nibbles + (which>>1)
        IT			CS			//checks carry set
		RORCS		R3,R3,4		//if carry, rotate right by 4
		BIC			R3,R3,0xF	//R3 = R3 & 0b00001111
		ORR			R3,R3,R2	//R3 = R3 | R2
		IT			CS
		RORCS		R3,R3,28
		STRB		R3,[R0,R1]	
		BX          LR

// uint32_t GetNibble(void *nibbles, uint32_t which) ;

        .global     GetNibble
        .thumb_func
        .align

GetNibble:						//R0 = nibbles, R1 = which
		LSRS		R1,R1,1		//R1 = which >> 1
		LDRB		R0,[R0,R1]	//R0 = nibbles[which>>1]
		ITE			CS			//checks carry set
		LSRCS		R0,R0,4		//if carry, shift right by 4
		ANDCC		R0,R0,0xF	//if carry = 0, R0 = R0 & 0b00001111
		BX			LR
        .end
