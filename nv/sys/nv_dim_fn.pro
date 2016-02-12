;=============================================================================
;+
; NAME:
;	nv_dim_fn
;
;
; PURPOSE:
;	Returns the dimension function associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dim_fn = nv_dim_fn(dd)
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
;	The dim_fn associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_set_dim_fn
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
function nv_dim_fn, ddp
@nv.include
 nv_notify, ddp, type = 1

 dd = nv_dereference(ddp)

 return, dd.dim_fn
end
;===========================================================================



