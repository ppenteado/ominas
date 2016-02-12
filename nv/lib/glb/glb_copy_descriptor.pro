;==============================================================================
;+
; NAME:
;	glb_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source globe descriptors into the
;       destination globe descriptors.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_copy_descriptor, gbx_dst, gbx_src
;
;
; ARGUMENTS:
;  INPUT:
;	gbx_dst:	Array (nt) of any subclass of GLOBE descriptors to copy to.
;
;	gbx_src:	Array (nt) of any subclass of GLOBE descriptors to copy from.
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
pro _glb_copy_descriptor, gbdp_dst, gbdp_src
 nv_notify, gbdp_src, type = 1
 new_gbd = nv_dereference(gbdp_src)

 sld_copy_descriptor, new_gbd.sld, glb_body(gbdp_src)

 nv_rereference, gbdp_dst, new_gbd
 nv_notify, gbdp_dst
end
;==============================================================================



;==============================================================================
; glb_copy_descriptor
;
;
;==============================================================================
pro glb_copy_descriptor, gbdp_dst, gbdp_src
@nv_lib.include
 nv_notify, gbdp_src, type = 1
 gbd_src = nv_dereference(gbdp_src)
 gbd_dst = nv_dereference(gbdp_dst)

 new_gbd = gbd_src
 new_gbd.sld = gbd_dst.sld

 sld_copy_descriptor, new_gbd.sld, glb_solid(gbdp_src)

 nv_rereference, gbdp_dst, new_gbd
 nv_notify, gbdp_dst
end
;==============================================================================



