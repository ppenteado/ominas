;=============================================================================
;+
; NAME:
;	nv_set_max
;
;
; PURPOSE:
;	Replaces the max value in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_max, dd, max
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	max:	New max value.
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
pro nv_set_max, ddp, max
@nv.include
 dd = nv_dereference(ddp)

 dd.max = max

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0
 nv_notify, /flush
end
;===========================================================================
