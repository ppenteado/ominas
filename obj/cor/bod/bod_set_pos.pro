;===========================================================================
;+
; NAME:
;	bod_set_pos
;
;
; PURPOSE:
;       Replaces the position of body center (in the inertial frame)
;       of each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_pos, bx, pos
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	pos:	 Array (1,3,nt) of new position vectors.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro bod_set_pos, bd, pos, noevent=noevent
@core.include
 _bd = cor_dereference(bd)

 _bd.pos=pos

 cor_rereference, bd, _bd
 nv_notify, bd, type = 0, noevent=noevent
end
;===========================================================================
