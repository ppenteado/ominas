;=============================================================================
;+
; NAME:
;	dat_dim
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
;	dim = dat_dim(dd)
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dat_dim, dd, true=true, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent
 _dd = cor_dereference(dd)

 if(NOT ptr_valid(_dd.dim_p)) then return, 0

 if(keyword_set(true) OR (NOT keyword_set(_dd.dim_fn))) then return, *_dd.dim_p

 return, call_function(_dd.dim_fn, dd, *_dd.dim_fn_data_p)
end
;=============================================================================
