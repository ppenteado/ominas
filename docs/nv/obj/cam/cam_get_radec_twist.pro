;===========================================================================
;+
; NAME:
;	cam_get_radec_twist
;
;
; PURPOSE:
;       Computes camera Euler angles relative to the inertial frame.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_get_radec_twist, cd, ra=ra, dec=dec, twist=twist
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	        Array (nt) of CAMERA descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	ra:	Array (nt) of RA angles.
;
;	dec:	Array (nt) of DEC angles.
;
;	twist:	Array (nt) of TWIST angles.
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro cam_get_radec_twist, cd, ra=ra, dec=dec, twist=twist
@core.include

 orient = bod_orient(cd)
 radec = bod_body_to_radec(bod_inertial(), orient[1,*,*])
 ra = radec[*,0,*]
 dec = radec[*,1,*]

 cel_north = -image_celestial_northangle(cd)
 twist = reduce_angle(!dpi - cel_north)

end
;===========================================================================



