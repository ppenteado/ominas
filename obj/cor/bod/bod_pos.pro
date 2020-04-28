;===========================================================================
;+
; NAME:
;	bod_pos
;
;
; PURPOSE:
;       Returns the position of body center (in the inertial frame)
;       for each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	pos = bod_pos(bx)
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
;       Position of body center (in the inertial frame) associated
;       with each given body descriptor.
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
function bod_pos, bd, noevent=noevent
@core.include
 nv_notify, bd, type = 1, noevent=noevent
 _bd = cor_dereference(bd)
 return, _bd.pos
end
;===========================================================================
