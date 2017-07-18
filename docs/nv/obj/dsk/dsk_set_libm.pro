;=============================================================================
;+
; NAME:
;	dsk_set_libm
;
;
; PURPOSE:
;	Replaces libm in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_libm, bx, libm
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	libm:	 New libm value.
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
;=============================================================================
pro dsk_set_libm, dkd, libm, noevent=noevent
@core.include
 
 _dkd = cor_dereference(dkd)

 _dkd.libm = libm

 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================



