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
function str_create_descriptors, n, crd=_crd0, bd=_bd0, sld=_sld0, gbd=_gbd0, sd=_sd0, $
@str__keywords_tree.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1

 sd = objarr(n)
 for i=0, n-1 do $
  begin
   if(keyword_set(_crd0)) then crd0 = _crd0[i]
   if(keyword_set(_bd0)) then bd0 = _bd0[i]
   if(keyword_set(_sld0)) then sld0 = _sld0[i]
   if(keyword_set(_gbd0)) then gbd0 = _gbd0[i]
   if(keyword_set(_sd0)) then sd0 = _sd0[i]

   sd[i] = ominas_star(i, crd=crd0, bd=bd0, sld=sld0, gbd=gbd0, sd=sd0, $
@str__keywords_tree.include
end_keywords)

  end


 return, sd
end
;===========================================================================



