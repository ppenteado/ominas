;=============================================================================
;+
; NAME:
;       plt_init_descriptors
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
;       pd = plt_init_descriptors(n)
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
;	gbd:	Globe descriptor(s) to pass to glb_init_descriptors.
;
;	sld:	Solid descriptor(s) to pass to sld_init_descriptors.
;
;	bd:	Body descriptor(s) to pass to bod_init_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
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
;
;-
;=============================================================================
function plt_init_descriptors, n, crd=crd, bd=bd, sld=sld, gbd=gbd, pd=pd, $
@plt__keywords.include
end_keywords
@nv_lib.include


 if(NOT keyword_set(n)) then n = n_elements(pd)

 if(NOT keyword_set(pd)) then pd=replicate({planet_descriptor}, n)
 pd.class=decrapify(make_array(n, val='PLANET'))
 pd.abbrev=decrapify(make_array(n, val='PLT'))

 if(keyword_set(gbd)) then pd.gbd = gbd $
 else pd.gbd=glb_init_descriptors(n, sld=sld, crd=crd, bd=bd,  $
@glb__keywords.include
end_keywords)


 pd_p = ptrarr(n)
 nv_rereference, pd_p, pd


 return, pd_p
end
;===========================================================================



