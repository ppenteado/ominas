;=============================================================================
;+
; NAME:
;       cd_to_radec_twist
;
;
; PURPOSE:
;       Computes Euler angles representing the orientation of a given
;	camera descriptor.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       cd_to_radec_twist, cd, ra=ra, dec=dec, twist=twist
;
;
; ARGUMENTS:
;  INPUT:
;            cd:       Array (nv,3,nt) of camera descriptors.
;
;  OUTPUT:
;       NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
;
;  OUTPUT:
;       ra:	Right ascension relative to the inertial frame.
;
;	dec:	Declination relative to the inertial frame.
;
;	twist:	Twist angle relative to the inertial frame.
;
;
; RETURN: NONE
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
pro cd_to_radec_twist, cd, ra=ra, dec=dec, twist=twist

 orient = bod_orient(cd)
 radec = bod_body_to_radec(bod_inertial(), orient[1,*,*])
 ra = radec[*,0,*]
 dec = radec[*,1,*]

 cel_north = -image_celestial_northangle(cd)
 twist = reduce_angle(!dpi - cel_north)
end
;===========================================================================
