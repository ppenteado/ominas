;=============================================================================
;+
; NAME:
;	dsk_radial_scale
;
;
; PURPOSE:
;	Returns radial_scale for each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	radial_scale = dsk_radial_scale(dkd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	dkd:	 Any subclass of DISK.
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
;	radial_scale value associated with each given disk descriptor.
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
function dsk_radial_scale, dkd, noevent=noevent
@core.include
 
 nv_notify, dkd, type = 1, noevent=noevent
 _dkd = cor_dereference(dkd)
 return, _dkd.radial_scale
end
;===========================================================================



