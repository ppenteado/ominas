;===========================================================================
;+
; NAME:
;	rng_disk
;
;
; PURPOSE:
;	Returns the disk descriptor for each given ring descriptor.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	dkd = rng_disk(rd)
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
;	Disk descriptor associated with each given ring descriptor.
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
function rng_disk, rxp, noevent=noevent
@nv_lib.include
 rdp = class_extract(rxp, 'RING')
 nv_notify, rdp, type = 1, noevent=noevent
 rd = nv_dereference(rdp)
 return, rd.dkd
end
;===========================================================================



