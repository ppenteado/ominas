;=============================================================================
;+
; NAME:
;       arr_create_descriptors
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
;       ard = arr_create_descriptors(n)
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
;	bd:	Body descriptor(s) to pass to bod_create_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_create_descriptors.
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
; 	Adapted by:	Spitale, 5/2016
;
;-
;=============================================================================
function arr_create_descriptors, n, crd=_crd0, ard=_ard0, $
@arr__keywords_tree.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1

 ard = objarr(n)
 for i=0, n-1 do $
  begin
   if(keyword_set(_crd0)) then crd0 = _crd0[i]
   if(keyword_set(_ard0)) then ard0 = _ard0[i]

   ard[i] = ominas_array(i, crd=crd0, ard=ard0, $
@arr__keywords_tree.include
end_keywords)

  end
 
 return, ard
end
;===========================================================================



