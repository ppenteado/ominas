;=============================================================================
;+
; NAME:
;	cor_clone_descriptor
;
;
; PURPOSE:
;	Allocates a new core descriptor as a copy of an existing descriptor.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	new_crd = cor_clone_descriptor(crd)
;
;
; ARGUMENTS:
;  INPUT:
;	crd:	 Descriptor of class CORE.
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
;	Newly created core descriptor with all fields identical to the input
;	descriptor.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function cor_clone_descriptor, crdp
nv_message, /con, name='cor_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, crdp, type = 1
 crd = nv_dereference(crdp)

 n = n_elements(crd)

 new_crd = crd
 for i=0, n-1 do new_crd[i].tasks_p = nv_ptr_new(*crd[i].tasks_p)
 for i=0, n-1 do if(keyword_set(new_crd[i].udata_tlp)) then $
                       new_crd[i].udata_tlp = tag_list_clone(crd[i].udata_tlp)
 new_crdp = ptrarr(n_elements(crd))
 nv_rereference, new_crdp, new_crd

 return, new_crdp
end
;==============================================================================


