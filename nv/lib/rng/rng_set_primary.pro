;===========================================================================
;+
; NAME:
;	rng_set_primary
;
;
; PURPOSE:
;	Replaces the primary string in each given ring descriptor.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	rng_set_primary, rd, primary
;
;
; ARGUMENTS:
;  INPUT: 
;	rd:	Array (nt) of STATION descriptor.
;
;	primary:	Array (nt) of primary strings.
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
pro rng_set_primary, rxp, primary
@nv_lib.include
 rdp = class_extract(rxp, 'RING')
 rd = nv_dereference(rdp)

 rd.primary=primary

 nv_rereference, rdp, rd
 nv_notify, rdp, type = 0
end
;===========================================================================



