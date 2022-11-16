
MainLoop:
	ldi R16, LOW(1600)
	ldi R17, HIGH(1600)
	ldi R18, LOW(500)
	ldi R19, HIGH(500)
	rcall Divide
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
	ret

	
	