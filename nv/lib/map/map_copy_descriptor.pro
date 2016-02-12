;==============================================================================
;+
; NAME:
;	map_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source map descriptors into the
;       destination map descriptors.
;
;
; CATEGORY:
;	NV/LIB/MAP
;
;
; CALLING SEQUENCE:
;	map_copy_descriptor, md_dst, md_src
;
;
; ARGUMENTS:
;  INPUT:
;	md_dst:	        Array (nt) of MAP descriptors to copy to.
;
;	md_src:	        Array (nt) of MAP descriptors to copy from.
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
pro map_copy_descriptor, mdp_dst, mdp_src
@nv_lib.include
 nv_notify, mdp_src, type = 1
 md_src = nv_dereference(mdp_src)
 md_dst = nv_dereference(mdp_dst)

 new_md = md_src
 new_md.crd = md_dst.crd

 new_md.fn_data_p = ptr_copy_recurse(new_md.fn_data_p)
 cor_copy_descriptor, new_md.crd, map_core(mdp_src)

 nv_rereference, mdp_dst, new_md
 nv_notify, mdp_dst
end
;==============================================================================



