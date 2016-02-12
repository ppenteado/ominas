;=============================================================================
;+
; NAME:
;	nv_sampling_fn_data
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
;	sampling_fn_data = nv_sampling_fn_data(dd)
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
;	The sampling_fn_data associated with the data descriptor.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_set_sampling_fn_data
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/2015
;	
;-
;=============================================================================
function nv_sampling_fn_data, ddp
@nv.include
 nv_notify, ddp, type = 1

 dd = nv_dereference(ddp)

 return, *dd.sampling_fn_data_p
end
;===========================================================================



