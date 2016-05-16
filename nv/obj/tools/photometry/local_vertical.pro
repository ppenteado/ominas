function local_vertical, gbd, coords

; The normal to an ellipsoid is its gradient.  Therefore:
;
;            x^2   y^2   z^2        2*x ^   2*y ^   2*z ^
;     grad ( --- + --- + --- )  =  (--- x + --- y + --- z )
;            a^2   b^2   c^2        a^2     b^2     c^2
;
; where (x,y,z) is the position on the ellipsoid and (a,b,c) are the
; triaxial radii.  Since we're only interested in direction, we can
; divide through by 2.  
;
; Input coords is in body-frame polar coordinates (lat,lon).
; Output vertical is in body-frame cartesian coordinates.

radii = glb_radii(gbd)
xyz = glb_globe_to_body( gbd, coords )

vertical = xyz / radii / radii

return, vertical/(v_mag(vertical))[0]

end
