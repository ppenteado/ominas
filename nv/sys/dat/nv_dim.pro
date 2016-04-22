;=============================================================================
;+
; NAME:
;	nv_dim
;
;
; PURPOSE:
;	Returns the dimensions of the data array in the given data 
;	descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dim = nv_dim(dd)
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
;  INPUT: 
;	true:	If set, the dimension function is not called and the true
;	 	dimensions of the dat are returned.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Array giving the dimensions of the data in the data descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function nv_dim, ddp, true=true, noevent=noevent
@nv.include
 nv_notify, ddp, type = 1, noevent=noevent
 dd = nv_dereference(ddp)

 if(NOT ptr_valid(dd.dim_p)) then return, 0

 if(keyword_set(true) OR (NOT keyword_set(dd.dim_fn))) then return, *dd.dim_p

 return, call_function(dd.dim_fn, ddp, *dd.dim_fn_data_p)
end
;=============================================================================
