function phase_angle, surface_coord, camera_coord, sun_coord

; Vector from surface point to camera
a = camera_coord - surface_coord

; Vector from surface point to sun
b = sun_coord - surface_coord

phase = acos( total( a*b ) / ( v_mag(a)*v_mag(b) ) )

return, phase

end
