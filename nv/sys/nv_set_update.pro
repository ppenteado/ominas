;=============================================================================
;+
; NAME:
;	nv_set_update
;
;
; PURPOSE:
;	Changes the update flag in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_update, dd, update
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	update:	New update flag.
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
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro nv_set_update, ddp, update
@nv.include
 dd = nv_dereference(ddp)

 dd.update = update

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0
 nv_notify, /flush
end
;===========================================================================
