;===========================================================================
;+
; NAME:
;	bod_body_to_inertial_pos
;
;
; PURPOSE:
;       Transforms the given column position vectors from the body
;       coordinate system to the inertial coordinate system.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	inertial_pts = bod_body_to_inertial(bx, body_pts)
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Array (nt) of any subclass of BODY descriptors.
;
;	body_pts:	Array (nv,3,nt) of column POSITION vectors in the body frame.
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
;       Array (nv,3,nt) of column position vectors in the inertial
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
function bod_body_to_inertial_pos, bd, v
@core.include
 _bd = cor_dereference(bd)

 r = bod_body_to_inertial(bd, v, _sub=sub)
 return, r + (_bd.pos)[sub]
end
;===========================================================================



