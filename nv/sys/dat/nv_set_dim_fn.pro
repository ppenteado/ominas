;=============================================================================
;+
; NAME:
;	nv_set_dim_fn
;
;
; PURPOSE:
;	Replaces the dimension function associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_dim_fn, dd, dim_fn
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	dim_fn:	New sampling function.
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
;	nv_dim_fn
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
pro nv_set_dim_fn, ddp, dim_fn, noevent=noevent
@nv.include
 dd = nv_dereference(ddp)

 dd.dim_fn = dim_fn

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================



