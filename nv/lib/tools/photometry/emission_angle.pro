function emission_angle, surface_coord, camera_coord, vertical

; Vector from surface point to camera
a = camera_coord - surface_coord

; Local vertical
b = vertical

emission = acos( total( a*b ) / ( v_mag(a)*v_mag(b) ) )

return, emission

end
