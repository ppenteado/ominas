;==============================================================================
;+
; NAME:
;	str_clone_descriptor
;
;
; PURPOSE:
;       Allocates new star descriptors as copies of the given
;       (existing) star descriptors.
;
;
; CATEGORY:
;	NV/LIB/STR
;
;
; CALLING SEQUENCE:
;	new_sx = str_clone_descriptor(sx)
;
;
; ARGUMENTS:
;  INPUT:
;	sx:	 Array (nt) of any subclass of STAR.
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
;       Newly created star descriptors with all fields identical to
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
function str_clone_descriptor, sdp
nv_message, /con, name='str_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, sdp, type = 1
 sd = nv_dereference(sdp)

 new_sd = sd
 new_sd.gbd = glb_clone_descriptor(sd.gbd)

 new_sdp = ptrarr(n_elements(sd))
 nv_rereference, new_sdp, new_sd

 return, new_sdp
end
;==============================================================================
