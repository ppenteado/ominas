;=============================================================================
;+
; NAME:
;	nv_max
;
;
; PURPOSE:
;	Returns the max value associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = nv_max(dd)
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
;	The max value associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 10/2012
;	
;-
;=============================================================================
function nv_max, ddp
@nv.include
 nv_notify, ddp, type = 1
 dd = nv_dereference(ddp)
 return, dd.max
end
;===========================================================================



