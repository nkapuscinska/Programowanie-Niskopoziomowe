	
	MainLoop: 
		ldi R20, 5
		rcall DelayNCycles ; 
		nop
		rjmp MainLoop
	DelayNCycles: ;zwyk³a etykieta
		
		MLoop: ldi R24, $D0
			   ldi R25, $7


	   Loop: sbiw R25:R24, 1
	         brbc 1, Loop
			 dec R20
			 brbc 1, MLoop
			 ret
