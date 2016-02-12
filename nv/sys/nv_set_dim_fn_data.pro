;=============================================================================
;+
; NAME:
;	nv_set_dim_fn_data
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
;	nv_set_dim_fn_data, dd, dim_fn_data
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
;	nv_dim_fn_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
pro nv_set_dim_fn_data, ddp, dim_fn_data
@nv.include
 dd = nv_dereference(ddp)

 *dd.dim_fn_data_p = dim_fn_data

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0
 nv_notify, /flush
end
;===========================================================================



