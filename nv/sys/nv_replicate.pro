;=============================================================================
;+
; NAME:
;	nv_replicate
;
;
; PURPOSE:
;	Replicates the given data descriptor, producing an array of the given
;	dimensions containing cloned versions of the input descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	dds = nv_replicate(dd, dim)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	 Data deccriptor to replicate.
;
;	dim:	 Dimensions of the result.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	fn:	Name of the cloning function.  Default is nv_clone.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array of the given dimensions containing cloned versions of the input 
;	data descriptor.
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
function nv_replicate, dp, dim, fn=fn
@nv.include

 if(NOT keyword_set(fn)) then fn = 'nv_clone'

 ndim = n_elements(dim)
 nelm = product(dim)

 result = make_array(dim=dim, /ptr)

 for i=0, nelm-1 do result[i] = call_function(fn, dp)

 return, result
end
;=============================================================================
