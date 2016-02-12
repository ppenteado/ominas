;===========================================================================
;+
; NAME:
;	rng_set_disk
;
;
; PURPOSE:
;	Replaces the disk descriptor in each given ring descriptor.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	rng_set_disk, rd, dkd
;
;
; ARGUMENTS:
;  INPUT: 
;	rd:	 Array (nt) of RING descriptors.
;
;	dkd:	 Array (nt) of DISK descriptors.
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
pro rng_set_disk, rxp, dkdp
@nv_lib.include
 rdp = class_extract(rxp, 'RING')
 rd = nv_dereference(rdp)

 rd.dkd=dkdp

 nv_rereference, rdp, rd
 nv_notify, rdp, type = 0
end
;===========================================================================



