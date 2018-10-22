	AREA     appcode, CODE, READONLY
	 EXPORT __main
	 ENTRY 
__main  FUNCTION
		MOV r0 , #25			;value of a	
		MOV r1 , #5     		;value of b
LOOP	CMP r0 , r1				;compare r0 and r1
		IT EQ 					;stop if equal
		BEQ STOP	
		ITE HI			  		;if r0>r1
		SUBHI r0 , r0 , r1	 	;r0=r0-r1			  
		SUBLS r1 , r1 , r0		;else r1=r1-r0
		B LOOP			  		;go to loop



STOP    B STOP ; stop program
		ENDFUNC
		END