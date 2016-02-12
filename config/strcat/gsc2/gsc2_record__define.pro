pro gsc2_record__define

 struct = $
  { gsc2_record, $
     GSC2_ID:     0l, $         ;GSC2 ID number I*4
     RA_DEG:      float(0), $   ;Right ascension J2000 (degrees) R*4
     DEC_DEG:     float(0), $   ;Declination J2000 in degrees R*4
     RApm:        float(0), $   ;RA proper motion in milliarcseconds/year R*4
     DECpm:       float(0), $   ;DEC proper motion in milliarcseconds/year R*4
     MAG:         float(0) $    ;Visual Magnitude R*4
  }

end
