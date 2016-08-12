;===========================================================================
;+
; NAME:
;	bod_inertial_to_body_pos
;
;
; PURPOSE:
;       Transforms the given column position vectors from the inertial
;       coordinate system to the body coordinate system.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	body_pts = bod_inertial_to_body_pos(bx, inertial_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Array (nt) of any subclass of BODY descriptors.
;
;	inertial_pts:	Array (nv,3,nt) of column POSITION vectors in the inertial frame.
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
;       Array (nv,3,nt) of column position vectors in the bx body
;       frame.
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
function bod_inertial_to_body_pos, bd, v
@core.include
 _bd = cor_dereference(bd)

 nt = n_elements(_bd)
 sv = size(v)
 nv = sv[1]

 sub = linegen3x(nv,3,nt)
 vv = (v - (_bd.pos)[sub])
 return, bod_inertial_to_body(bd, vv, _sub=sub)
end
;===========================================================================



;===========================================================================
function __bod_inertial_to_body_pos, bd, v
@core.include
 _bd = cor_dereference(bd)

 nt = n_elements(_bd)
 sv = size(v)
 nv = sv[1]

 sub = linegen3x(nv,3,nt)

 vv = (v - (_bd.pos)[sub])

 M0 = (_bd.orientT[*,0,*])[sub]
 M1 = (_bd.orientT[*,1,*])[sub]
 M2 = (_bd.orientT[*,2,*])[sub]

 r = dblarr(nv,3,nt,/nozero)
 r[*,0,*] = total(M0*vv,2)
 r[*,1,*] = total(M1*vv,2)
 r[*,2,*] = total(M2*vv,2)

 return, r
end
;===========================================================================



