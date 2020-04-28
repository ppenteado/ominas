;=============================================================================
;+
; NAME:
;	bod_inertial_to_body_default
;
;
; PURPOSE:
;	Transforms the given column vectors from the inertial coordinate
;	system to the body coordinate system.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	body_pts = bod_inertial_to_body_default(bx, inertial_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Any subclass of BODY.
;
;	inertial_pts:	Array (nv,3,nt) of column vectors in the inertial frame.
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
;=============================================================================
function bod_inertial_to_body_default, bd, v, _sub=sub
@core.include
 _bd = cor_dereference(bd)

 nt = n_elements(_bd)
 sv = size(v)
 nv = sv[1]

 if(NOT keyword_set(sub)) then sub = linegen3x(nv,3,nt)

 M0 = (_bd.orient[0,*,*])[sub]
 M1 = (_bd.orient[1,*,*])[sub]
 M2 = (_bd.orient[2,*,*])[sub]

 r = dblarr(nv,3,nt,/nozero)
 r[*,0,*] = total(M0*v,2)
 r[*,1,*] = total(M1*v,2)
 r[*,2,*] = total(M2*v,2)

 return, r
end
;===========================================================================
