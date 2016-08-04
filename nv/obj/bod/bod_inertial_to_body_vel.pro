;===========================================================================
;+
; NAME:
;	bod_inertial_to_body_vel
;
;
; PURPOSE:
;       Transforms the given column velocity vectors from the inertial
;       coordinate system to the body coordinate system.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	body_vel = bod_inertial_to_body_vel(bx, inertial_vel)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Array (nt) of any subclass of BODY descriptors.
;
;	inertial_vel:	Array (nv,3,nt) of column velocity vectors in the inertial frame.
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
;       Array (nv,3,nt) of column velocity vectors in the bx body
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
function bod_inertial_to_body_vel, bd, v
@core.include
 _bd = cor_dereference(bd)

 nt = n_elements(_bd)
 sv = size(v)
 nv = sv[1]

 sub = linegen3x(nv,3,nt)
 vv = (v - (_bd.vel))[sub]	; this won't work for derivatives
 return, bod_inertial_to_body(bd, vv, _sub=sub)
end
;===========================================================================



;===========================================================================
function __bod_inertial_to_body_vel, bd, v
@core.include
 _bd = cor_dereference(bd)

 nt = n_elements(_bd)
 sv = size(v)
 nv = sv[1]

 sub = linegen3x(nv,3,nt)

 M0 = (_bd.orientT[*,0,*])[sub]
 M1 = (_bd.orientT[*,1,*])[sub]
 M2 = (_bd.orientT[*,2,*])[sub]

 vv = (v - (_bd.vel));[sub]

 r = dblarr(nv,3,nt,/nozero)
 r[*,0,*] = total(M0*vv,2)
 r[*,1,*] = total(M1*vv,2)
 r[*,2,*] = total(M2*vv,2)

 return, r
end
;===========================================================================



