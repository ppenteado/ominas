;=============================================================================
;+
; NAME:
;	nv_set_sampling_fn
;
;
; PURPOSE:
;	Replaces the sampling function associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_sampling_fn, dd, sampling_fn
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	sampling_fn:	New sampling function.
;
;  OUTPUT:
;	dd:	Modified data descriptor.
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
; SEE ALSO:
;	nv_sampling_fn
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
pro nv_set_sampling_fn, ddp, sampling_fn, noevent=noevent
@nv.include
 dd = nv_dereference(ddp)

 dd.sampling_fn = sampling_fn

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================



