;=============================================================================
;+
; NAME:
;       str_init_descriptors
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
;       sd = str_init_descriptors(n)
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
;	gbd:	Globe descriptor(s) to pass to glb_init_descriptors.
;
;	sld:	Solid descriptor(s) to pass to sld_init_descriptors.
;
;	bd:	Body descriptor(s) to pass to bod_init_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
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
;
;-
;=============================================================================
function str_init_descriptors, n, crd=crd, bd=bd, sld=sld, gbd=gbd, sd=sd, $
@str__keywords.include
end_keywords
@nv_lib.include

 if(NOT keyword_set(n)) then n = n_elements(sd)

 if(NOT keyword_set(sd)) then sd=replicate({star_descriptor}, n)
 sd.class=decrapify(make_array(n, val='STAR'))
 sd.abbrev=decrapify(make_array(n, val='STR'))

 if(keyword_set(gbd)) then sd.gbd = gbd $
 else sd.gbd=glb_init_descriptors(n, crd=crd, bd=bd, sld=sld,  $
@glb__keywords.include
end_keywords)

 if(keyword_set(lum)) then sd.lum=decrapify(lum)
 if(keyword_set(sp)) then sd.sp=decrapify(sp)


 sdp = ptrarr(n)
 nv_rereference, sdp, sd

 return, sdp
end
;===========================================================================



