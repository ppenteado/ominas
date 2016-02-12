;=============================================================================
;+
; NAME:
;	rng_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	rds = rng_replicate(rd, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	rd:	 Ring descriptor.
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
function rng_replicate, rdp, dim
@nv_lib.include
 new_rdp = nv_replicate(rdp, dim, fn='nv_clone')
 return, new_rdp
end
;==============================================================================
