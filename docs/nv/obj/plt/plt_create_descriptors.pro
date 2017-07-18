;=============================================================================
;+
; NAME:
;       plt_create_descriptors
;
;
; PURPOSE:
;	Init method for the PLANET class.
;
;
; CATEGORY:
;       NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;       pd = plt_create_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;       n:      Number of planet descriptors.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:  
;	pd:	Planet descriptor(s) to initialize, instead of creating new ones.
;
;	gbd:	Globe descriptor(s) to pass to glb_create_descriptors.
;
;	sld:	Solid descriptor(s) to pass to sld_create_descriptors.
;
;	bd:	Body descriptor(s) to pass to bod_create_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_create_descriptors.
;
;  OUTPUT: NONE
;
; RETURN:
;       An array (n) of planet descriptors.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;
;-
;=============================================================================
function plt_create_descriptors, n, crd=_crd0, bd=_bd0, sld=_sld0, gbd=_gbd0, pd=_pd0, $
@plt__keywords.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1


 pd = objarr(n)
 for i=0, n-1 do $
  begin
   if(keyword_set(_crd0)) then crd0 = _crd0[i]
   if(keyword_set(_bd0)) then bd0 = _bd0[i]
   if(keyword_set(_sld0)) then sld0 = _sld0[i]
   if(keyword_set(_gbd0)) then gbd0 = _gbd0[i]
   if(keyword_set(_pd0)) then pd0 = _pd0[i]

   pd[i] = ominas_planet(i, crd=crd0, bd=bd0, sld=sld0, gbd=gbd0, pd=pd0, $
@plt__keywords.include
end_keywords)

  end



 return, pd
end
;===========================================================================



