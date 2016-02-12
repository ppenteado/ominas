;=============================================================================
;+
; NAME:
;       rng_init_descriptors
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
;       rd = rng_init_descriptors(n)
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
;	dkd:	Disk descriptor(s) to pass to dsk_init_descriptors.
;
;	sld:	Solid descriptor(s) to pass to sld_init_descriptors.
;
;	bd:	Body descriptor(s) to pass to bod_init_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
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
;
;-
;=============================================================================
function rng_init_descriptors, n, crd=crd, bd=bd, sld=sld, dkd=dkd, rd=rd, $
@rng__keywords.include
end_keywords
@nv_lib.include

 if(NOT keyword_set(n)) then n = n_elements(rd)

 if(NOT keyword_set(rd)) then rd=replicate({ring_descriptor}, n)
 rd.class=decrapify(make_array(n, val='RING'))
 rd.abbrev=decrapify(make_array(n, val='RNG'))

 if(keyword__set(primary)) then rd.primary=decrapify(primary)
 if(keyword__set(desc)) then rd.desc=decrapify(desc)

 if(keyword_set(dkd)) then rd.dkd = dkd $
 else rd.dkd=dsk_init_descriptors(n, sld=sld, crd=crd, bd=bd, $
@dsk__keywords.include
end_keywords)


 rdp = ptrarr(n)
 nv_rereference, rdp, rd


 return, rdp
end
;===========================================================================



