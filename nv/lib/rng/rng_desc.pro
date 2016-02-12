;===========================================================================
;+
; NAME:
;	rng_desc
;
;
; PURPOSE:
;	Returns the description string for each given ring descriptor.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	desc = rng_desc(rd)
;
;
; ARGUMENTS:
;  INPUT: 
;	rd:	 Array (nt) of RING descriptors.
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
; RETURN:
;	Description string associated with each given ring descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;===========================================================================
function rng_desc, rxp
@nv_lib.include
 rdp = class_extract(rxp, 'RING')
 nv_notify, rdp, type = 1
 rd = nv_dereference(rdp)
 return, rd.desc
end
;===========================================================================



