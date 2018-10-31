     AREA     appcode, CODE, READONLY	;Start of the CODE area
     EXPORT __main
	 ENTRY 
__main  FUNCTION

		VMOV.F32 S0, #4 	;'x' in e^x
		VMOV.F32 S1, #5 	;no. of terms
		VMOV.F32 S2, #1 	;result
		VMOV.F32 S3, #1 	;constant used for inreament
		VMOV.F32 S4, #1 	;counter which is used for division also
		VMOV.F32 S6, #1 
LOOP
		VCMP.F32 S1, S4
		VMRS.F32 APSR_nzcv,FPSCR	;Used to copy fpscr to apsr
		BLT stop;
		VDIV.F32 S5,S0,S4			;S5 = (S0/S4) 
		VMUL.F32 S6,S5,S6			;S6 = (S0/S4)*S6
		VADD.F32 S2, S2, S6			;S2 = S2+((S0/S4)*S6)	
		VADD.F32 S4, S4, S3			;incrementing count by 1
		B LOOP;
		
stop B stop ; stop program
	 ENDFUNC
	 END
