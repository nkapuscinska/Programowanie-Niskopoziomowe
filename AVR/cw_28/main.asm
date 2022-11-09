ldi R16, 0b00000000
ldi R17, 0b00011110


out DDRB, R17

	Loop:
			

		out PORTB, R17

		out PORTB, R16

	rjmp 




