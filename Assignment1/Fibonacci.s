	AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
		MOV r0 , #0  	;first = 0
		MOV r1 , #1    	;second = 1
		MOV r6 , #0	  	;r6 acts as counter
		MOV r7 , #6  	;Required number of terms 	

		MOV r2 , r0		;r2 as a output
		ADD r6, r6, #1
		CMP r7 , #1		; in case of only 1 term to be printed
		IT LS 
		BLS STOP
		
		MOV r2 , r1		;r2 as a output
		ADD r6, r6, #1
		CMP r7 , #2		;in case of only 2 terms to be printed
		IT LS 
		BLS STOP
		
LOOP	ADD r2 , r1 , r0	;r2 as a output(r2=r0+r1)
		MOV r0 , r1
		MOV r1 , r2
		ADD r6, r6, #1
		CMP r6, r7
		BNE LOOP			


STOP    B STOP ; stop program
		ENDFUNC
		END
