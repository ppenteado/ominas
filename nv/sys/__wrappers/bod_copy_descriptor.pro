;==============================================================================
;+
; NAME:
;	bod_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source body descriptors into the
;       destination body descriptors.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_copy_descriptor, bx_dst, bx_src
;
;
; ARGUMENTS:
;  INPUT:
;	bx_dst:	        Array (nt) of any subclass of BODY to copy to.
;
;	bx_src:	        Array (nt) of any subclass of BODY to copy from.
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
pro _bod_copy_descriptor, bdp_dst, bdp_src, noevent=noevent
 nv_notify, bdp_src, type = 1, noevent=noevent
 new_bd = nv_dereference(bdp_src)

 cor_copy_descriptor, new_bd.crd, bod_core(bdp_src)

 nv_rereference, bdp_dst, new_bd
 nv_notify, bdp_dst, noevent=noevent
end
;==============================================================================



;==============================================================================
; bod_copy_descriptor
;
;
;==============================================================================
pro bod_copy_descriptor, bdp_dst, bdp_src, noevent=noevent
return, nv_copy, bdp_dst, bdp_src, noevent=noevent
@nv_lib.include
 nv_notify, bdp_src, type = 1, noevent=noevent
 bd_src = nv_dereference(bdp_src)
 bd_dst = nv_dereference(bdp_dst)

 new_bd = bd_src
 new_bd.crd = bd_dst.crd

 cor_copy_descriptor, new_bd.crd, bod_core(bdp_src)

 nv_rereference, bdp_dst, new_bd
 nv_notify, bdp_dst, noevent=noevent
end
;==============================================================================



