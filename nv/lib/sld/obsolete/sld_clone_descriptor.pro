;==============================================================================
;+
; NAME:
;	sld_clone_descriptor
;
;
; PURPOSE:
;       Allocates new solid descriptors as copies of the given
;       (existing) solid descriptors.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	new_sld = sld_clone_descriptor(slx)
;
;
; ARGUMENTS:
;  INPUT:
;	slx:	 Array (nt) of any subclass of SOLID descriptors.
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
;       Newly created solid descriptors with all fields identical to
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
function sld_clone_descriptor, sldp
nv_message, /con, name='sld_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, sldp, type = 1
 sld = nv_dereference(sldp)

 new_sld = sld
 new_sld.bd = bod_clone_descriptor(sld.bd)

 new_sldp = ptrarr(n_elements(sld))
 nv_rereference, new_sldp, new_sld

 return, new_sldp
end
;==============================================================================
