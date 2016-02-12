;=============================================================================
;+
; NAME:
;	bod_rotate
;
;
; PURPOSE:
;	Rotates a body about one its axes.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_rotate, bd, theta, axis=axis
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 	Any subclass of BODY (nt).
;
;	theta:		Angle of rotation (nt).
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: axis:		Body axis about which to rotate; default is 2.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2014
;	
;-
;=============================================================================
pro bod_rotate, bx, _theta, axis=axis
@nv_lib.include

 nt = n_elements(bx)
 if(NOT defined(axis)) then axis = 2

 orient = bod_orient(bx)
 axes = orient[axis,*,*] ## make_array(3,val=1d)

 theta = make_array(3,nt, val=_theta)

 orient = v_rotate_11(orient, axes, sin(theta), cos(theta))

 bod_set_orient, bx, orient
end
;===========================================================================



