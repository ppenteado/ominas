;===========================================================================
;+
; NAME:
;	bod_body_to_radec_vel
;
;
; PURPOSE:
;       Transforms the given column velocity vectors from the body coordinate
;       system to the RA/DEC coordinate system associated with that body.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	radec_pts = bod_body_to_radec_vel(bx, body_pts)
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
; 	Written by:	Spitale, 7/2015
;	
;-
;===========================================================================
function bod_body_to_radec_vel, bxp, r, v
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 nv = (size(r))[1]
 nt = n_elements(bd)

 ra = r[*,0,*]
 dec = r[*,1,*]
 rad = r[*,2,*]

 cos_dec = cos(dec)
 sin_dec = sin(dec)
 cos_ra = cos(ra)
 sin_ra = sin(ra)

 cos_dec_cos_ra = cos_dec*cos_ra
 cos_dec_sin_ra = cos_dec*sin_ra
 sin_dec_cos_ra = sin_dec*cos_ra
 sin_dec_sin_ra = sin_dec*sin_ra

 dx = v[*,0,*]
 dy = v[*,1,*]
 dz = v[*,2,*]

 result = dblarr(nv,3,nt, /nozero)

 drad = dx*cos_dec_cos_ra + dy*cos_dec_sin_ra + dz*sin_dec

 result[*,0,*] = (dy*cos_ra - dx*sin_ra) / (rad*cos_dec)
 result[*,1,*] = (rd*cos_dec - dx*cos_ra - dy*sin_ra) / (drad*sin_dec)
 result[*,2,*] = drad

 return, result
end
;===========================================================================



