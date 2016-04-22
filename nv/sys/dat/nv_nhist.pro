;=============================================================================
;+
; NAME:
;	nv_nhist
;
;
; PURPOSE:
;	Returns the number of archived data states.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nhist = nv_nhist(dd)
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
;	Integer giving the number of past data states archived
;	in the data descriptor.
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
function nv_nhist, ddp, noevent=noevent
@nv.include
 nv_notify, ddp, type = 1, noevent=noevent
 dd = nv_dereference(ddp)
 return, n_elements(*dd.data_dap)
end
;===========================================================================



