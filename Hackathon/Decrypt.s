PRESERVE8
     THUMB
     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION

	
	LDR r6, =0x20012C02    ;location of IV
	LDR r8 , =0x20012C01   ;location of cipher text
	LDR r10,[r6]    ;loading initialization vector to r10
	MOV r9,#1    ;loading encrypted text msg to decrypt
	STR r9,[r8]   
	LDR r11, [r8] ;loading result from ciphertext location (of encryped text) to r11
	CMP r10, #10 ; IV location value = 0 indicates start of msg
	BEQ STARTMSGD
	EOR r9,r7,r11  ; exor current cipher text with prev cipher text msg
STARTMSGD 
	MOV r7 , r11   ; move encryped cipher text to r7
	EOR r9,r11,#10 ; r9 = exor of ciphertext & initialization vector(cdtn for 1st msg)
      
stop B stop ; stop program
	 ENDFUNC
	 END

