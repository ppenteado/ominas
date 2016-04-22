;=============================================================================
;+
; NAME:
;	nv_dim_fn_data
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
;	dim_fn_data = nv_dim_fn_data(dd)
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
;	The dim_fn_data associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_set_dim_fn_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
function nv_dim_fn_data, ddp, noevent=noevent
@nv.include
 nv_notify, ddp, type = 1, noevent=noevent

 dd = nv_dereference(ddp)

 return, *dd.dim_fn_data_p
end
;===========================================================================



