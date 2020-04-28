;===========================================================================
;+
; NAME:
;	bod_set_opaque
;
;
; PURPOSE:
;	Replaces the opaque flag of each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_opaque, bx, opaque
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	avel:	 Array (nt) of new opaque values.
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
pro bod_set_opaque, bd, opaque, noevent=noevent
@core.include
 _bd = cor_dereference(bd)

 _bd.opaque=opaque

 cor_rereference, bd, _bd
 nv_notify, bd, type = 0, noevent=noevent
end
;===========================================================================



