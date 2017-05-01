;===========================================================================
;+
; NAME:
;	bod_radec_to_body
;
;
; PURPOSE:
;	Transforms the given column vectors from the RA/DEC coordinate
;       system associated to the body to the body coordinate system.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	body_pts = bod_radec_to_body(bx, radec_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Array (nt) of any subclass of BODY descriptors.
;
;	radec_pts:	Array (nv,3,nt) of column vectors in the bx radec frame.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nv,3,nt) of column vectors in the bx body frame.
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
function bod_radec_to_body, bd, v
@core.include
 _bd = cor_dereference(bd)

 nv = (size(v))[1]
 nt = n_elements(_bd)

 result = dblarr(nv,3,nt, /nozero)

 r_cos_dec = v[*,2,*] * cos(v[*,1,*])

 result[*,0,*] = r_cos_dec * cos(v[*,0,*])
 result[*,1,*] = r_cos_dec * sin(v[*,0,*])
 result[*,2,*] = v[*,2,*] * sin(v[*,1,*])

 return, result
end
;===========================================================================



