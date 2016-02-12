pro tycho_record__define

 struct = $
  { tycho_record, $
     TYCHO_ID_1:  0, $          ;GSC region ID number I*2
     TYCHO_ID_2:  0, $          ;Component identifier I*2
     RA_DEG:      float(0), $   ;Right ascension J2000 (degrees) R*4
     DEC_DEG:     float(0), $   ;Declination J2000 in degrees R*4
     RApm:        float(0), $   ;RA proper motion in milliarcseconds/year R*4
     DECpm:       float(0), $   ;DEC proper motion in milliarcseconds/year R*4
     MAG:         float(0) $    ;Visual Magnitude R*4
  }

end
