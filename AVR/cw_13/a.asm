Infinit:   ldi R20, 5
	Loop:  dec R20
		   brbc 1, Loop
		   rjmp Infinit
		   // cykle 15, wz�r R20*3