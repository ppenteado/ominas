function photometric_angles, cd, sund, coords, gbx=gbx, dkx=dkx

;     cd = Camera descriptor
;     sund = Sun descriptor (star descriptor of class GLOBE)
;     gbx = Planet descriptor (of class GLOBE)
;     dkx = Ring descriptor (of class DISK)
; coords = If ring descriptor is given, radius (meters) and lon (radians)
;          of surface point.  If planet descriptor, lat and lon (radians).

if keyword__set(gbx) then begin

  vertical = bod_body_to_inertial(gbx, $
               local_vertical(gbx, coords))

  surface_coord = bod_body_to_inertial_pos(gbx, $
                    glb_globe_to_body(gbx, coords))

endif else if keyword__set(dkx) then begin

  vertical = bod_body_to_inertial(dkx, [[0],[0],[1]])

  surface_coord = bod_body_to_inertial_pos(dkx, $
                    dsk_disk_to_body(dkx, coords))

endif else begin

  message, 'Must specify either planet or ring.'

endelse

camera_coord = bod_pos(cd)

sun_coord = bod_pos(sund)

incidence = incidence_angle( surface_coord, sun_coord, vertical )
emission = emission_angle( surface_coord, camera_coord, vertical )
phase = phase_angle( surface_coord, camera_coord, sun_coord )

return, [ incidence, emission, phase ]

end


