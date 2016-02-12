pro sedr2__define

; C-matrix and ME-matrix in J2000
; Bitmap of sedr_sources:
; 000001  000010  000100  001000  010000  100000
; 'DAVI', 'NAV ', 'FARE', 'NAV2', 'NEAR', 'AMOS'

 struct = $
  { sedr2, $
     sctime:		0L, $		; Spacecraft time (FDS count * 100)
     alpha:		0d, $		; C-matrix euler angle (boresight RA)
     delta:		0d, $		; C-matrix euler angle (boresight DEC)
     kappa:		0d, $		; C-matrix euler angle (rotation angle)
     alpha_0:		0d, $		; ME-matrix euler angle (pole RA)
     delta_0:		0d, $		; ME-matrix euler angle (pole DEC)
     omega:		0d, $		; ME-matrix euler angle (pm angle)
     sc_velocity:	fltarr(3), $ 	; S/C vel wrt Central Body (km/s, J2000)
     sc_position:	fltarr(3), $    ; Central body to S/C (km, J2000)
     pb_position:	fltarr(3), $	; S/C to Picture Body (km, J2000)
     sun_position:	fltarr(3), $	; S/C to Sun (km, J2000)
     target:		0, $		; Target (picture body) number
     update_day:	0, $		; Day of Year SEDR updated
     update_year:	0, $		; Year SEDR updated 
     msec:		0, $		; SCET milliseconds of second
     year:		0, $		; SCET year AD
     day:		0, $		; SCET day of year
     hour:		0b, $		; SCET hour of day
     minute:		0b, $		; SCET minute of hour
     second:		0b, $		; SCET second of minute
     inst:		0b, $		; Instrument number (1 = NA, 2 = WA)
     telem:		0b, $		; Telemetry flag
     scnum:		0b, $		; S/C number (31 = VGR2, 32 = VGR1)
     motion:		0b, $		; Scan platform motion flag (1=moving)
     sedr_sources:	0,  $		; Bitmap indicator of sedr sources
     spare_1:		bytarr(13) $	; Spare bytes
  }

end
