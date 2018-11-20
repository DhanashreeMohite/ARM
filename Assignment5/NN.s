	AREA     appcode, CODE, READONLY	;Start of the CODE area
	IMPORT printMsg
    EXPORT __main
	ENTRY 
	 
__main  FUNCTION
		MOV  R1, #-5  ; Init r1 (i = -5) to check values from -5 to 5
		
		;this program performs e^x,the result will be stored in S2
EXP
		VMOV.F32 S0, R0 	;'x' in e^x
		VMOV.F32 S1, #5 	;no. of terms
		VMOV.F32 S2, #1 	;result
		VMOV.F32 S3, #1 	;constant used for inreament
		VMOV.F32 S4, #1 	;counter which is used for division also
		VMOV.F32 S6, #1 
LOOP
		VCMP.F32 S1, S4
		VMRS.F32 APSR_nzcv,FPSCR	;Used to copy fpscr to apsr
		BLT SIGMOID;
		VDIV.F32 S5,S0,S4			;S5 = (S0/S4) i.e. (x/i) 
		VMUL.F32 S6,S5,S6			;S6 = ((S0/S4)*S6) i.e (x/i)*S6
		VADD.F32 S2, S2, S6			;S2 = S2+((S0/S4)*S6)	
		VADD.F32 S4, S4, S3			;incrementing count by 1
		B LOOP;
		VMOV.F32 R0,S2
		;s2 = e^x
;SIGMOID
;		VDIV.F32 S2,S3,S2			;S2=(1/e^x)
;		VADD.F32 S2,S3,S2			;S2=1+(1/e^x)
;		VDIV.F32 S2,S3,S2			;S2=1/(1+(1/e^x))
;		VMOV.F32 R0,S2
;		BL printMsg	 ; Refer to ARM Procedure calling standards
		
		ADD  R1, R1, #1 ;Increment it
		CMP  R1, #5 ;Check the limit
		BLE  EXP  ;Loop if not finished
			
stop B stop ; stop program
	 ENDFUNC
	 END
