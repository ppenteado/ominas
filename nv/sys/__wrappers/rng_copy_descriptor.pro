;==============================================================================
;+
; NAME:
;	rng_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source ring descriptors into the
;       destination ring descriptors.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	rng_copy_descriptor, rx_dst, rx_src
;
;
; ARGUMENTS:
;  INPUT:
;	rx_dst:	        Array (nt) of any subclass of RING to copy to.
;
;	rx_src:	        Array (nt) of any subclass of RING to copy from.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
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
;==============================================================================
pro rng_copy_descriptor, rdp_dst, rdp_src, noevent=noevent
return, nv_copy, rdp_dst, rdp_src, noevent=noevent
@nv_lib.include
 nv_notify, rdp_src, type = 1, noevent=noevent
 rd_src = nv_dereference(rdp_src)
 rd_dst = nv_dereference(rdp_dst)

 new_rd = rd_src
 new_rd.dkd = rd_dst.dkd

 dsk_copy_descriptor, new_rd.dkd, rng_disk(rdp_src)

 nv_rereference, rdp_dst, new_rd
 nv_notify, rdp_dst, noevent=noevent
end
;==============================================================================



