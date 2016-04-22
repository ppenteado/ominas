;=============================================================================
;+
; NAME:
;	dsk_set_dlibldt
;
;
; PURPOSE:
;	Replaces dlibldt in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_dlibldt, bx, dlibldt
;
;
; ARGUMENTS:
;  INPUT: 
;	dkx:	 Array (nt) of any subclass of DISK.
;
;	dlibldt:	 New dlibldt value.
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
pro dsk_set_dlibldt, dkxp, dlibldt, noevent=noevent
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 dkd = nv_dereference(dkdp)

 dkd.dlibldt = dlibldt

 nv_rereference, dkdp, dkd
 nv_notify, dkdp, type = 0, noevent=noevent
end
;===========================================================================



