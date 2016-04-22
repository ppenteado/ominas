;===========================================================================
;+
; NAME:
;	bod_vel
;
;
; PURPOSE:
;       Returns the velocity of body center (in the inertial frame)
;       for each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	vel = bod_vel(bx)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Velocity of body center (in the inertial frame) associated
;       with each given body descriptor.
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
function bod_vel, bxp, noevent=noevent
 bdp = class_extract(bxp, 'BODY')
 nv_notify, bdp, type = 1, noevent=noevent
 bd = nv_dereference(bdp)
 return, bd.vel
end
;===========================================================================
