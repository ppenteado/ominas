;=============================================================================
;+
; NAME:
;	dsk_dlpmdt
;
;
; PURPOSE:
;	Returns dlpmdt for each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dlpmdt = dsk_dlpmdt(dkx)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	dkx:	 Any subclass of DISK.
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
;	dlpmdt value associated with each given disk descriptor.
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
;=============================================================================
function dsk_dlpmdt, dkxp, noevent=noevent
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1, noevent=noevent
 dkd = nv_dereference(dkdp)
 return, dkd.dlpmdt
end
;===========================================================================



