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
;	
;-
;===========================================================================
pro rng_set_desc, rxp, desc
@nv_lib.include
 rdp = class_extract(rxp, 'RING')
 rd = nv_dereference(rdp)

 rd.desc=desc

 nv_rereference, rdp, rd
 nv_notify, rdp, type = 0
end
;===========================================================================



