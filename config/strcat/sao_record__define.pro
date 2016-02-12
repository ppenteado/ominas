pro sao_record__define

 struct = $
  { sao_record, $
     RA:      float(0), $       ;Right ascension EME1950 (radians) R*4
     RApm:    float(0), $       ;Annual pm in RA in sec of time R*4
     Dec:     float(0), $       ;Declination EME1950 in radians R*4
     Decpm:   float(0), $       ;Annual pm in Dec in sec of arc R*4
     Mag:     float(0), $       ;Visual magnitude (null if 99.9) R*4
     Name:    bytarr(13), $     ;Star name
     Sp:      bytarr(3) $       ;Spectral type("+++"=multiple) A3
  }

end
