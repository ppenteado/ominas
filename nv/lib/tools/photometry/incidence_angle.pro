function incidence_angle, surface_coord, sun_coord, vertical

; Vector from surface point to sun
a = sun_coord - surface_coord

; Local vertical
b = vertical

incidence = acos( total( a*b ) / ( v_mag(a)*v_mag(b) ) )

return, incidence

end
