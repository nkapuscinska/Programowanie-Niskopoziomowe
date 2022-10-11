MainLoop: 
		ldi R24, 5
		rcall DelayInMs ; 
		nop
		rjmp MainLoop

	DelayInMs: ;zwyk³a etykieta
			
	   MLoop:  
			   rcall DelayOneMs
			   
			   dec R24
			   brbc 1, MLoop
			   ret

  DelayOneMs:
			sts 0x0060, R24
			sts 0x0061, R25
	    	 ldi R24, $D0
			 ldi R25, $7
	   Loop: sbiw R25:R24, 1
	         brbc 1, Loop
			 lds R24, 0x0060
			 lds R24, 0x0061
			  ret
