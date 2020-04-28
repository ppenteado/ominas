pro sedrupd__define

; Source one of: 'DAVI', 'NAV ', 'FARE', 'NAV2', 'NEAR', 'AMOS'

 struct = $
  { sedrupd, $
     sctime:		0L, $		; Spacecraft time (FDS count * 100)
     alpha:		0d, $		; C-matrix euler angle (boresight RA)
     delta:		0d, $		; C-matrix euler angle (boresight DEC)
     kappa:		0d, $		; C-matrix euler angle (rotation angle)
     alpha_0:		0d, $		; ME-matrix euler angle (pole RA)
     delta_0:		0d, $		; ME-matrix euler angle (pole DEC)
     omega:		0d, $		; ME-matrix euler angle (pm angle)
     pb_position:	fltarr(3), $	; S/C to Picture Body (km, J2000)
     update_day:	0, $		; Date of this SEDR update
     update_year:	0, $		; Year of this SEDR update (-1900)
     source:		bytarr(4), $	; ASCII Source of this update
     spare_1:		bytarr(12) $ 	; Spare bytes
  }

end
