/*	Calvin Uy
	COEN 20L
	11/28/23
	Lab 9C
*/

        .syntax         unified
        .cpu            cortex-m4
        .text

// float EccentricAnomaly(float e, float M)

        .global         EccentricAnomaly
        .thumb_func
        .align
EccentricAnomaly:                               // S0 = e, S1 = M
        PUSH            {LR}
        VPUSH           {S16-S18}
        VMOV            S16, S0                 // S16 = e
        VMOV            S17, S1		            // S17 = M
        VMOV            S0, S17                 // S0  = M
        BL              cosDeg		            // S0  = cosDeg(M)
        VMOV            S18, 1.0                // S18 = 1.0
        VMLA.F32        S18, S16, S0	        // S18 = 1.0 + e * cosDeg(M)
        VMOV            S0, S17				    // S0  = M
        BL              sinDeg				    // S0  = sinDeg(M)
        VMUL.F32        S18, S0, S18			// S18 = sinDeg(M) * (1.0 + e * cosDeg(M))
        VMUL.F32		S0, S18, S16		    // S0  = e * sinDeg(M) * (1.0 + e * cosDeg(M))
        BL              Rad2Deg				    // S0  = Rad2Deg(e * sinDeg(M) * (1.0 + e * cosDeg(M)))
        VADD.F32		S0, S0, S17		        // S0  = M + Rad2Deg(e * sinDeg(M) * (1.0 + e * cosDeg(M)))
        VPOP            {S16-S18}
        POP             {PC}

// float Kepler(float m, float ecc)

        .global         Kepler
        .thumb_func
        .align
Kepler:                                         // S0 = m, S1 = ecc
        PUSH            {R3,LR}
        VPUSH           {S16-S19}
        VMOV            S16, S1	                // S16 = ecc
        BL              Deg2Rad	                // S0  = Deg2Rad(m)
        VMOV            S17, S0		            // S17 = m
        VMOV            S18, S0		            // S18 = e
top:     				                   		// S0  = e
        BL              sinDeg		            // S0  = sinf(e)
        VMUL.F32        S1, S0, S16		        // S1  = ecc*sinf(e)
        VSUB.F32        S1, S18, S1	            // S1  = e - ecc*sinf(e)
        VSUB.F32		S19, S1, S17	        // S19 = delta = e - ecc*sinf(e) - m
        VMOV            S0, S18			        // S0  = e
        BL              cosDeg			        // S0  = cosf(e)
        VMOV            S1, 1.0		            // S1  = 1.0
        VMLS.F32        S1, S16, S0		        // S1  = 1.0 - ecc*cosf(e)
        VDIV.F32        S0, S19, S1		        // S0  = delta / (1.0 - ecc*cosf(e)
        VSUB.F32        S18, S18, S0	        // S18 = e = e - delta / (1.0 - ecc*cosf(e)
        VABS.F32		S0, S19                 // S0  = fabsf(delta)
        VLDR            S1, epsilon	            // S1  = epsilon
        VCMP.F32        S0, S1		            // fabs(delta) > epsilon?
        VMRS            APSR_nzcv,FPSCR
        BGT             top
        VMOV            S0,S18
        VPOP            {S16-S19}
        POP             {R3,PC}

        .align
epsilon:
        .float          1E-6

        .end


