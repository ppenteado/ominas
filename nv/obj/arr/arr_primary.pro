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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
function arr_primary, ard, noevent=noevent
@core.include

 nv_notify, ard, type = 1, noevent=noevent
 _ard = cor_dereference(ard)
 return, _ard.primary
end
;===========================================================================



