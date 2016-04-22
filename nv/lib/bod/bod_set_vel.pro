;===========================================================================
;+
; NAME:
;	bod_set_vel
;
;
; PURPOSE:
;       Replaces the velocity vector (of body center in the inertial
;       frame) of each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_vel, bx, vel
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	vel:	 Array (ndv,3,nt) of new velocity vectors.
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
; RETURN: NONE
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
pro bod_set_vel, bxp, vel, noevent=noevent
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 bd.vel=vel

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0, noevent=noevent
end
;===========================================================================
