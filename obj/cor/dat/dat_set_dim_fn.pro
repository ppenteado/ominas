;=============================================================================
;+
; NAME:
;	dat_set_dim_fn
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
;	dat_set_dim_fn, dd, dim_fn
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
;	dat_dim_fn
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dat_set_dim_fn, dd, dim_fn, noevent=noevent
@core.include
 _dd = cor_dereference(dd)

 _dd.dim_fn = dim_fn

 cor_rereference, dd, _dd
 nv_notify, dd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================



