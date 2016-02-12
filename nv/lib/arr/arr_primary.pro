;===========================================================================
;+
; NAME:
;	arr_primary
;
;
; PURPOSE:
;	Returns the primary string for each given array descriptor.
;
;
; CATEGORY:
;	NV/LIB/arr
;
;
; CALLING SEQUENCE:
;	primary = arr_primary(ard)
;
;
; ARGUMENTS:
;  INPUT: 
;	ard:	 Array (nt) of ARRAY descriptors.
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
; RETURN:
;	Primary string associated with each given array descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;===========================================================================
function arr_primary, arxp
@nv_lib.include
 ardp = class_extract(arxp, 'ARRAY')
 nv_notify, ardp, type = 1
 ard = nv_dereference(ardp)
 return, ard.primary
end
;===========================================================================



