;=============================================================================
;+
; NAME:
;	arr_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	ards = str_replicate(ard, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	ard:	 Station descriptor.
;
;	dim:	 Dimensions of the result.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array of the given dimensions containing cloned versions of the input 
;	descriptor.
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
function arr_replicate, ard, dim
@core.include
 new_ard = dat_replicate(ard, dim, fn='nv_clone')
 return, new_ard
end
;==============================================================================
