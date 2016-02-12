;===========================================================================
;+
; NAME:
;	bod_set_avel
;
;
; PURPOSE:
;	Replaces the angular velocity vector of each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_avel, bx, avel
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	avel:	 Array (ndv,3,nt) of new angular velocity vectors.
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
pro bod_set_avel, bxp, avel
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 bd.avel=avel

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0
end
;===========================================================================
