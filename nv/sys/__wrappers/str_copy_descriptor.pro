;==============================================================================
;+
; NAME:
;	str_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source star descriptors into the
;       destination star descriptors.
;
;
; CATEGORY:
;	NV/LIB/STR
;
;
; CALLING SEQUENCE:
;	str_copy_descriptor, sx_dst, sx_src
;
;
; ARGUMENTS:
;  INPUT:
;	sx_dst:	        Array (nt) of any subclass of STAR to copy to.
;
;	sx_src:	        Array (nt) of any subclass of STAR to copy from.
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
pro str_copy_descriptor, sdp_dst, sdp_src, noevent=noevent
return, nv_copy, sdp_dst, sdp_src, noevent=noevent
@nv_lib.include
 nv_notify, sdp_src, type = 1, noevent=noevent
 sd_src = nv_dereference(sdp_src)
 sd_dst = nv_dereference(sdp_dst)

 new_sd = sd_src
 new_sd.gbd = sd_dst.gbd

 glb_copy_descriptor, new_sd.gbd, str_globe(sdp_src)

 nv_rereference, sdp_dst, new_sd
 nv_notify, sdp_dst, noevent=noevent
end
;==============================================================================



