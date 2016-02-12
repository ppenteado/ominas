;==============================================================================
;+
; NAME:
;	stn_clone_descriptor
;
;
; PURPOSE:
;       Allocates new station descriptors as copies of the given
;       (existing) station descriptors.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	new_stx = stn_clone_descriptor(stx)
;
;
; ARGUMENTS:
;  INPUT:
;	stx:	 Array (nt) of any subclass of STATION.
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
;       Newly created station descriptors with all fields identical to
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
function stn_clone_descriptor, stdp
nv_message, /con, name='stn_clone_descriptor', 'This routine is obsolete.  Use NV_CLONE instead.'
@nv_lib.include
 nv_notify, stdp, type = 1
 std = nv_dereference(stdp)

 new_std = std
 new_std.bd = bod_clone_descriptor(std.bd)

 new_stdp = ptrarr(n_elements(std))
 nv_rereference, new_stdp, new_std

 return, new_stdp
end
;==============================================================================
