;=============================================================================
;+
; NAME:
;	dat_set_dim_fn_data
;
;
; PURPOSE:
;	Replaces the dimension function data associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_set_dim_fn_data, dd, dim_fn_data
;
;
; ARGUMENTS:
;  INPUT:
;	dd:			Data descriptor.
;
;	dim_fn_data:	New sampling function data.
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
;	dat_dim_fn_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dat_set_dim_fn_data, dd, dim_fn_data, noevent=noevent
@core.include
 _dd = cor_dereference(dd)

 *_dd.dim_fn_data_p = dim_fn_data

 cor_rereference, dd, _dd
 nv_notify, dd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================



