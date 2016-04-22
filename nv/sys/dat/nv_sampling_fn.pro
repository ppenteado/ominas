;=============================================================================
;+
; NAME:
;	nv_sampling_fn
;
;
; PURPOSE:
;	Returns the sampling function associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	sampling_fn = nv_sampling_fn(dd)
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
;	The sampling_fn associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_set_sampling_fn
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
function nv_sampling_fn, ddp, noevent=noevent
@nv.include
 nv_notify, ddp, type = 1, noevent=noevent

 dd = nv_dereference(ddp)

 return, dd.sampling_fn
end
;===========================================================================



