;===========================================================================
; is_planet
;
;===========================================================================
function is_planet, _names

 names = strupcase(_names)
 return, where( $
            (names EQ 'MERCURY') OR $
            (names EQ 'VENUS') OR $
            (names EQ 'EARTH') OR $
            (names EQ 'MARS') OR $
            (names EQ 'JUPITER') OR $
            (names EQ 'SATURN') OR $
            (names EQ 'URANUS') OR $
            (names EQ 'NEPTUNE') OR $
            (names EQ 'PLUTO') )

end
;===========================================================================
