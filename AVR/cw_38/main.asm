ldi R16, 2
rcall Podmianka
ldi R16, 3
rcall DigitTo7segCode
nop

DigitTo7segCode:
	ldi R17, 0
	ldi R30, low(Table<<1) // inicjalizacja rejestru Z 
	ldi R31, high(Table<<1)
	add R30, R16  // inkrementacja Z
	adc R31, R17
	lpm R16, Z // podmianka
	nop

ret

Table: .db 0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x7B // UWAGA: liczba bajtów zdeklarowanych