;=============================================================================
;+
; NAME:
;	nv_filetype
;
;
; PURPOSE:
;	Returns the filetype associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	filetype = nv_filetype(dd)
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
;	String giving the filetype.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function nv_filetype, ddp
@nv.include
 nv_notify, ddp, type = 1
 dd = nv_dereference(ddp)

 return, dd.filetype
end
;===========================================================================



