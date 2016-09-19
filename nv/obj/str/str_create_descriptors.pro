;=============================================================================
;+
; NAME:
;       str_create_descriptors
;
;
; PURPOSE:
;	Init method for the STAR class.
;
;
; CATEGORY:
;       NV/LIB/STR
;
;
; CALLING SEQUENCE:
;       sd = str_create_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;       n:      Number of star descriptors.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:  
;	sd:	Star descriptor(s) to initialize, instead of creating new ones.
;
;	gbd:	Globe descriptor(s) to pass to glb_create_descriptors.
;
;	sld:	Solid descriptor(s) to pass to sld_create_descriptors.
;
;	bd:	Body descriptor(s) to pass to bod_create_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_create_descriptors.
;
;	lum:	Array (n) of luminosity values.
;
;	sp:	Array (n) of spectral class strings.
;
;  OUTPUT: NONE
;
; RETURN:
;       An array (n) of star descriptors.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 5/1998
; 	Adapted by:	Spitale, 5/2016
;
;-
;=============================================================================
function str_create_descriptors, n, crd=crd0, bd=bd0, sld=sld0, gbd=gbd0, sd=sd0, $
@str__keywords.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1

 sd = objarr(n)
 for i=0, n-1 do $
  begin

   sd[i] = ominas_star(i, crd=crd0, bd=bd0, sld=sld0, gbd=gbd0, sd=sd0, $
@str__keywords.include
end_keywords)

  end


 return, sd
end
;===========================================================================



