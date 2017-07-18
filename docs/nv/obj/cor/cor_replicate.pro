;=============================================================================
;+
; NAME:
;	cor_replicate
;
;
; PURPOSE:
;	Replicates the given descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	xd = cor_replicate(crx, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	crx:	 Any subclass of CORE.  Only one descriptor may be provided.
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
function cor_replicate, crd, dim
@core.include
 if(NOT keyword_set(fn)) then fn = 'nv_clone'

 ndim = n_elements(dim)
 nelm = product(dim)

 result = make_array(dim=dim, /obj)

 for i=0, nelm-1 do result[i] = call_function(fn, crd)

 return, result
end
;==============================================================================
