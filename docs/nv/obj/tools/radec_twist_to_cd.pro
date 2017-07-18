;=============================================================================
;+
; NAME:
;       radec_twist_to_cd
;
;
; PURPOSE:
;       Computes a camera orietation matrix from thegiven Euler angles.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       radec_twist_to_cd, ra, dec, twist, cd=cd
;
;
; ARGUMENTS:
;  INPUT:
;       ra:	Right ascension relative to the inertial frame.
;
;	dec:	Declination relative to the inertial frame.
;
;	twist:	Twist angle relative to the inertial frame.
;
;  OUTPUT:
;       NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	cd:	Array (nt) of initial camera descriptors.  This 
;		argument must contain a valid camera descriptor
;		upon calling this routine.
;
;  OUTPUT:
;	cd:	Array (nt) of camera descriptors with new
;		orientations.
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
pro radec_twist_to_cd, ra, dec, twist, cd=cd

 n = n_elements(ra)

 radec = dblarr(n,3)
 radec[*,0] = ra
 radec[*,1] = dec
 radec[*,2] = 1d

 y = bod_radec_to_body(bod_inertial(), radec)
 zz = tr([0d,0d,1d])

 xxx = v_rotate_11(zz, y, sin(twist-!dpi), cos(twist-!dpi)) 
 v1 = v_unit(v_cross(xxx,y))
 v2 = v_cross(y,v1)
 
 orient = dblarr(3,3,n)
 orient[0,*,*] = -v1
 orient[1,*,*] = y
 orient[2,*,*] = -v2

 bod_set_orient, cd, orient
end
;===========================================================================
