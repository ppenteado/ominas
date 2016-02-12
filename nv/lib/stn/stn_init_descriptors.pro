;=============================================================================
;+
; NAME:
;       stn_init_descriptors
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
;       std = stn_init_descriptors(n)
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
;	bd:	Body descriptor(s) to pass to bod_init_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
;
;	primary:	Array (n) of primary strings.
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
;
;-
;=============================================================================
function stn_init_descriptors, n, crd=crd, bd=bd, std=std, $
@stn__keywords.include
end_keywords
@nv_lib.include


 if(NOT keyword_set(n)) then n = n_elements(std)

 if(NOT keyword_set(std)) then std=replicate({station_descriptor}, n)
 std.class=decrapify(make_array(n, val='STATION'))
 std.abbrev=decrapify(make_array(n, val='STN'))

 if(keyword_set(bd)) then std.bd = bd $
 else std.bd=bod_init_descriptors(n, crd=crd,  $
@bod__keywords.include
end_keywords)


 std_p = ptrarr(n)
 nv_rereference, std_p, std


 return, std_p
end
;===========================================================================



