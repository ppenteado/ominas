;=============================================================================
;+
; NAME:
;	plt_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;	pds = plt_replicate(pd, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	pd:	 Planet descriptor.
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
function plt_replicate, pdp, dim
@nv_lib.include
 new_pdp = nv_replicate(pdp, dim, fn='nv_clone')
 return, new_pdp
end
;==============================================================================
