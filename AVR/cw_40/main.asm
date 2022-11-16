//makra//
	.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)

.endmacro

	.macro SET_DIGIT
	ldi R24, 0b00000000
	out Segments_P, R24
	ldi R24, 0b00000010 << @0
	out Segments_P, R24
	mov R16, Digit_@0
	rcall DigitTo7segCode
	out Digits_P, R16
	LOAD_CONST R17, R16, 1000
	rcall DelayInMs

.endmacro
	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////// main//////////////////////////////////////
		
		LOAD_CONST R17, R16, 5 // podaje opoznienie

		ldi R20, 0b00011110 /// inicjalizacja wyœwietlaczy
		out DDRB, R20
		ldi R20, 0b01111111
		out DDRD, R20 //<<---------------- !!!!!!!!!!!wkurwiaj¹ce œwiat³o!!!!!!!!!!!!!!!!!
		
		
		.equ Digits_P = PORTD  //CYFERKA
		.equ Segments_P = PORTB  // NA KTÓRYM WYŒWIETLACZU

		.def Digit_0 = R2
		.def Digit_1 = R3
		.def Digit_2 = R4
		.def Digit_3 = R5
		
MainLoop: 


//inc r22; incremet
//cpi r27,5 ; Compare r27 to 5
//brne loop ; Branch if r27<>5
//clr r22 ; clear r22
			clr Digit_0

		licznik :
			SET_DIGIT 0
			inc Digit_0
			mov R16, Digit_0
			cpi R16, 10
			brne licznik

		rjmp MainLoop

////////////////////////konwersja z ludzkiego na wyœwietlacz//////////////////////////////////////////////

DigitTo7segCode:
	push R30
	push R31
	push R17
	ldi R17, 0
	ldi R30, low(Table<<1) // inicjalizacja rejestru Z 
	ldi R31, high(Table<<1)
	add R30, R16  // inkrementacja Z
	adc R31, R17
	lpm R16, Z // podmianka
	nop
	pop R17
	pop R31
	pop R31

ret

Table: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0xFD, 0x07, 0x7F, 0x6F // UWAGA: liczba bajtów zdeklarowanych

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


