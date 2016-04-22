;===========================================================================
;+
; NAME:
;	bod_lib
;
;
; PURPOSE:
;       Returns the phase of the libration vector at body time for
;       each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	lib = bod_lib(bx)
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
;       Phase of the libraton vectors at body time associated with
;       each given body descriptor.
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
function bod_lib, bxp, noevent=noevent
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 nv_notify, bdp, type = 1, noevent=noevent
 bd = nv_dereference(bdp)
 return, bd.lib
end
;===========================================================================
