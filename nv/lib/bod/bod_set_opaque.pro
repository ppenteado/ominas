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
;	
;-
;===========================================================================
pro bod_set_opaque, bxp, opaque
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 bd.opaque=opaque

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0
end
;===========================================================================



