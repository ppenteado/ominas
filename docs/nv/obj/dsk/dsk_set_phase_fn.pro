;===========================================================================
;+
; NAME:
;	dsk_set_phase_fn
;
;
; PURPOSE:
;       Replaces the phase function for each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_phase_fn, dkd, phase_fn
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Array (nt) of any subclass of DISK descriptors.
;
;	phase_fn: Array (nt) of new phase functions.
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
pro dsk_set_phase_fn, dkd, phase_fn, noevent=noevent
@core.include
 
 _dkd = cor_dereference(dkd)

 _dkd.phase_fn=phase_fn

 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================
