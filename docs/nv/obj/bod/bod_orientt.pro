;===========================================================================
;+
; NAME:
;	bod_orientt
;
;
; PURPOSE:
;	Returns the transpose of the orientation matrix for each given body 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	orient_T = bod_orientt(bx)
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
;	Transpose of the orientation matrix associated with each given body 
;	descriptor.
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
function bod_orientT, bd, noevent=noevent
@core.include
 nv_notify, bd, type = 1, noevent=noevent
 _bd = cor_dereference(bd)
 return, _bd.orientT
end
;===========================================================================
