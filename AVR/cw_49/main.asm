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
	LOAD_CONST R17, R16, 5
	rcall DelayInMs

.endmacro
	

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.cseg ; segment pamiêci kodu programu
.org 0 rjmp _main ; skok po resecie (do programu g³ównego)
.org OC1Aaddr rjmp _timer_isr ; skok do obs³ugi przerwania timera
.org PCIBaddr rjmp _pcint0_isr

_timer_isr: ; procedura obs³ugi przerwania timera
		push R24
		push R25
		push R16
		push R17
		push R26
		in R26, SREG
		push R26


		movw R17:R16, R29:R28
		rcall NumberToDigits
		clr R29
		clr R28

		pop R26
		out SREG, R26
		pop R26
		pop R17
		pop R16
		pop R25
		pop R24
		reti ; powrót z procedury obs³ugi przerwania (reti zamiast ret)
////////////////////////////////////////////////////////////////////////////////////////////////////////////
;*** Przerwanie zewnêtrzne PCINT0 - PB0 ***
;input: R29, R28
;output: Digit_1 - Digit_4 (R2, R3, R4, R5)
;internals: XXL(R16), XXH(R17), R20, YYL(R18), YYH(R19)
_pcint0_isr:
								//--- ochrona rejestrów ---
								push R24
								push R25
								push R16
								push R17
								push R26
								in R26, SREG
								push R26
								//-------------------------

								movw R25:R24, R1:R0
								adiw R25:R24, 1
								movw R1:R0, R25:R24
								movw R17:R16, R25:R24
								LOAD_CONST R19, R18, 2
								rcall Divide
								ldi R26, 0
								cp RL, R26
								cpc RH, R26
								brne Skip

								clr R1
								clr R0
								adiw R29:R28, 1
								

							Skip:
								//------------------------------
								
								pop R26
								out SREG, R26
								pop R26
								pop R17
								pop R16
								pop R25
								pop R24
								reti ;
								
//////////////////////////////// main//////////////////////////////////////

								

								
		
_main:
								//inicjalizacja zewnêtrznego przerwania PCINT0 (PB0)
								ldi R16, 0x00						//
								out DDRB, R16						//pin PB0 jako wejœcie (inne te¿) póŸniej s¹ ustawiane na wyjœcia

								ldi R16, (1<<PCIE0)					//
								out GIMSK, R16						//w³¹czenie przerwania zewnêtrznego PCIE0

								ldi R16, (1<<PCINT0)				//
								out PCMSK0, R16						//aktywowanie przerwania z pinu PCINT0 (PB0)


								//inicjalizacja timera1: CTC, preskaler: 256, f=1Hz
								ldi R16, (1<<CS12) | (1<<WGM12)		//
								out TCCR1B, R16						//preskaler 256 i tryb CTC

								ldi R17, HIGH(31250)				//
								ldi R16, LOW(31250)					//
								
								out OCR1AH, R17						//porównanie CTC 31250
								out OCR1AL, R16						//

								ldi R16, (1<<OCIE1A)				//
								out TIMSK, R16						//w³¹czenie przerwania od CTC timera1

								sei


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
			
		
		SET_DIGIT 0
		SET_DIGIT 1
		SET_DIGIT 2
		SET_DIGIT 3

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







	
	;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25
; inputs
.def XXL=R16 ; divident
.def XXH=R17
.def YYL=R18 ; divisor
.def YYH=R19
; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19
; internal
.def QCtrL=R24
.def QCtrH=R25

Divide:

	push R24
	push R25
	clr R24
	clr R25

Division:
	cp R16, R18
	cpc R17, R19
	brcs end
	sub RL, QL
	sbc RH, QH
	adiw QCtrH:QCtrL, 1
	rjmp Division
end:
	movw  QH:QL, QCtrH:QCtrL
	
	pop R25
	pop R24
	ret

	
	
	;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide
; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

NumberToDigits:
ldi R19, HIGH(1000)
ldi R18, LOW(1000)
rcall Divide
mov Dig0, R18
ldi R19, HIGH(100)
ldi R18, LOW(100)
rcall Divide
mov Dig1, R18
ldi R19, HIGH(10)
ldi R18, LOW(10)
rcall Divide
mov Dig2, R18
mov Dig3, R16

mov R5, Dig3
mov R4, Dig2
mov R3, Dig1
mov R2, Dig0
ret
