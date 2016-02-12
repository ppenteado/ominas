;=============================================================================
;+
; NAME:
;	cor_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from one core descriptor into another.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	cor_copy_descriptor, crd_dst, crd_src
;
;
; ARGUMENTS:
;  INPUT:
;	crd_dst:	 Descriptor of class CORE to copy to.
;
;	crd_src:	 Descriptor of class CORE to copy from.
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
pro cor_copy_descriptor, crdp_dst, crdp_src
@nv_lib.include
 nv_notify, crdp_src, type = 1
 new_crd = nv_dereference(crdp_src)

 crd_src = nv_dereference(crdp_src)
 crd_dst = nv_dereference(crdp_dst)
 new_crd.tasks_p = crd_dst.tasks_p
 new_crd.udata_tlp = crd_dst.udata_tlp

 n = n_elements(new_crd)
 for i=0, n-1 do *(new_crd[i].tasks_p) = cor_tasks(crdp_src[i])
 for i=0, n-1 do $
    if(keyword_set(new_crd[i].udata_tlp) $
        AND keyword_set(crd_src[i].udata_tlp)) then $
                      tag_list_copy, new_crd[i].udata_tlp, crd_src[i].udata_tlp

 nv_rereference, crdp_dst, new_crd
 nv_notify, crdp_dst
end
;==============================================================================
