;===========================================================================
;+
; NAME:
;	rng_set_desc
;
;
; PURPOSE:
;	Replaces the description string in each given ring descriptor.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	rng_set_desc, rd, desc
;
;
; ARGUMENTS:
;  INPUT: 
;	rd:	Array (nt) of STATION descriptors.
;
;	desc:	Array (nt) of description strings.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro rng_set_desc, rd, desc, noevent=noevent
@core.include

 _rd = cor_dereference(rd)

 _rd.desc = strupcase(desc)

 cor_rereference, rd, _rd
 nv_notify, rd, type = 0, noevent=noevent
end
;===========================================================================



