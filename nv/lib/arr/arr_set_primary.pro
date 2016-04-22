;===========================================================================
;+
; NAME:
;	arr_set_primary
;
;
; PURPOSE:
;	Replaces the primary string in each given array descriptor.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	arr_set_primary, ard, primary
;
;
; ARGUMENTS:
;  INPUT: 
;	ard:	Array (nt) of ARRAY descriptors.
;
;	primary:	Array (nt) of primary strings.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
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
;===========================================================================
pro arr_set_primary, arxp, primary, noevent=noevent
@nv_lib.include
 ardp = class_extract(arxp, 'ARRAY')
 ard = nv_dereference(ardp)

 ard.primary=primary

 nv_rereference, ardp, ard
 nv_notify, ardp, type = 0, noevent=noevent
end
;===========================================================================



