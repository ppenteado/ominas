;===========================================================================
;+
; NAME:
;	dsk_set_refl_fn
;
;
; PURPOSE:
;       Replaces the reflection function for each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/dsk
;
;
; CALLING SEQUENCE:
;	dsk_set_refl_fn, dkx, refl_fn
;
;
; ARGUMENTS:
;  INPUT: 
;	dkx:	 Array (nt) of any subclass of DISK descriptors.
;
;	refl_fn: Array (nt) of new reflection functions.
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
pro dsk_set_refl_fn, dkxp, refl_fn, noevent=noevent
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 dkd = nv_dereference(dkdp)

 dkd.refl_fn=refl_fn

 nv_rereference, dkdp, dkd
 nv_notify, dkdp, type = 0, noevent=noevent
end
;===========================================================================
