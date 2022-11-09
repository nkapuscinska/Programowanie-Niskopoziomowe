//makra//
	.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)

.endmacro
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////// main//////////////////////////////////////
		
		ldi R16, 260  // podaje opoznienie
		ldi R18, 0b00000110 // 1
		ldi R19, 0b00111111 // 0
		ldi R20, 0b00000010 // pierwszy wyœwietlacz
		ldi R21, 0b00000100 // drugi wyœwietlacz
		ldi R22, 0b00001000 // trzeci wyœwietlacz
		ldi R23, 0b00010000 // czwarty wyœwietlacz
		ldi R24, 0b00000000 // zaszone wszystko
		//out DDRD, R19 <<---------------- !!!!!!!!!!!wkurwiaj¹ce œwiat³o!!!!!!!!!!!!!!!!!
		out DDRB, R20
		out DDRB, R24
		out DDRB, R21
		out DDRB, R22
		out DDRB, R23


		.equ Digits_P = PORTB
		.equ Segments_P = PORTD
		
MainLoop: 
		
		out Digits_P, R24
		rcall DelayInMs
		out Segments_P, R18
		out Digits_P, R24 
        rcall DelayInMs
		out Segments_P, R19
		
		out Digits_P, R20 

		rcall DelayInMs

		out Digits_P, R24 
		rcall DelayInMs
		out Segments_P, R18
		out Digits_P, R24 
        rcall DelayInMs
		out Segments_p, R19
		out Digits_P, R21 

		rcall DelayInMs

		out Digits_P, R24 
		rcall DelayInMs
		out Segments_P, R18
		out Digits_P, R24 
        rcall DelayInMs
		out Segments_P, R19
		out Digits_P, R22 
		rcall DelayInMs

		out Digits_P, R24 
		rcall DelayInMs
		out Segments_P, R18
		out Digits_P, R24 
        rcall DelayInMs
		out Segments_P, R19
		out Digits_P, R23 

		rcall DelayInMs

		rjmp MainLoop


/////////////////////////Delay///////////////////

DelayInMs: //opoznienie w R16,R17
	           push R24
			   push R25

			   mov R24, R16
			   mov R25, R17
	   MLoop: 
			   rcall DelayOneMs
			   
			   sbiw R25:R24, 1
			   brbc 1, MLoop

			   pop R25
			   pop R24
  			   ret


			   //input none
			   //output none
			   //internals R24,R25
			   //ochrona R24, R25
			   //r25, r17 starsza czesc
			   //R24, r16 m³odsza czesc
  DelayOneMs:
			 push R24
			 push R25
	    	 LOAD_CONST R25, R24, 2000
	   Loop: sbiw R25:R24, 1
	         brbc 1, Loop
			 pop R25
			 pop R24
			 ret

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////