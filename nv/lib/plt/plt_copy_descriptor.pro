;==============================================================================
;+
; NAME:
;	plt_copy_descriptor
;
;
; PURPOSE:
;	Copies all fields from the source planet descriptors into the
;       destination planet descriptors.
;
;
; CATEGORY:
;	NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;	plt_copy_descriptor, px_dst, px_src
;
;
; ARGUMENTS:
;  INPUT:
;	px_dst:	        Array (nt) of any subclass of PLANET to copy to.
;
;	px_src:	        Array (nt) of any subclass of PLANET to copy from.
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
pro plt_copy_descriptor, pdp_dst, pdp_src
@nv_lib.include
 nv_notify, pdp_src, type = 1
 pd_src = nv_dereference(pdp_src)
 pd_dst = nv_dereference(pdp_dst)

 new_pd = pd_src
 new_pd.gbd = pd_dst.gbd

 glb_copy_descriptor, new_pd.gbd, plt_globe(pdp_src)

 nv_rereference, pdp_dst, new_pd
 nv_notify, pdp_dst
end
;==============================================================================



