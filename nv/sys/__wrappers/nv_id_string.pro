;=============================================================================
;+
; NAME:
;	nv_id_string
;
;
; PURPOSE:
;	Returns the identification string associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	data = nv_id_string(dd)
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
;	The identification string associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2001
;	
;-
;=============================================================================
function nv_id_string, ddp, noevent=noevent
 return, cor_name(ddp, noevent=noevent)
end
;===========================================================================



;=============================================================================
function ___nv_id_string, ddp, noevent=noevent
@nv.include
 nv_notify, ddp, type = 1, noevent=noevent
 dd = nv_dereference(ddp)
 return, dd.id_string
end
;===========================================================================



