;===========================================================================
;+
; NAME:
;	bod_set_libv
;
;
; PURPOSE:
;	Replaces the libration vector of each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_libv, bx, libv
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	libv:	 Array (ndv,3,nt) of new libration vectors.
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
pro bod_set_libv, bxp, libv
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 bd.libv=libv

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0
end
;===========================================================================
