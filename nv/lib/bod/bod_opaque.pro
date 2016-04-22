;===========================================================================
;+
; NAME:
;	bod_opaque
;
;
; PURPOSE:
;	Returns the opaque value for each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	opaque = bod_opaque(bx)
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
;	Opaque value associated with each given body descriptor.
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
function bod_opaque, bxp, noevent=noevent
 bdp = class_extract(bxp, 'BODY')
 nv_notify, bdp, type = 1, noevent=noevent
 bd = nv_dereference(bdp)
 return, bd.opaque
end
;===========================================================================



