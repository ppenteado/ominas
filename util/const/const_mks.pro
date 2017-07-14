;============================================================================
; const_mks
;
;============================================================================
function const_mks, name

 case strupcase(name) of 
  'G'		: return, 6.6725985d-11		; Gravitational constant J m/kg2
  'C'	  	: return, 2.99792458d8		; Speed of light m/s2; from cspice_clight()
  'SIGMA' 	: return, 5.669656d-8		; Stefan-Boltzmann constant W/m2/K4
  'K'	  	: return, 1.38062d-23		; Boltzmann's constant
  'H'	  	: return, 6.62620d-34		; Planck's constant
  'RHO_H2O'	: return, 1d3			; Density of water kg/m3
  'TO_M'  	: return, 1d			; convert lengths to meters
  'TO_KM' 	: return, 1d-3			; convert lengths to km
  'TO_CM' 	: return, 1d2			; convert lengths to cm
  'AU'    	: return, 1.496d11		; Astromonimcal unit m
  'LSUN'  	: return, 3.826d26		; Solar luminosity W
  'MSUN'  	: return, 1.98892d30		; Solar mass kg
  'PARSEC'	: return, 3.085678d16		; Parsec m
 endcase

end
;============================================================================
