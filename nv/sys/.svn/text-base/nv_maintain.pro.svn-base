;=============================================================================
;+
; NAME:
;	nv_maintain
;
;
; PURPOSE:
;	Returns the maintenance value associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = nv_maintain(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
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
; RETURN:
;	The maintenance value associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2008
;	
;-
;=============================================================================
function nv_maintain, ddp
@nv.include
 nv_notify, ddp, type = 1
 dd = nv_dereference(ddp)
 return, dd.maintain
end
;===========================================================================



