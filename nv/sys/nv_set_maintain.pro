;=============================================================================
;+
; NAME:
;	nv_set_maintain
;
;
; PURPOSE:
;	Replaces the maintain flag in a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_maintain, dd, maintain
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	maintain:	New maintain flag.
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
pro nv_set_maintain, ddp, maintain
@nv.include
 dd = nv_dereference(ddp)

 dd.maintain = maintain

 if(maintain EQ 2) then nv_unload_data, dd

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0
 nv_notify, /flush
end
;===========================================================================
