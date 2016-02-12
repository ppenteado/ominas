;==============================================================================
;+
; NAME:
;	glb_clone_descriptor
;
;
; PURPOSE:
;       Allocates new globe descriptors as copies of the given
;       (existing) globe descriptors.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	new_gbd = glb_clone_descriptor(gbx)
;
;
; ARGUMENTS:
;  INPUT:
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
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
;       Newly created globe descriptors with all fields identical to
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
function glb_clone_descriptor, gbdp
nv_message, /con, name='glb_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, gbdp, type = 1
 gbd = nv_dereference(gbdp)

 new_gbd = gbd
 new_gbd.sld = sld_clone_descriptor(gbd.sld)

 new_gbdp = ptrarr(n_elements(gbd))
 nv_rereference, new_gbdp, new_gbd

 return, new_gbdp
end
;==============================================================================
