;=============================================================================
;+
; NAME:
;	str_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/STR
;
;
; CALLING SEQUENCE:
;	sds = str_replicate(sd, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	sd:	 Star descriptor.
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
function str_replicate, sd, dim
@core.include
 new_sd = dat_replicate(sd, dim, fn='nv_clone')
 return, new_sd
end
;==============================================================================
