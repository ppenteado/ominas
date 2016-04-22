;=============================================================================
;+
; NAME:
;	nv_set_min
;
;
; PURPOSE:
;	Replaces the min value in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_min, dd, min
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	min:	New min value.
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
pro nv_set_min, ddp, min, noevent=noevent
@nv.include
 dd = nv_dereference(ddp)

 dd.min = min

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
