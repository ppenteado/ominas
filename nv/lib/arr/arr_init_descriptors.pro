;=============================================================================
;+
; NAME:
;       arr_init_descriptors
;
;
; PURPOSE:
;	Init method for the ARRAY class.
;
;
; CATEGORY:
;       NV/LIB/arr
;
;
; CALLING SEQUENCE:
;       ard = arr_init_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;       n:      Number of array descriptors.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:  
;	ard:	Station descriptor(s) to initialize, instead of creating new 
;		ones.
;
;	bd:	Body descriptor(s) to pass to bod_init_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
;
;	primary:	Array (n) of primary strings.
;
;  OUTPUT: NONE
;
; RETURN:
;       An array (n) of array descriptors.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function arr_init_descriptors, n, crd=crd, ard=ard, $
@arr__keywords.include
end_keywords
@nv_lib.include


 if(NOT keyword_set(n)) then n = n_elements(ard)

 if(NOT keyword_set(ard)) then ard=replicate({array_descriptor}, n)
 ard.class=decrapify(make_array(n, val='ARRAY'))
 ard.abbrev=decrapify(make_array(n, val='ARR'))

 if(keyword_set(crd)) then ard.crd = crd $
 else ard.crd = cor_init_descriptors(n, $
@cor__keywords.include
end_keywords)


 ard_p = ptrarr(n)
 nv_rereference, ard_p, ard


 return, ard_p
end
;===========================================================================



