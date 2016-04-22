;=============================================================================
;+
; NAME:
;	dsk_solid
;
;
; PURPOSE:
;	Returns the solid descriptor for each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	solid = dsk_solid(dkx)
;
;
; ARGUMENTS:
;  INPUT: 
;	dkx:	 Array (nt) subclass of DISK.
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
;	Array solid descriptors associated with each given disk descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
function dsk_solid, dkxp, noevent=noevent
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1, noevent=noevent
 dkd = nv_dereference(dkdp)
 return, dkd.sld
end
;===========================================================================



