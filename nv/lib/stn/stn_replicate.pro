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
;	
;-
;=============================================================================
function stn_replicate, stdp, dim
@nv_lib.include
 new_stdp = nv_replicate(stdp, dim, fn='nv_clone')
 return, new_stdp
end
;==============================================================================
