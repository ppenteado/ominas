;=============================================================================
;+
; NAME:
;	nv_set_sampling_fn_data
;
;
; PURPOSE:
;	Replaces the sampling function data associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_set_sampling_fn_data, dd, sampling_fn_data
;
;
; ARGUMENTS:
;  INPUT:
;	dd:			Data descriptor.
;
;	sampling_fn_data:	New sampling function data.
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
;	nv_sampling_fn_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
pro nv_set_sampling_fn_data, ddp, sampling_fn_data
@nv.include
 dd = nv_dereference(ddp)

 *dd.sampling_fn_data_p = sampling_fn_data

 nv_rereference, ddp, dd
 nv_notify, ddp, type = 0
 nv_notify, /flush
end
;===========================================================================



