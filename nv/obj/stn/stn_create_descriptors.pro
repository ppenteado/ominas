;=============================================================================
;+
; NAME:
;       stn_create_descriptors
;
;
; PURPOSE:
;	Init method for the STATION class.
;
;
; CATEGORY:
;       NV/LIB/STN
;
;
; CALLING SEQUENCE:
;       std = stn_create_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;       n:      Number of station descriptors.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:  
;	std:	Station descriptor(s) to initialize, instead of creating new 
;		ones.
;
;	bd:	Body descriptor(s) to pass to bod_create_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_create_descriptors.
;
;	primary:	Array (n) of primary descriptors.
;
;  OUTPUT: NONE
;
; RETURN:
;       An array (n) of station descriptors.
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
function stn_create_descriptors, n, crd=_crd0, bd=_bd0, std=_std0, $
@stn__keywords_tree.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1


 std = objarr(n)
 for i=0, n-1 do $
  begin
   if(keyword_set(_crd0)) then crd0 = _crd0[i]
   if(keyword_set(_bd0)) then bd0 = _bd0[i]
   if(keyword_set(_std0)) then std0 = _std0[i]

   std[i] = ominas_station(i, crd=crd0, bd=bd0, std=std0, $
@stn__keywords_tree.include
end_keywords)

  end


 return, std
end
;===========================================================================



