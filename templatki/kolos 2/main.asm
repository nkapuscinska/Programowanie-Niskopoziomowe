 ;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
	ldi @0, High(@2)
	ldi @1, Low(@2)
.ENDMACRO 

/*** Display ***/
.equ DigitsPort           = PORTD
.equ SegmentsPort         = PORTB
.equ DisplayRefreshPeriod = 5

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
	ldi R24, 0b00000000
	out SegmentsPort, R24
	mov R16, Dig_@0
	rcall DigitTo7segCode
	out DigitsPort , R16
	ldi R24, 0b00000010 <<@0
	out SegmentsPort, R24
	
	LOAD_CONST R17, R16, DisplayRefreshPeriod 
	rcall DealyInMs

.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0      rjmp	_main	 ; skok do programu g³ównego
.org OC1Aaddr	rjmp _Timer_ISR
.org PCIBaddr   rjmp _ExtInt_ISR

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtInt_ISR: 	 ; procedura obs³ugi przerwania zewnetrznego
		push R25
		push R24
		in R24, SREG
		push R24


	inc R29
	cpi R29, 2
	brne Skip
	movw R25:R24, R1:R0
	adiw R25:R24, 1
	movw R1:R0, R25:R24
	clr R29

	Skip:
		pop R24
		out SREG, R24
		pop R24
		pop R25
	

reti   ; powrót z procedury obs³ugi przerwania (reti zamiast ret)      

_Timer_ISR:
    push R16
    push R17
    push R18
    push R19
	in R19, SREG
	push R19

    movw R17:R16, R1:R0
	rcall _NumberToDigits
	clr R1
	clr R0
	
	pop R19
	out SREG, R19
	pop R19
    pop R18
    pop R17
    pop R16

  reti

; ### MAIN PROGAM ###

_main: 
    ; *** Initialisations ***

    ;--- Ext. ints --- PB0
	ldi R16, 0x00						//
	out DDRB, R16						//pin PB0 jako wejœcie (inne te¿) póŸniej s¹ ustawiane na wyjœcia

	ldi R16, (1<<PCIE0)					//
	out GIMSK, R16						//w³¹czenie przerwania zewnêtrznego PCIE0

	ldi R16, (1<<PCINT0)				//
	out PCMSK0, R16	

	;--- Timer1 --- CTC with 256 prescaller
    ldi R16, (1<<CS12) | (1<<WGM12)		//
	out TCCR1B, R16						//preskaler 256 i tryb CTC

	ldi R17, HIGH(31250)				//
	ldi R16, LOW(31250)					//
								
	out OCR1AH, R17						//porównanie CTC 31250
	out OCR1AL, R16						//

	ldi R16, (1<<OCIE1A)				//
	out TIMSK, R16
			
	;---  Display  --- 
	ldi R20, 0b01111111
	out DDRD, R20
	ldi R20, 0b00011110
	out DDRB, R20
	; --- enable gloabl interrupts
    sei

MainLoop:   ; presents Digit0-3 variables on a Display
			SET_DIGIT 0
			SET_DIGIT 1
			SET_DIGIT 2
			SET_DIGIT 3

			RJMP MainLoop

; ### SUBROUTINES ###

;*** NumberToDigits ***
;converts number to coresponding digits
;input/otput: R16-17/R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divider

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 

_NumberToDigits:

	push Dig0
	push Dig1
	push Dig2
	push Dig3

	; thousands 
    LOAD_CONST R19, R18, 1000
	rcall _Divide
	mov Dig_0, R18

	; hundreads 
    LOAD_CONST R19, R18, 100  
	rcall _Divide
	mov Dig_1, R18
	; tens 
    LOAD_CONST R19, R18, 10    
	rcall _Divide
	mov Dig_2, R18
	; ones 
    mov Dig_3, R16


	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0

	ret

;*** Divide ***
; divide 16-bit nr by 16-bit nr; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL=R16 ; divident  
.def XH=R17 

.def YL=R18 ; divider
.def YH=R19 

; outputs

.def RL=R16 ; reminder 
.def RH=R17 

.def QL=R18 ; quotient
.def QH=R19 

; internal
.def QCtrL=R24
.def QCtrH=R25

_Divide:push R24 ;save internal variables on stack
        push R25

		clr R24
		clr R25
		
	Division:
		
        cp R16, R18
		cpc R17, R19
		brcs end
		adiw R25:R24, 1
		sub R16, R18
		sbc R17, R19
		rjmp Division

	end:
		movw R19:R18, R25:R24


		pop R25 ; pop internal variables from stack
		pop R24

		ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31
push R17
	clr R17

    ldi R30, low(Table<<1)
	ldi R31, high(Table<<1)
	add R30, R16
	adc R31, R17
	lpm R16, Z

pop R17
pop R31
pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DealyInMs:  
            push R24
			push R25

            movw R25:R24, R17:R16
		Loop:
			rcall OneMsLoop
			sbiw R25:R24, 1
			brbc 1, Loop

			pop R25
			pop R24

			ret

; *** OneMsLoop ***
OneMsLoop:	
			push R24
			push R25 
			
			LOAD_CONST R25,R24,2000                    

L1:			SBIW R25:R24,1 
			BRNE L1

			pop R25
			pop R24

			ret




