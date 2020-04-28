pro bcons__define

 struct = $
  { bcons, $
     a:			float(0), $	; Long equatorial radius (km) 
     b:			float(0), $	; Short equatorial radius (km)
     c:			float(0), $	; Polar radius (km)
     lora:		float(0), $	; Longitude of 'A' (degrees west long)
     rotation_rate:	float(0), $	; Axial rotation rate (earth days)
     junk:		bytarr(100), $	; Spares
     planet_number:	0, $		; Planet number (3=earth, 6=saturn, etc)
     sat_number:	0, $		; Sat number (2=europa, 1=moon, etc)
     icat_domain:	bytarr(31), $   ; ICAT domain containing target body
     body_name:		bytarr(10) $	; Ascii name of the body
  }

end
