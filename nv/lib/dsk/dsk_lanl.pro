;=============================================================================
;+
; NAME:
;	dsk_lanl
;
;
; PURPOSE:
;	Returns lanl for each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	lanl = dsk_lanl(dkx)
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
;	lanl value associated with each given disk descriptor.
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
function dsk_lanl, dkxp, noevent=noevent
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 nv_notify, dkdp, type = 1, noevent=noevent
 dkd = nv_dereference(dkdp)
 return, dkd.lanl
end
;===========================================================================



