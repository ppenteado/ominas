;=============================================================================
;+
; NAME:
;       image_celestial_northangle
;
;
; PURPOSE:
;	Computes the image azimuth (see image_azimuth.pro) of celestial north.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = image_celestial_northangle(cd)
;
;
; ARGUMENTS:
;  INPUT:
;	cd:	Camera descriptor.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	orient:	Orientation matrix to use instead of cd.
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Angle in radians.
;
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function image_celestial_northangle, cd, orient=orient

 if(NOT keyword_set(orient)) then orient = bod_orient(cd)
 zz = tr([0d,0d,1d])

 return, image_azimuth(cd, zz)
end
;===========================================================================



