;=============================================================================
;+
; NAME:
;       image_azimuth_pos
;
;
; PURPOSE:
;	Computes azimuth angle of projection of inertial vector v 
;	into the image plane. 
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       v = image_azimuth_pos(cd, v)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Any subclass of GLOBE.
;
;	v:	Inertial vector.
;
;  OUTPUT:
;       NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Image azimuth.  When the image is displayed with (0,0) at 
;	the top-left, the azimuth angle is measured counterclockwise from 
;	"up".
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function image_azimuth, cd, v

 vv = bod_inertial_to_body(cd, v)

 azimuth = -atan(vv[0], -vv[2])

 return, azimuth
end
;===========================================================================



