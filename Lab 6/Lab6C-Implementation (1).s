/* 	Calvin Uy
	COEN 20L
	10/24/23
	Lab 6C
*/

// void CopyCell(uint32_t *dst, uint32_t *src) ;        // R0 = dst, R1 = src

            .syntax     unified
            .cpu        cortex-m4
            .text

            .global     CopyCell
            .thumb_func
            .align
CopyCell:   
			PUSH		{R4-R11}
            LDR			R2,=60				// rows = 60
NextRow1:        	    					// copy 1 row
            LDMIA		R1!,{R3-R12}
			STMIA		R0!,{R3-R12}
			LDMIA		R1!,{R3-R12}
			STMIA		R0!,{R3-R12}
			LDMIA		R1!,{R3-R12}
			STMIA		R0!,{R3-R12}
			LDMIA		R1!,{R3-R12}
			STMIA		R0!,{R3-R12}
			LDMIA		R1!,{R3-R12}
			STMIA		R0!,{R3-R12}
			LDMIA		R1!,{R3-R12}
			STMIA		R0!,{R3-R12}
			ADD			R0,R0,4*(240-60)	// next dst row
			ADD			R1,R1,720			// next src row
            SUB			R2,R2,1				// rows--
            BNE         NextRow1
EndRows1:   
			POP			{R4-R11}
            BX          LR


// void FillCell(uint32_t *dst, uint32_t color) ;       // R0 = dst, R1 = color

            .global     FillCell
            .thumb_func
            .align 
FillCell:   
			LDR			R2,=60				// rows = 60
NextRow2:                    
			LDR			R3,=60/2			// cols = 60
NextCol2:                    				// store 2 pixels
            STRD		R1,R1,[R0],8
			SUBS		R3,R3,1				// cols--
            BNE         NextCol2
            ADD			R0,R0,4*(240-60)	// next dst row
			SUBS		R2,R2,1				// rows--
            BNE         NextRow2
            BX          LR

            .end














