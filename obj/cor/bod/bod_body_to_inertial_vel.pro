;===========================================================================
;+
; NAME:
;	bod_body_to_inertial_vel
;
;
; PURPOSE:
;       Transforms the given column velocity vectors from the body
;       coordinate system to the inertial coordinate system.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	inertial_vel = bod_body_to_inertial_vel(bx, body_vel)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Array (nt) of any subclass of BODY descriptors.
;
;	body_vel:	Array (nv,3,nt) of column velocity vectors in the body frame.
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
;       Array (nv,3,nt) of column velocity vectors in the inertial
;       frame.
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
function bod_body_to_inertial_vel, bd, v
@core.include
 _bd = cor_dereference(bd)

 r = bod_body_to_inertial(bd, v, _sub=sub)
 return, r + (_bd.vel)[sub]	; this won't work for derivatives
end
;===========================================================================



;===========================================================================
function ___bod_body_to_inertial_vel, bd, v
@core.include
 _bd = cor_dereference(bd)

 nt = n_elements(_bd)
 sv = size(v)
 nv = sv[1]

 sub = linegen3x(nv,3,nt)

 M0 = (_bd.orient[*,0,*])[sub]
 M1 = (_bd.orient[*,1,*])[sub]
 M2 = (_bd.orient[*,2,*])[sub]

 r = dblarr(nv,3,nt,/nozero)
 r[*,0,*] = total(M0*v,2)
 r[*,1,*] = total(M1*v,2)
 r[*,2,*] = total(M2*v,2)

 return, r + (_bd.vel)[sub]
end
;===========================================================================



