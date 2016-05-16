;=============================================================================
;+
; NAME:
;       rng_create_descriptors
;
;
; PURPOSE:
;	Init method for the RING class.
;
;
; CATEGORY:
;       NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;       rd = rng_create_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;       n:      Number of ring descriptors.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:  
;	rd:	Ring descriptor(s) to initialize, instead of creating new 
;		ones.
;
;	dkd:	Disk descriptor(s) to pass to dsk_create_descriptors.
;
;	sld:	Solid descriptor(s) to pass to sld_create_descriptors.
;
;	bd:	Body descriptor(s) to pass to bod_create_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_create_descriptors.
;
;	primary:	Array (n) of primary strings.
;
;	desc:	Array (n) of description strings.
;
;  OUTPUT: NONE
;
; RETURN:
;       An array (n) of ring descriptors.
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
function rng_create_descriptors, n, crd=crd0, bd=bd0, sld=sld0, dkd=dkd0, rd=rd0, $
@ring__keywords.include
end_keywords
@core.include
 if(NOT keyword_set(n)) then n = 1


 rd = objarr(n)
 for i=0, n-1 do $
  begin

   rd[i] = ominas_ring(i, crd=crd0, bd=bd0, sld=sld0, dkd=dkd0, rd=rd0, $
@ring__keywords.include
end_keywords)

  end


 return, rd
end
;===========================================================================



