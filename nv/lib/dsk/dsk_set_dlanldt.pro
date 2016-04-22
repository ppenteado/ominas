;=============================================================================
;+
; NAME:
;	dsk_set_dlanldt
;
;
; PURPOSE:
;	Replaces dlanldt in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_dlanldt, bx, dlanldt
;
;
; ARGUMENTS:
;  INPUT: 
;	dkx:	 Array (nt) of any subclass of DISK.
;
;	dlanldt:	 New dlanldt value.
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
;=============================================================================
pro dsk_set_dlanldt, dkxp, dlanldt, noevent=noevent
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 dkd = nv_dereference(dkdp)

 dkd.dlanldt = dlanldt

 nv_rereference, dkdp, dkd
 nv_notify, dkdp, type = 0, noevent=noevent
end
;===========================================================================



