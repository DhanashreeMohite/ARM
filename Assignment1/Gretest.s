	AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		 		
         MOV r0 , #38   ;first number
		 MOV r1 , #58   ;second number
		 MOV r2 , #28 	 ;third number  			  
		 CMP r0 , r1
		 IT PL
		 MOVPL r1 , r0 
		 CMP r1 , r2
		 IT PL
		 MOVPL r2 , r1
		 MOV r3 , r2 


stop B stop ; stop program
     ENDFUNC
     END