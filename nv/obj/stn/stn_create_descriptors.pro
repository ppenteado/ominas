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
function stn_create_descriptors, n, crd=crd0, bd=bd0, std=std0, $
@stn__keywords.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1


 std = objarr(n)
 for i=0, n-1 do $
  begin

   std[i] = ominas_station(i, crd=crd0, bd=bd0, std=std0, $
@stn__keywords.include
end_keywords)

  end


 return, std
end
;===========================================================================



