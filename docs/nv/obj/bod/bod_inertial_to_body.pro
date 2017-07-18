;=============================================================================
;+
; NAME:
;	bod_inertial_to_body
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
;	body_pts = bod_inertial_to_body(bx, inertial_pts)
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
function bod_inertial_to_body, bd, v, _sub=sub
@core.include
 _bd = cor_dereference(bd)
 return, call_function(_bd[0].fn_inertial_to_body, bd, v, _sub=sub)
end
;===========================================================================
