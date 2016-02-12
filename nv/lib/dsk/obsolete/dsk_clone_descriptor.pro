;=============================================================================
;+
; NAME:
;	dsk_clone_descriptor
;
;
; PURPOSE:
;	Allocates a new disk descriptor as a copy of an existing descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	new_dkd = dsk_clone_descriptor(dkd)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Descriptor of class DISK.
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
;	Newly created disk descriptor with all fields identical to the input
;	descriptor.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function dsk_clone_descriptor, dkdp
nv_message, /con, name='dsk_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, dkdp, type = 1
 dkd = nv_dereference(dkdp)

 new_dkd = dkd
 new_dkd.sld = sld_clone_descriptor(dkd.sld)

 new_dkdp = ptrarr(n_elements(dkd))
 nv_rereference, new_dkdp, new_dkd

 return, new_dkdp
end
;==============================================================================
