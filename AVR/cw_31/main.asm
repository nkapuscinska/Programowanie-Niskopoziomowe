//makra//
	.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)

.endmacro
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////// main//////////////////////////////////////
		
		LOAD_CONST R17, R16, 5 // podaje opoznienie

		ldi R20, 0b00011110 /// inicjalizacja wyœwietlaczy
		out DDRB, R20
		ldi R20, 0b01111111
		//out DDRD, R20 //<<---------------- !!!!!!!!!!!wkurwiaj¹ce œwiat³o!!!!!!!!!!!!!!!!!


		ldi R18, 0b00000110 // 1
		ldi R19, 0b00111111 // 0
		ldi R25, 0b01011011// 2
		ldi R26, 0b01001111 // 3

		
		
		mov R2, R19
		mov R3, R18
		mov R4, R25
		mov R5, R26

		.def Digit_0 = R2
		.def Digit_1 = R3
		.def Digit_2 = R4
		.def Digit_3 = R5
		


		ldi R20, 0b00000010 // pierwszy wyœwietlacz
		ldi R21, 0b00000100 // drugi wyœwietlacz
		ldi R22, 0b00001000 // trzeci wyœwietlacz
		ldi R23, 0b00010000 // czwarty wyœwietlacz
		ldi R24, 0b00000000 // zgaszone wszystko
		
		

		.equ Digits_P = PORTD  //CYFERKA
		.equ Segments_P = PORTB  // NA KTÓRYM WYŒWIETLACZU
		
MainLoop: 
		
		
		out Segments_P, R24
		out Digits_P, Digit_0
		
		out Segments_P, R20 

		rcall DelayInMs

		out Segments_p, R24 
		out Digits_P, Digit_1
		

		out Segments_P, R21 

		rcall DelayInMs

		out Segments_P, R24 
		out Digits_P, Digit_2
		
		
		out Segments_P, R22 

		rcall DelayInMs

		out Segments_P, R24
		out Digits_P, Digit_3
		
		out Segments_P, R23 

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
