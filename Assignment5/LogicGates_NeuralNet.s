	AREA     appcode, CODE, READONLY	;Start of the CODE area
	IMPORT printMsg
    EXPORT __main
	ENTRY 
	
	 
__main  FUNCTION		
		;for LOGIC_NOT following are the valid combination of input as can be seen in python code
			;X0->1, X1->0, X2->0
			;X0->1, X1->1, X2->0
			VLDR.F32 S29,=1 ;X0
			VLDR.F32 S30,=1	;X1
			VLDR.F32 S31,=0	;X2
			ADR.W  R6, BranchTable_Byte
			MOV R7,#0 ; to select one option in switch case (gates)
			
			;0->LOGIC_AND
			;1->LOGIC_OR
			;2->LOGIC_NOT
			;3->LOGIC_NAND
			;4->LOGIC_NOR
			;5->LOGIC_XOR
			;6->LOGIC_XNOR
			TBB   [R6, R7] ; switch case equivalent in Arm cortex M4
			
			;S10 = W0,S11 = W1, S12 = W2, S13 = (Bias)
LOGIC_AND	VLDR.F32 S10,=-0.1
			VLDR.F32 S11,=0.2
			VLDR.F32 S12,=0.2
			VLDR.F32 S13,=-0.2
			B EXP_X_CALC
			
LOGIC_OR	VLDR.F32 S10,=-0.1
			VLDR.F32 S11,=0.7
			VLDR.F32 S12,=0.7
			VLDR.F32 S13,=-0.1
			B EXP_X_CALC
			
LOGIC_NOT	VLDR.F32 S10,=0.5
			VLDR.F32 S11,=-0.7
			VLDR.F32 S12,=0
			VLDR.F32 S13,=0.1
			B EXP_X_CALC
			
LOGIC_NAND	VLDR.F32 S10,=0.6
			VLDR.F32 S11,=-0.8
			VLDR.F32 S12,=-0.8
			VLDR.F32 S13,=0.3
			B EXP_X_CALC
			
LOGIC_NOR	VLDR.F32 S10,=0.5
			VLDR.F32 S11,=-0.7
			VLDR.F32 S12,=-0.7
			VLDR.F32 S13,=0.1
			B EXP_X_CALC
			
LOGIC_XOR	VLDR.F32 S10,=-5
			VLDR.F32 S11,=20
			VLDR.F32 S12,=10
			VLDR.F32 S13,=1
			B EXP_X_CALC
			
LOGIC_XNOR	VLDR.F32 S10,=-5
			VLDR.F32 S11,=20
			VLDR.F32 S12,=10
			VLDR.F32 S13,=1
			B EXP_X_CALC
			
;S28 will store the final X0*W0 + X1*W1 + X2*W2 + Bias
EXP_X_CALC	VMLA.F32 S28, S10, S29
			VMLA.F32 S28, S11, S30
			VMLA.F32 S28, S12, S31
			VADD.F32 S28, S28, S13
			B EXP
			
;offset calculation for switch case
BranchTable_Byte	DCB     0
			DCB    ((LOGIC_OR-LOGIC_AND)/2)
			DCB    ((LOGIC_NOT-LOGIC_AND)/2)
			DCB    ((LOGIC_NAND-LOGIC_AND)/2)
			DCB    ((LOGIC_NOR-LOGIC_AND)/2)
			DCB    ((LOGIC_XOR-LOGIC_AND)/2)
			DCB    ((LOGIC_XNOR-LOGIC_AND)/2)
			
		;this program performs e^x,the result will be stored in S2
		;VMOV.F32 S0, #5 	;'x' in e^x
EXP		VMOV.F32 S1, #25 	;no. of terms
		VMOV.F32 S2, #1 	;result
		VMOV.F32 S3, #1 	;constant used for inreament
		VMOV.F32 S4, #1 	;counter which is used for division also
		VMOV.F32 S6, #1 
LOOP
		VCMP.F32 S1, S4
		VMRS.F32 APSR_nzcv,FPSCR	;Used to copy fpscr to apsr
		BLT SIGMOID;
		VDIV.F32 S5,S28,S4			;S5 = (S0/S4) i.e. (x/i) 
		VMUL.F32 S6,S5,S6			;S6 = ((S0/S4)*S6) i.e (x/i)*S6
		VADD.F32 S2, S2, S6			;S2 = S2+((S0/S4)*S6)	
		VADD.F32 S4, S4, S3			;incrementing count by 1
		B LOOP;
		
		;s2 = e^x
SIGMOID
		VDIV.F32 S2,S3,S2			;S2=(1/e^x)
		VADD.F32 S2,S3,S2			;S2=1+(1/e^x)
		VDIV.F32 S2,S3,S2			;S2=1/(1+(1/e^x))
		VMOV.F32 r0,S2
		B RESULT	 
		

; S15 will hold 0.5 for comparison to finalise the logical output for a particular gate
RESULT	VLDR.F32 S15 ,=0.5
		VCMP.F32 S2, S15 ; compare the output of sigmoid routine with S15
		VMRS.F32 APSR_nzcv,FPSCR ; Transfer floating-point flags to the APSR flags
		ITE HI
		MOVHI R0,#1; if S2 > S15
		MOVLS R0,#0; if S2 < S15
		BL printMsg	 ; Refer to ARM Procedure calling standards.
		
stop B stop ; stop program
	 ENDFUNC
	 END
