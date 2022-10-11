// staszy bit R25
//m³odszy bit R24

ldi R20, 20

MLoop: ldi R24, $D0
       ldi R25, $7


	   Loop: sbiw R25:R24, 1
	         brbc 1, Loop
			 dec R20
			 brbc 1, MLoop



