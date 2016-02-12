;==============================================================================
;+
; NAME:
;	cam_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source camera descriptors into the
;       destination camera descriptors.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cam_copy_descriptor, cd_dst, cd_src
;
;
; ARGUMENTS:
;  INPUT:
;	cd_dst:	        Array (nt) of CAMERA descriptors to copy to.
;
;	cd_src:	        Array (nt) of CAMERA descriptors to copy from.
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
pro _cam_copy_descriptor, cdp_dst, cdp_src
 nv_notify, cdp_src, type = 1
 new_cd = nv_dereference(cdp_src)

 new_cd.fn_data_p = ptr_copy_recurse(new_cd.fn_data_p)
 bod_copy_descriptor, new_cd.bd, cam_body(cdp_src)

 nv_rereference, cdp_dst, new_cd
 nv_notify, cdp_dst
end
;==============================================================================



;==============================================================================
; cam_copy_descriptor
;
;
;==============================================================================
pro cam_copy_descriptor, cdp_dst, cdp_src
@nv_lib.include
 nv_notify, cdp_src, type = 1
 cd_src = nv_dereference(cdp_src)
 cd_dst = nv_dereference(cdp_dst)

 new_cd = cd_src
 new_cd.bd = cd_dst.bd

 new_cd.fn_data_p = ptr_copy_recurse(new_cd.fn_data_p)
 bod_copy_descriptor, new_cd.bd, cam_body(cdp_src)

 nv_rereference, cdp_dst, new_cd
 nv_notify, cdp_dst
end
;==============================================================================



