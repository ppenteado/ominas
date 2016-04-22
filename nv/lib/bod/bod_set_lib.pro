;===========================================================================
;+
; NAME:
;	bod_set_lib
;
;
; PURPOSE:
;       Replaces the phase of the libration vector at body time for
;       each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_lib, bx, lib
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	lib:	 Array (ndv,nt) of new phases of the libration vectors.
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
pro bod_set_lib, bxp, lib, noevent=noevent
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 bd.lib=lib

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0, noevent=noevent
end
;===========================================================================
