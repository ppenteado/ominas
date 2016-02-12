;==============================================================================
;+
; NAME:
;	rng_clone_descriptor
;
;
; PURPOSE:
;       Allocates new ring descriptors as copies of the given
;       (existing) ring descriptors.
;
;
; CATEGORY:
;	NV/LIB/RNG
;
;
; CALLING SEQUENCE:
;	new_rx = rng_clone_descriptor(rx)
;
;
; ARGUMENTS:
;  INPUT:
;	rx:	 Array (nt) of any subclass of RING.
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
; RETURN: 
;       Newly created ring descriptors with all fields identical to
;       the input descriptors.
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
function rng_clone_descriptor, rdp
nv_message, /con, name='rng_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, rdp, type = 1
 rd = nv_dereference(rdp)

 new_rd = rd
 new_rd.dkd = dsk_clone_descriptor(rd.dkd)

 new_rdp = ptrarr(n_elements(rd))
 nv_rereference, new_rdp, new_rd

 return, new_rdp
end
;==============================================================================
