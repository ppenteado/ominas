;==============================================================================
;+
; NAME:
;	plt_clone_descriptor
;
;
; PURPOSE:
;       Allocates new planet descriptors as copies of the given
;       (existing) planet descriptors.
;
;
; CATEGORY:
;	NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;	new_px = plt_clone_descriptor(px)
;
;
; ARGUMENTS:
;  INPUT:
;	px:	 Array (nt) of any subclass of PLANET.
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
;       Newly created planet descriptors with all fields identical to
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
function plt_clone_descriptor, pdp
nv_message, /con, name='plt_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, pdp, type = 1
 pd = nv_dereference(pdp)

 new_pd = pd
 new_pd.gbd = glb_clone_descriptor(pd.gbd)

 new_pdp = ptrarr(n_elements(pd))
 nv_rereference, new_pdp, new_pd

 return, new_pdp
end
;==============================================================================
