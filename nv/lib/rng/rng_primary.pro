;===========================================================================
;+
; NAME:
;	rng_primary
;
;
; PURPOSE:
;	Returns the primary string for each given ring descriptor.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	primary = rng_primary(rd)
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
;	Primary string associated with each given ring descriptor.
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
function rng_primary, rxp, noevent=noevent
@nv_lib.include
 rdp = class_extract(rxp, 'RING')
 nv_notify, rdp, type = 1, noevent=noevent
 rd = nv_dereference(rdp)
 return, rd.primary
end
;===========================================================================



