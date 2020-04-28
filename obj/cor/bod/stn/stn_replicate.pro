;=============================================================================
;+
; NAME:
;	stn_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	stds = str_replicate(std, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	std:	 Station descriptor.
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
function stn_replicate, std, dim
@core.include
 new_std = dat_replicate(std, dim, fn='nv_clone')
 return, new_std
end
;==============================================================================
