MainLoop:
	ldi R16, LOW(9827)
	ldi R17, HIGH(9827)
	rcall NumberToDigits
	rjmp MainLoop




Divide:

	
	;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25
; inputs
.def XL=R16 ; divident
.def XH=R17
.def YL=R18 ; divisor
.def YH=R19
; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19
; internal
.def QCtrL=R24
.def QCtrH=R25

	push R24
	push R25
	clr R24
	clr R25

Mloop:
	cp XL, QL
	cpc XH, QH
	brcs end
	sub RL, QL
	sbc RH, QH
	adiw QCtrH:QCtrL, 1
	rjmp Mloop
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

mov R16, Dig3
mov R17, Dig2
mov R18, Dig1
mov R19, Dig0
ret