;=============================================================================
;+
; NAME:
;	dsk_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from one disk descriptor into another.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_copy_descriptor, dkd_dst, dkd_src
;
;
; ARGUMENTS:
;  INPUT:
;	dkd_dst:	 Descriptor of class DISK to copy to.
;
;	dkd_src:	 Descriptor of class DISK to copy from.
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
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro _dsk_copy_descriptor, dkdp_dst, dkdp_src, noevent=noevent
 nv_notify, dkdp_src, type = 1, noevent=noevent
 new_dkd = nv_dereference(dkdp_src)

; new_dkd.sld = nv_clone(dkd.sld)
 sld_copy_descriptor, new_dkd.sld, dsk_body(dkdp_src)

 nv_rereference, dkdp_dst, new_dkd
 nv_notify, dkdp_dst, noevent=noevent
end
;==============================================================================



;==============================================================================
; dsk_copy_descriptor
;
;
;==============================================================================
pro dsk_copy_descriptor, dkdp_dst, dkdp_src, noevent=noevent
return, nv_copy, dkdp_dst, dkdp_src, noevent=noevent
@nv_lib.include
 nv_notify, dkdp_src, type = 1, noevent=noevent
 dkd_src = nv_dereference(dkdp_src)
 dkd_dst = nv_dereference(dkdp_dst)

 new_dkd = dkd_src
 new_dkd.sld = dkd_dst.sld

 sld_copy_descriptor, new_dkd.sld, dsk_solid(dkdp_src)

 nv_rereference, dkdp_dst, new_dkd
 nv_notify, dkdp_dst, noevent=noevent
end
;==============================================================================



