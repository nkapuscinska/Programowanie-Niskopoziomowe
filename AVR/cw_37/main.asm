ldi R16, 2
rcall Podmianka
ldi R16, 3
rcall Podmianka
nop

Podmianka:
	ldi R17, 0
	ldi R30, low(Table<<1) // inicjalizacja rejestru Z 
	ldi R31, high(Table<<1)
	add R30, R16  // inkrementacja Z
	adc R31, R17
	lpm R16, Z // podmianka
	nop

ret

Table: .db 0x00, 0x01, 0x04, 0x09, 0x0F, 0x19, 0x24, 0x31, 0x40, 0x51 // UWAGA: liczba bajtów zdeklarowanych
