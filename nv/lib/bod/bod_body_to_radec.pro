;===========================================================================
;+
; NAME:
;	bod_body_to_radec
;
;
; PURPOSE:
;       Transforms the given column vectors from the body coordinate
;       system to the RA/DEC coordinate system associated to that
;       body.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	radec_pts = bod_body_to_radec(bx, body_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Array (nt) of any subclass of BODY descriptors.
;
;	body_pts:	Array (nv,3,nt) of column vectors in the body frame.
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
;       Array (nv,3,nt) of column vectors in the bx radec frame.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;===========================================================================
function bod_body_to_radec, bxp, v
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 nv = (size(v))[1]
 nt = n_elements(bd)

 result = dblarr(nv,3,nt, /nozero)
 result[*,0,*] = atan(v[*,1,*], v[*,0,*])			; ra
 result[*,2,*] = v_mag(v)					; distance
 result[*,1,*] = !dpi/2d - acos(v[*,2,*]/result[*,2,*])		; dec

 return, result
end
;===========================================================================



