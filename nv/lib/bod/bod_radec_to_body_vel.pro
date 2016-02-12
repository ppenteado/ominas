;===========================================================================
;+
; NAME:
;	bod_radec_to_body_vel
;
;
; PURPOSE:
;	Transforms the given column velocity vectors from the RA/DEC coordinate
;       system associated to the body to the body coordinate system.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	body_pts = bod_radec_to_body_vel(bx, radec_pos, radec_vel)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Array (nt) of any subclass of BODY descriptors.
;
;	radec_pos:	Array (nv,3,nt) of column vectors in the bx radec frame.
;
;	radec_vel:	Array (nv,3,nt) of column velocity vectors in the bx 
;			radec frame.
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
;	Array (nv,3,nt) of column velocity vectors in the bx body frame.
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
function bod_radec_to_body_vel, bxp, r, v
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 nv = (size(r))[1]
 nt = n_elements(bd)

 ra = r[*,0,*]
 dec = r[*,1,*]
 rad = r[*,2,*]

 dra = v[*,0,*]
 ddec = v[*,1,*]
 drad = v[*,2,*]

 cos_dec = cos(dec)
 sin_dec = sin(dec)
 cos_ra = cos(ra)
 sin_ra = sin(ra)

 cos_dec_cos_ra = cos_dec*cos_ra
 cos_dec_sin_ra = cos_dec*sin_ra
 sin_dec_cos_ra = sin_dec*cos_ra
 sin_dec_sin_ra = sin_dec*sin_ra

 result = dblarr(nv,3,nt, /nozero)
 result[*,0,*] = drad*cos_dec_cos_ra - rad*ddec*sin_dec_cos_ra - rad*dra*cos_dec_sin_ra
 result[*,1,*] = drad*cos_dec_sin_ra - rad*ddec*sin_dec_sin_ra + rad*dra*cos_dec_cos_ra
 result[*,2,*] = drad*sin_dec + rad*ddec*cos_dec

 return, result
end
;===========================================================================



